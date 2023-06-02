
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <MAXVAplus>:
}

// user code should not be able to write to addresses above MAXVA.
void
MAXVAplus(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  //   int xstatus;
  //   wait(&xstatus);
  //   if(xstatus != -1)  // did kernel kill child?
  //     exit(1);
  // }
  printf("ok");
       8:	00006517          	auipc	a0,0x6
       c:	03850513          	addi	a0,a0,56 # 6040 <malloc+0x446>
      10:	00006097          	auipc	ra,0x6
      14:	b2c080e7          	jalr	-1236(ra) # 5b3c <printf>
}
      18:	60a2                	ld	ra,8(sp)
      1a:	6402                	ld	s0,0(sp)
      1c:	0141                	addi	sp,sp,16
      1e:	8082                	ret

0000000000000020 <copyinstr1>:
{
      20:	1141                	addi	sp,sp,-16
      22:	e406                	sd	ra,8(sp)
      24:	e022                	sd	s0,0(sp)
      26:	0800                	addi	s0,sp,16
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      28:	20100593          	li	a1,513
      2c:	4505                	li	a0,1
      2e:	057e                	slli	a0,a0,0x1f
      30:	00005097          	auipc	ra,0x5
      34:	7d4080e7          	jalr	2004(ra) # 5804 <open>
    if(fd >= 0){
      38:	02055063          	bgez	a0,58 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      3c:	20100593          	li	a1,513
      40:	557d                	li	a0,-1
      42:	00005097          	auipc	ra,0x5
      46:	7c2080e7          	jalr	1986(ra) # 5804 <open>
    uint64 addr = addrs[ai];
      4a:	55fd                	li	a1,-1
    if(fd >= 0){
      4c:	00055863          	bgez	a0,5c <copyinstr1+0x3c>
}
      50:	60a2                	ld	ra,8(sp)
      52:	6402                	ld	s0,0(sp)
      54:	0141                	addi	sp,sp,16
      56:	8082                	ret
    uint64 addr = addrs[ai];
      58:	4585                	li	a1,1
      5a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      5c:	862a                	mv	a2,a0
      5e:	00006517          	auipc	a0,0x6
      62:	fea50513          	addi	a0,a0,-22 # 6048 <malloc+0x44e>
      66:	00006097          	auipc	ra,0x6
      6a:	ad6080e7          	jalr	-1322(ra) # 5b3c <printf>
      exit(1);
      6e:	4505                	li	a0,1
      70:	00005097          	auipc	ra,0x5
      74:	754080e7          	jalr	1876(ra) # 57c4 <exit>

0000000000000078 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      78:	00009797          	auipc	a5,0x9
      7c:	56878793          	addi	a5,a5,1384 # 95e0 <uninit>
      80:	0000c697          	auipc	a3,0xc
      84:	c7068693          	addi	a3,a3,-912 # bcf0 <buf>
    if(uninit[i] != '\0'){
      88:	0007c703          	lbu	a4,0(a5)
      8c:	e709                	bnez	a4,96 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      8e:	0785                	addi	a5,a5,1
      90:	fed79ce3          	bne	a5,a3,88 <bsstest+0x10>
      94:	8082                	ret
{
      96:	1141                	addi	sp,sp,-16
      98:	e406                	sd	ra,8(sp)
      9a:	e022                	sd	s0,0(sp)
      9c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      9e:	85aa                	mv	a1,a0
      a0:	00006517          	auipc	a0,0x6
      a4:	fc850513          	addi	a0,a0,-56 # 6068 <malloc+0x46e>
      a8:	00006097          	auipc	ra,0x6
      ac:	a94080e7          	jalr	-1388(ra) # 5b3c <printf>
      exit(1);
      b0:	4505                	li	a0,1
      b2:	00005097          	auipc	ra,0x5
      b6:	712080e7          	jalr	1810(ra) # 57c4 <exit>

00000000000000ba <opentest>:
{
      ba:	1101                	addi	sp,sp,-32
      bc:	ec06                	sd	ra,24(sp)
      be:	e822                	sd	s0,16(sp)
      c0:	e426                	sd	s1,8(sp)
      c2:	1000                	addi	s0,sp,32
      c4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      c6:	4581                	li	a1,0
      c8:	00006517          	auipc	a0,0x6
      cc:	fb850513          	addi	a0,a0,-72 # 6080 <malloc+0x486>
      d0:	00005097          	auipc	ra,0x5
      d4:	734080e7          	jalr	1844(ra) # 5804 <open>
  if(fd < 0){
      d8:	02054663          	bltz	a0,104 <opentest+0x4a>
  close(fd);
      dc:	00005097          	auipc	ra,0x5
      e0:	710080e7          	jalr	1808(ra) # 57ec <close>
  fd = open("doesnotexist", 0);
      e4:	4581                	li	a1,0
      e6:	00006517          	auipc	a0,0x6
      ea:	fba50513          	addi	a0,a0,-70 # 60a0 <malloc+0x4a6>
      ee:	00005097          	auipc	ra,0x5
      f2:	716080e7          	jalr	1814(ra) # 5804 <open>
  if(fd >= 0){
      f6:	02055563          	bgez	a0,120 <opentest+0x66>
}
      fa:	60e2                	ld	ra,24(sp)
      fc:	6442                	ld	s0,16(sp)
      fe:	64a2                	ld	s1,8(sp)
     100:	6105                	addi	sp,sp,32
     102:	8082                	ret
    printf("%s: open echo failed!\n", s);
     104:	85a6                	mv	a1,s1
     106:	00006517          	auipc	a0,0x6
     10a:	f8250513          	addi	a0,a0,-126 # 6088 <malloc+0x48e>
     10e:	00006097          	auipc	ra,0x6
     112:	a2e080e7          	jalr	-1490(ra) # 5b3c <printf>
    exit(1);
     116:	4505                	li	a0,1
     118:	00005097          	auipc	ra,0x5
     11c:	6ac080e7          	jalr	1708(ra) # 57c4 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     120:	85a6                	mv	a1,s1
     122:	00006517          	auipc	a0,0x6
     126:	f8e50513          	addi	a0,a0,-114 # 60b0 <malloc+0x4b6>
     12a:	00006097          	auipc	ra,0x6
     12e:	a12080e7          	jalr	-1518(ra) # 5b3c <printf>
    exit(1);
     132:	4505                	li	a0,1
     134:	00005097          	auipc	ra,0x5
     138:	690080e7          	jalr	1680(ra) # 57c4 <exit>

000000000000013c <truncate2>:
{
     13c:	7179                	addi	sp,sp,-48
     13e:	f406                	sd	ra,40(sp)
     140:	f022                	sd	s0,32(sp)
     142:	ec26                	sd	s1,24(sp)
     144:	e84a                	sd	s2,16(sp)
     146:	e44e                	sd	s3,8(sp)
     148:	1800                	addi	s0,sp,48
     14a:	89aa                	mv	s3,a0
  unlink("truncfile");
     14c:	00006517          	auipc	a0,0x6
     150:	f8c50513          	addi	a0,a0,-116 # 60d8 <malloc+0x4de>
     154:	00005097          	auipc	ra,0x5
     158:	6c0080e7          	jalr	1728(ra) # 5814 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     15c:	60100593          	li	a1,1537
     160:	00006517          	auipc	a0,0x6
     164:	f7850513          	addi	a0,a0,-136 # 60d8 <malloc+0x4de>
     168:	00005097          	auipc	ra,0x5
     16c:	69c080e7          	jalr	1692(ra) # 5804 <open>
     170:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     172:	4611                	li	a2,4
     174:	00006597          	auipc	a1,0x6
     178:	f7458593          	addi	a1,a1,-140 # 60e8 <malloc+0x4ee>
     17c:	00005097          	auipc	ra,0x5
     180:	668080e7          	jalr	1640(ra) # 57e4 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     184:	40100593          	li	a1,1025
     188:	00006517          	auipc	a0,0x6
     18c:	f5050513          	addi	a0,a0,-176 # 60d8 <malloc+0x4de>
     190:	00005097          	auipc	ra,0x5
     194:	674080e7          	jalr	1652(ra) # 5804 <open>
     198:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     19a:	4605                	li	a2,1
     19c:	00006597          	auipc	a1,0x6
     1a0:	f5458593          	addi	a1,a1,-172 # 60f0 <malloc+0x4f6>
     1a4:	8526                	mv	a0,s1
     1a6:	00005097          	auipc	ra,0x5
     1aa:	63e080e7          	jalr	1598(ra) # 57e4 <write>
  if(n != -1){
     1ae:	57fd                	li	a5,-1
     1b0:	02f51b63          	bne	a0,a5,1e6 <truncate2+0xaa>
  unlink("truncfile");
     1b4:	00006517          	auipc	a0,0x6
     1b8:	f2450513          	addi	a0,a0,-220 # 60d8 <malloc+0x4de>
     1bc:	00005097          	auipc	ra,0x5
     1c0:	658080e7          	jalr	1624(ra) # 5814 <unlink>
  close(fd1);
     1c4:	8526                	mv	a0,s1
     1c6:	00005097          	auipc	ra,0x5
     1ca:	626080e7          	jalr	1574(ra) # 57ec <close>
  close(fd2);
     1ce:	854a                	mv	a0,s2
     1d0:	00005097          	auipc	ra,0x5
     1d4:	61c080e7          	jalr	1564(ra) # 57ec <close>
}
     1d8:	70a2                	ld	ra,40(sp)
     1da:	7402                	ld	s0,32(sp)
     1dc:	64e2                	ld	s1,24(sp)
     1de:	6942                	ld	s2,16(sp)
     1e0:	69a2                	ld	s3,8(sp)
     1e2:	6145                	addi	sp,sp,48
     1e4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1e6:	862a                	mv	a2,a0
     1e8:	85ce                	mv	a1,s3
     1ea:	00006517          	auipc	a0,0x6
     1ee:	f0e50513          	addi	a0,a0,-242 # 60f8 <malloc+0x4fe>
     1f2:	00006097          	auipc	ra,0x6
     1f6:	94a080e7          	jalr	-1718(ra) # 5b3c <printf>
    exit(1);
     1fa:	4505                	li	a0,1
     1fc:	00005097          	auipc	ra,0x5
     200:	5c8080e7          	jalr	1480(ra) # 57c4 <exit>

0000000000000204 <createtest>:
{
     204:	7179                	addi	sp,sp,-48
     206:	f406                	sd	ra,40(sp)
     208:	f022                	sd	s0,32(sp)
     20a:	ec26                	sd	s1,24(sp)
     20c:	e84a                	sd	s2,16(sp)
     20e:	1800                	addi	s0,sp,48
  name[0] = 'a';
     210:	06100793          	li	a5,97
     214:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     218:	fc040d23          	sb	zero,-38(s0)
     21c:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     220:	06400913          	li	s2,100
    name[1] = '0' + i;
     224:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     228:	20200593          	li	a1,514
     22c:	fd840513          	addi	a0,s0,-40
     230:	00005097          	auipc	ra,0x5
     234:	5d4080e7          	jalr	1492(ra) # 5804 <open>
    close(fd);
     238:	00005097          	auipc	ra,0x5
     23c:	5b4080e7          	jalr	1460(ra) # 57ec <close>
  for(i = 0; i < N; i++){
     240:	2485                	addiw	s1,s1,1
     242:	0ff4f493          	andi	s1,s1,255
     246:	fd249fe3          	bne	s1,s2,224 <createtest+0x20>
  name[0] = 'a';
     24a:	06100793          	li	a5,97
     24e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     252:	fc040d23          	sb	zero,-38(s0)
     256:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     25a:	06400913          	li	s2,100
    name[1] = '0' + i;
     25e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     262:	fd840513          	addi	a0,s0,-40
     266:	00005097          	auipc	ra,0x5
     26a:	5ae080e7          	jalr	1454(ra) # 5814 <unlink>
  for(i = 0; i < N; i++){
     26e:	2485                	addiw	s1,s1,1
     270:	0ff4f493          	andi	s1,s1,255
     274:	ff2495e3          	bne	s1,s2,25e <createtest+0x5a>
}
     278:	70a2                	ld	ra,40(sp)
     27a:	7402                	ld	s0,32(sp)
     27c:	64e2                	ld	s1,24(sp)
     27e:	6942                	ld	s2,16(sp)
     280:	6145                	addi	sp,sp,48
     282:	8082                	ret

0000000000000284 <bigwrite>:
{
     284:	715d                	addi	sp,sp,-80
     286:	e486                	sd	ra,72(sp)
     288:	e0a2                	sd	s0,64(sp)
     28a:	fc26                	sd	s1,56(sp)
     28c:	f84a                	sd	s2,48(sp)
     28e:	f44e                	sd	s3,40(sp)
     290:	f052                	sd	s4,32(sp)
     292:	ec56                	sd	s5,24(sp)
     294:	e85a                	sd	s6,16(sp)
     296:	e45e                	sd	s7,8(sp)
     298:	0880                	addi	s0,sp,80
     29a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     29c:	00006517          	auipc	a0,0x6
     2a0:	c2450513          	addi	a0,a0,-988 # 5ec0 <malloc+0x2c6>
     2a4:	00005097          	auipc	ra,0x5
     2a8:	570080e7          	jalr	1392(ra) # 5814 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2ac:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2b0:	00006a97          	auipc	s5,0x6
     2b4:	c10a8a93          	addi	s5,s5,-1008 # 5ec0 <malloc+0x2c6>
      int cc = write(fd, buf, sz);
     2b8:	0000ca17          	auipc	s4,0xc
     2bc:	a38a0a13          	addi	s4,s4,-1480 # bcf0 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2c0:	6b0d                	lui	s6,0x3
     2c2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <subdir+0x47>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2c6:	20200593          	li	a1,514
     2ca:	8556                	mv	a0,s5
     2cc:	00005097          	auipc	ra,0x5
     2d0:	538080e7          	jalr	1336(ra) # 5804 <open>
     2d4:	892a                	mv	s2,a0
    if(fd < 0){
     2d6:	04054d63          	bltz	a0,330 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2da:	8626                	mv	a2,s1
     2dc:	85d2                	mv	a1,s4
     2de:	00005097          	auipc	ra,0x5
     2e2:	506080e7          	jalr	1286(ra) # 57e4 <write>
     2e6:	89aa                	mv	s3,a0
      if(cc != sz){
     2e8:	06a49463          	bne	s1,a0,350 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     2ec:	8626                	mv	a2,s1
     2ee:	85d2                	mv	a1,s4
     2f0:	854a                	mv	a0,s2
     2f2:	00005097          	auipc	ra,0x5
     2f6:	4f2080e7          	jalr	1266(ra) # 57e4 <write>
      if(cc != sz){
     2fa:	04951963          	bne	a0,s1,34c <bigwrite+0xc8>
    close(fd);
     2fe:	854a                	mv	a0,s2
     300:	00005097          	auipc	ra,0x5
     304:	4ec080e7          	jalr	1260(ra) # 57ec <close>
    unlink("bigwrite");
     308:	8556                	mv	a0,s5
     30a:	00005097          	auipc	ra,0x5
     30e:	50a080e7          	jalr	1290(ra) # 5814 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     312:	1d74849b          	addiw	s1,s1,471
     316:	fb6498e3          	bne	s1,s6,2c6 <bigwrite+0x42>
}
     31a:	60a6                	ld	ra,72(sp)
     31c:	6406                	ld	s0,64(sp)
     31e:	74e2                	ld	s1,56(sp)
     320:	7942                	ld	s2,48(sp)
     322:	79a2                	ld	s3,40(sp)
     324:	7a02                	ld	s4,32(sp)
     326:	6ae2                	ld	s5,24(sp)
     328:	6b42                	ld	s6,16(sp)
     32a:	6ba2                	ld	s7,8(sp)
     32c:	6161                	addi	sp,sp,80
     32e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     330:	85de                	mv	a1,s7
     332:	00006517          	auipc	a0,0x6
     336:	dee50513          	addi	a0,a0,-530 # 6120 <malloc+0x526>
     33a:	00006097          	auipc	ra,0x6
     33e:	802080e7          	jalr	-2046(ra) # 5b3c <printf>
      exit(1);
     342:	4505                	li	a0,1
     344:	00005097          	auipc	ra,0x5
     348:	480080e7          	jalr	1152(ra) # 57c4 <exit>
     34c:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     34e:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     350:	86ce                	mv	a3,s3
     352:	8626                	mv	a2,s1
     354:	85de                	mv	a1,s7
     356:	00006517          	auipc	a0,0x6
     35a:	dea50513          	addi	a0,a0,-534 # 6140 <malloc+0x546>
     35e:	00005097          	auipc	ra,0x5
     362:	7de080e7          	jalr	2014(ra) # 5b3c <printf>
        exit(1);
     366:	4505                	li	a0,1
     368:	00005097          	auipc	ra,0x5
     36c:	45c080e7          	jalr	1116(ra) # 57c4 <exit>

0000000000000370 <copyin>:
{
     370:	715d                	addi	sp,sp,-80
     372:	e486                	sd	ra,72(sp)
     374:	e0a2                	sd	s0,64(sp)
     376:	fc26                	sd	s1,56(sp)
     378:	f84a                	sd	s2,48(sp)
     37a:	f44e                	sd	s3,40(sp)
     37c:	f052                	sd	s4,32(sp)
     37e:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     380:	4785                	li	a5,1
     382:	07fe                	slli	a5,a5,0x1f
     384:	fcf43023          	sd	a5,-64(s0)
     388:	57fd                	li	a5,-1
     38a:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     38e:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     392:	00006a17          	auipc	s4,0x6
     396:	dc6a0a13          	addi	s4,s4,-570 # 6158 <malloc+0x55e>
    uint64 addr = addrs[ai];
     39a:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     39e:	20100593          	li	a1,513
     3a2:	8552                	mv	a0,s4
     3a4:	00005097          	auipc	ra,0x5
     3a8:	460080e7          	jalr	1120(ra) # 5804 <open>
     3ac:	84aa                	mv	s1,a0
    if(fd < 0){
     3ae:	08054863          	bltz	a0,43e <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     3b2:	6609                	lui	a2,0x2
     3b4:	85ce                	mv	a1,s3
     3b6:	00005097          	auipc	ra,0x5
     3ba:	42e080e7          	jalr	1070(ra) # 57e4 <write>
    if(n >= 0){
     3be:	08055d63          	bgez	a0,458 <copyin+0xe8>
    close(fd);
     3c2:	8526                	mv	a0,s1
     3c4:	00005097          	auipc	ra,0x5
     3c8:	428080e7          	jalr	1064(ra) # 57ec <close>
    unlink("copyin1");
     3cc:	8552                	mv	a0,s4
     3ce:	00005097          	auipc	ra,0x5
     3d2:	446080e7          	jalr	1094(ra) # 5814 <unlink>
    n = write(1, (char*)addr, 8192);
     3d6:	6609                	lui	a2,0x2
     3d8:	85ce                	mv	a1,s3
     3da:	4505                	li	a0,1
     3dc:	00005097          	auipc	ra,0x5
     3e0:	408080e7          	jalr	1032(ra) # 57e4 <write>
    if(n > 0){
     3e4:	08a04963          	bgtz	a0,476 <copyin+0x106>
    if(pipe(fds) < 0){
     3e8:	fb840513          	addi	a0,s0,-72
     3ec:	00005097          	auipc	ra,0x5
     3f0:	3e8080e7          	jalr	1000(ra) # 57d4 <pipe>
     3f4:	0a054063          	bltz	a0,494 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     3f8:	6609                	lui	a2,0x2
     3fa:	85ce                	mv	a1,s3
     3fc:	fbc42503          	lw	a0,-68(s0)
     400:	00005097          	auipc	ra,0x5
     404:	3e4080e7          	jalr	996(ra) # 57e4 <write>
    if(n > 0){
     408:	0aa04363          	bgtz	a0,4ae <copyin+0x13e>
    close(fds[0]);
     40c:	fb842503          	lw	a0,-72(s0)
     410:	00005097          	auipc	ra,0x5
     414:	3dc080e7          	jalr	988(ra) # 57ec <close>
    close(fds[1]);
     418:	fbc42503          	lw	a0,-68(s0)
     41c:	00005097          	auipc	ra,0x5
     420:	3d0080e7          	jalr	976(ra) # 57ec <close>
  for(int ai = 0; ai < 2; ai++){
     424:	0921                	addi	s2,s2,8
     426:	fd040793          	addi	a5,s0,-48
     42a:	f6f918e3          	bne	s2,a5,39a <copyin+0x2a>
}
     42e:	60a6                	ld	ra,72(sp)
     430:	6406                	ld	s0,64(sp)
     432:	74e2                	ld	s1,56(sp)
     434:	7942                	ld	s2,48(sp)
     436:	79a2                	ld	s3,40(sp)
     438:	7a02                	ld	s4,32(sp)
     43a:	6161                	addi	sp,sp,80
     43c:	8082                	ret
      printf("open(copyin1) failed\n");
     43e:	00006517          	auipc	a0,0x6
     442:	d2250513          	addi	a0,a0,-734 # 6160 <malloc+0x566>
     446:	00005097          	auipc	ra,0x5
     44a:	6f6080e7          	jalr	1782(ra) # 5b3c <printf>
      exit(1);
     44e:	4505                	li	a0,1
     450:	00005097          	auipc	ra,0x5
     454:	374080e7          	jalr	884(ra) # 57c4 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     458:	862a                	mv	a2,a0
     45a:	85ce                	mv	a1,s3
     45c:	00006517          	auipc	a0,0x6
     460:	d1c50513          	addi	a0,a0,-740 # 6178 <malloc+0x57e>
     464:	00005097          	auipc	ra,0x5
     468:	6d8080e7          	jalr	1752(ra) # 5b3c <printf>
      exit(1);
     46c:	4505                	li	a0,1
     46e:	00005097          	auipc	ra,0x5
     472:	356080e7          	jalr	854(ra) # 57c4 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     476:	862a                	mv	a2,a0
     478:	85ce                	mv	a1,s3
     47a:	00006517          	auipc	a0,0x6
     47e:	d2e50513          	addi	a0,a0,-722 # 61a8 <malloc+0x5ae>
     482:	00005097          	auipc	ra,0x5
     486:	6ba080e7          	jalr	1722(ra) # 5b3c <printf>
      exit(1);
     48a:	4505                	li	a0,1
     48c:	00005097          	auipc	ra,0x5
     490:	338080e7          	jalr	824(ra) # 57c4 <exit>
      printf("pipe() failed\n");
     494:	00006517          	auipc	a0,0x6
     498:	d4450513          	addi	a0,a0,-700 # 61d8 <malloc+0x5de>
     49c:	00005097          	auipc	ra,0x5
     4a0:	6a0080e7          	jalr	1696(ra) # 5b3c <printf>
      exit(1);
     4a4:	4505                	li	a0,1
     4a6:	00005097          	auipc	ra,0x5
     4aa:	31e080e7          	jalr	798(ra) # 57c4 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     4ae:	862a                	mv	a2,a0
     4b0:	85ce                	mv	a1,s3
     4b2:	00006517          	auipc	a0,0x6
     4b6:	d3650513          	addi	a0,a0,-714 # 61e8 <malloc+0x5ee>
     4ba:	00005097          	auipc	ra,0x5
     4be:	682080e7          	jalr	1666(ra) # 5b3c <printf>
      exit(1);
     4c2:	4505                	li	a0,1
     4c4:	00005097          	auipc	ra,0x5
     4c8:	300080e7          	jalr	768(ra) # 57c4 <exit>

00000000000004cc <copyout>:
{
     4cc:	711d                	addi	sp,sp,-96
     4ce:	ec86                	sd	ra,88(sp)
     4d0:	e8a2                	sd	s0,80(sp)
     4d2:	e4a6                	sd	s1,72(sp)
     4d4:	e0ca                	sd	s2,64(sp)
     4d6:	fc4e                	sd	s3,56(sp)
     4d8:	f852                	sd	s4,48(sp)
     4da:	f456                	sd	s5,40(sp)
     4dc:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     4de:	4785                	li	a5,1
     4e0:	07fe                	slli	a5,a5,0x1f
     4e2:	faf43823          	sd	a5,-80(s0)
     4e6:	57fd                	li	a5,-1
     4e8:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     4ec:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     4f0:	00006a17          	auipc	s4,0x6
     4f4:	d28a0a13          	addi	s4,s4,-728 # 6218 <malloc+0x61e>
    n = write(fds[1], "x", 1);
     4f8:	00006a97          	auipc	s5,0x6
     4fc:	bf8a8a93          	addi	s5,s5,-1032 # 60f0 <malloc+0x4f6>
    uint64 addr = addrs[ai];
     500:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     504:	4581                	li	a1,0
     506:	8552                	mv	a0,s4
     508:	00005097          	auipc	ra,0x5
     50c:	2fc080e7          	jalr	764(ra) # 5804 <open>
     510:	84aa                	mv	s1,a0
    if(fd < 0){
     512:	08054663          	bltz	a0,59e <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     516:	6609                	lui	a2,0x2
     518:	85ce                	mv	a1,s3
     51a:	00005097          	auipc	ra,0x5
     51e:	2c2080e7          	jalr	706(ra) # 57dc <read>
    if(n > 0){
     522:	08a04b63          	bgtz	a0,5b8 <copyout+0xec>
    close(fd);
     526:	8526                	mv	a0,s1
     528:	00005097          	auipc	ra,0x5
     52c:	2c4080e7          	jalr	708(ra) # 57ec <close>
    if(pipe(fds) < 0){
     530:	fa840513          	addi	a0,s0,-88
     534:	00005097          	auipc	ra,0x5
     538:	2a0080e7          	jalr	672(ra) # 57d4 <pipe>
     53c:	08054d63          	bltz	a0,5d6 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     540:	4605                	li	a2,1
     542:	85d6                	mv	a1,s5
     544:	fac42503          	lw	a0,-84(s0)
     548:	00005097          	auipc	ra,0x5
     54c:	29c080e7          	jalr	668(ra) # 57e4 <write>
    if(n != 1){
     550:	4785                	li	a5,1
     552:	08f51f63          	bne	a0,a5,5f0 <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     556:	6609                	lui	a2,0x2
     558:	85ce                	mv	a1,s3
     55a:	fa842503          	lw	a0,-88(s0)
     55e:	00005097          	auipc	ra,0x5
     562:	27e080e7          	jalr	638(ra) # 57dc <read>
    if(n > 0){
     566:	0aa04263          	bgtz	a0,60a <copyout+0x13e>
    close(fds[0]);
     56a:	fa842503          	lw	a0,-88(s0)
     56e:	00005097          	auipc	ra,0x5
     572:	27e080e7          	jalr	638(ra) # 57ec <close>
    close(fds[1]);
     576:	fac42503          	lw	a0,-84(s0)
     57a:	00005097          	auipc	ra,0x5
     57e:	272080e7          	jalr	626(ra) # 57ec <close>
  for(int ai = 0; ai < 2; ai++){
     582:	0921                	addi	s2,s2,8
     584:	fc040793          	addi	a5,s0,-64
     588:	f6f91ce3          	bne	s2,a5,500 <copyout+0x34>
}
     58c:	60e6                	ld	ra,88(sp)
     58e:	6446                	ld	s0,80(sp)
     590:	64a6                	ld	s1,72(sp)
     592:	6906                	ld	s2,64(sp)
     594:	79e2                	ld	s3,56(sp)
     596:	7a42                	ld	s4,48(sp)
     598:	7aa2                	ld	s5,40(sp)
     59a:	6125                	addi	sp,sp,96
     59c:	8082                	ret
      printf("open(README) failed\n");
     59e:	00006517          	auipc	a0,0x6
     5a2:	c8250513          	addi	a0,a0,-894 # 6220 <malloc+0x626>
     5a6:	00005097          	auipc	ra,0x5
     5aa:	596080e7          	jalr	1430(ra) # 5b3c <printf>
      exit(1);
     5ae:	4505                	li	a0,1
     5b0:	00005097          	auipc	ra,0x5
     5b4:	214080e7          	jalr	532(ra) # 57c4 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5b8:	862a                	mv	a2,a0
     5ba:	85ce                	mv	a1,s3
     5bc:	00006517          	auipc	a0,0x6
     5c0:	c7c50513          	addi	a0,a0,-900 # 6238 <malloc+0x63e>
     5c4:	00005097          	auipc	ra,0x5
     5c8:	578080e7          	jalr	1400(ra) # 5b3c <printf>
      exit(1);
     5cc:	4505                	li	a0,1
     5ce:	00005097          	auipc	ra,0x5
     5d2:	1f6080e7          	jalr	502(ra) # 57c4 <exit>
      printf("pipe() failed\n");
     5d6:	00006517          	auipc	a0,0x6
     5da:	c0250513          	addi	a0,a0,-1022 # 61d8 <malloc+0x5de>
     5de:	00005097          	auipc	ra,0x5
     5e2:	55e080e7          	jalr	1374(ra) # 5b3c <printf>
      exit(1);
     5e6:	4505                	li	a0,1
     5e8:	00005097          	auipc	ra,0x5
     5ec:	1dc080e7          	jalr	476(ra) # 57c4 <exit>
      printf("pipe write failed\n");
     5f0:	00006517          	auipc	a0,0x6
     5f4:	c7850513          	addi	a0,a0,-904 # 6268 <malloc+0x66e>
     5f8:	00005097          	auipc	ra,0x5
     5fc:	544080e7          	jalr	1348(ra) # 5b3c <printf>
      exit(1);
     600:	4505                	li	a0,1
     602:	00005097          	auipc	ra,0x5
     606:	1c2080e7          	jalr	450(ra) # 57c4 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     60a:	862a                	mv	a2,a0
     60c:	85ce                	mv	a1,s3
     60e:	00006517          	auipc	a0,0x6
     612:	c7250513          	addi	a0,a0,-910 # 6280 <malloc+0x686>
     616:	00005097          	auipc	ra,0x5
     61a:	526080e7          	jalr	1318(ra) # 5b3c <printf>
      exit(1);
     61e:	4505                	li	a0,1
     620:	00005097          	auipc	ra,0x5
     624:	1a4080e7          	jalr	420(ra) # 57c4 <exit>

0000000000000628 <truncate1>:
{
     628:	711d                	addi	sp,sp,-96
     62a:	ec86                	sd	ra,88(sp)
     62c:	e8a2                	sd	s0,80(sp)
     62e:	e4a6                	sd	s1,72(sp)
     630:	e0ca                	sd	s2,64(sp)
     632:	fc4e                	sd	s3,56(sp)
     634:	f852                	sd	s4,48(sp)
     636:	f456                	sd	s5,40(sp)
     638:	1080                	addi	s0,sp,96
     63a:	8aaa                	mv	s5,a0
  unlink("truncfile");
     63c:	00006517          	auipc	a0,0x6
     640:	a9c50513          	addi	a0,a0,-1380 # 60d8 <malloc+0x4de>
     644:	00005097          	auipc	ra,0x5
     648:	1d0080e7          	jalr	464(ra) # 5814 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     64c:	60100593          	li	a1,1537
     650:	00006517          	auipc	a0,0x6
     654:	a8850513          	addi	a0,a0,-1400 # 60d8 <malloc+0x4de>
     658:	00005097          	auipc	ra,0x5
     65c:	1ac080e7          	jalr	428(ra) # 5804 <open>
     660:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     662:	4611                	li	a2,4
     664:	00006597          	auipc	a1,0x6
     668:	a8458593          	addi	a1,a1,-1404 # 60e8 <malloc+0x4ee>
     66c:	00005097          	auipc	ra,0x5
     670:	178080e7          	jalr	376(ra) # 57e4 <write>
  close(fd1);
     674:	8526                	mv	a0,s1
     676:	00005097          	auipc	ra,0x5
     67a:	176080e7          	jalr	374(ra) # 57ec <close>
  int fd2 = open("truncfile", O_RDONLY);
     67e:	4581                	li	a1,0
     680:	00006517          	auipc	a0,0x6
     684:	a5850513          	addi	a0,a0,-1448 # 60d8 <malloc+0x4de>
     688:	00005097          	auipc	ra,0x5
     68c:	17c080e7          	jalr	380(ra) # 5804 <open>
     690:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     692:	02000613          	li	a2,32
     696:	fa040593          	addi	a1,s0,-96
     69a:	00005097          	auipc	ra,0x5
     69e:	142080e7          	jalr	322(ra) # 57dc <read>
  if(n != 4){
     6a2:	4791                	li	a5,4
     6a4:	0cf51e63          	bne	a0,a5,780 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     6a8:	40100593          	li	a1,1025
     6ac:	00006517          	auipc	a0,0x6
     6b0:	a2c50513          	addi	a0,a0,-1492 # 60d8 <malloc+0x4de>
     6b4:	00005097          	auipc	ra,0x5
     6b8:	150080e7          	jalr	336(ra) # 5804 <open>
     6bc:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     6be:	4581                	li	a1,0
     6c0:	00006517          	auipc	a0,0x6
     6c4:	a1850513          	addi	a0,a0,-1512 # 60d8 <malloc+0x4de>
     6c8:	00005097          	auipc	ra,0x5
     6cc:	13c080e7          	jalr	316(ra) # 5804 <open>
     6d0:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     6d2:	02000613          	li	a2,32
     6d6:	fa040593          	addi	a1,s0,-96
     6da:	00005097          	auipc	ra,0x5
     6de:	102080e7          	jalr	258(ra) # 57dc <read>
     6e2:	8a2a                	mv	s4,a0
  if(n != 0){
     6e4:	ed4d                	bnez	a0,79e <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     6e6:	02000613          	li	a2,32
     6ea:	fa040593          	addi	a1,s0,-96
     6ee:	8526                	mv	a0,s1
     6f0:	00005097          	auipc	ra,0x5
     6f4:	0ec080e7          	jalr	236(ra) # 57dc <read>
     6f8:	8a2a                	mv	s4,a0
  if(n != 0){
     6fa:	e971                	bnez	a0,7ce <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     6fc:	4619                	li	a2,6
     6fe:	00006597          	auipc	a1,0x6
     702:	c1258593          	addi	a1,a1,-1006 # 6310 <malloc+0x716>
     706:	854e                	mv	a0,s3
     708:	00005097          	auipc	ra,0x5
     70c:	0dc080e7          	jalr	220(ra) # 57e4 <write>
  n = read(fd3, buf, sizeof(buf));
     710:	02000613          	li	a2,32
     714:	fa040593          	addi	a1,s0,-96
     718:	854a                	mv	a0,s2
     71a:	00005097          	auipc	ra,0x5
     71e:	0c2080e7          	jalr	194(ra) # 57dc <read>
  if(n != 6){
     722:	4799                	li	a5,6
     724:	0cf51d63          	bne	a0,a5,7fe <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     728:	02000613          	li	a2,32
     72c:	fa040593          	addi	a1,s0,-96
     730:	8526                	mv	a0,s1
     732:	00005097          	auipc	ra,0x5
     736:	0aa080e7          	jalr	170(ra) # 57dc <read>
  if(n != 2){
     73a:	4789                	li	a5,2
     73c:	0ef51063          	bne	a0,a5,81c <truncate1+0x1f4>
  unlink("truncfile");
     740:	00006517          	auipc	a0,0x6
     744:	99850513          	addi	a0,a0,-1640 # 60d8 <malloc+0x4de>
     748:	00005097          	auipc	ra,0x5
     74c:	0cc080e7          	jalr	204(ra) # 5814 <unlink>
  close(fd1);
     750:	854e                	mv	a0,s3
     752:	00005097          	auipc	ra,0x5
     756:	09a080e7          	jalr	154(ra) # 57ec <close>
  close(fd2);
     75a:	8526                	mv	a0,s1
     75c:	00005097          	auipc	ra,0x5
     760:	090080e7          	jalr	144(ra) # 57ec <close>
  close(fd3);
     764:	854a                	mv	a0,s2
     766:	00005097          	auipc	ra,0x5
     76a:	086080e7          	jalr	134(ra) # 57ec <close>
}
     76e:	60e6                	ld	ra,88(sp)
     770:	6446                	ld	s0,80(sp)
     772:	64a6                	ld	s1,72(sp)
     774:	6906                	ld	s2,64(sp)
     776:	79e2                	ld	s3,56(sp)
     778:	7a42                	ld	s4,48(sp)
     77a:	7aa2                	ld	s5,40(sp)
     77c:	6125                	addi	sp,sp,96
     77e:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     780:	862a                	mv	a2,a0
     782:	85d6                	mv	a1,s5
     784:	00006517          	auipc	a0,0x6
     788:	b2c50513          	addi	a0,a0,-1236 # 62b0 <malloc+0x6b6>
     78c:	00005097          	auipc	ra,0x5
     790:	3b0080e7          	jalr	944(ra) # 5b3c <printf>
    exit(1);
     794:	4505                	li	a0,1
     796:	00005097          	auipc	ra,0x5
     79a:	02e080e7          	jalr	46(ra) # 57c4 <exit>
    printf("aaa fd3=%d\n", fd3);
     79e:	85ca                	mv	a1,s2
     7a0:	00006517          	auipc	a0,0x6
     7a4:	b3050513          	addi	a0,a0,-1232 # 62d0 <malloc+0x6d6>
     7a8:	00005097          	auipc	ra,0x5
     7ac:	394080e7          	jalr	916(ra) # 5b3c <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7b0:	8652                	mv	a2,s4
     7b2:	85d6                	mv	a1,s5
     7b4:	00006517          	auipc	a0,0x6
     7b8:	b2c50513          	addi	a0,a0,-1236 # 62e0 <malloc+0x6e6>
     7bc:	00005097          	auipc	ra,0x5
     7c0:	380080e7          	jalr	896(ra) # 5b3c <printf>
    exit(1);
     7c4:	4505                	li	a0,1
     7c6:	00005097          	auipc	ra,0x5
     7ca:	ffe080e7          	jalr	-2(ra) # 57c4 <exit>
    printf("bbb fd2=%d\n", fd2);
     7ce:	85a6                	mv	a1,s1
     7d0:	00006517          	auipc	a0,0x6
     7d4:	b3050513          	addi	a0,a0,-1232 # 6300 <malloc+0x706>
     7d8:	00005097          	auipc	ra,0x5
     7dc:	364080e7          	jalr	868(ra) # 5b3c <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7e0:	8652                	mv	a2,s4
     7e2:	85d6                	mv	a1,s5
     7e4:	00006517          	auipc	a0,0x6
     7e8:	afc50513          	addi	a0,a0,-1284 # 62e0 <malloc+0x6e6>
     7ec:	00005097          	auipc	ra,0x5
     7f0:	350080e7          	jalr	848(ra) # 5b3c <printf>
    exit(1);
     7f4:	4505                	li	a0,1
     7f6:	00005097          	auipc	ra,0x5
     7fa:	fce080e7          	jalr	-50(ra) # 57c4 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     7fe:	862a                	mv	a2,a0
     800:	85d6                	mv	a1,s5
     802:	00006517          	auipc	a0,0x6
     806:	b1650513          	addi	a0,a0,-1258 # 6318 <malloc+0x71e>
     80a:	00005097          	auipc	ra,0x5
     80e:	332080e7          	jalr	818(ra) # 5b3c <printf>
    exit(1);
     812:	4505                	li	a0,1
     814:	00005097          	auipc	ra,0x5
     818:	fb0080e7          	jalr	-80(ra) # 57c4 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     81c:	862a                	mv	a2,a0
     81e:	85d6                	mv	a1,s5
     820:	00006517          	auipc	a0,0x6
     824:	b1850513          	addi	a0,a0,-1256 # 6338 <malloc+0x73e>
     828:	00005097          	auipc	ra,0x5
     82c:	314080e7          	jalr	788(ra) # 5b3c <printf>
    exit(1);
     830:	4505                	li	a0,1
     832:	00005097          	auipc	ra,0x5
     836:	f92080e7          	jalr	-110(ra) # 57c4 <exit>

000000000000083a <writetest>:
{
     83a:	7139                	addi	sp,sp,-64
     83c:	fc06                	sd	ra,56(sp)
     83e:	f822                	sd	s0,48(sp)
     840:	f426                	sd	s1,40(sp)
     842:	f04a                	sd	s2,32(sp)
     844:	ec4e                	sd	s3,24(sp)
     846:	e852                	sd	s4,16(sp)
     848:	e456                	sd	s5,8(sp)
     84a:	e05a                	sd	s6,0(sp)
     84c:	0080                	addi	s0,sp,64
     84e:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     850:	20200593          	li	a1,514
     854:	00006517          	auipc	a0,0x6
     858:	b0450513          	addi	a0,a0,-1276 # 6358 <malloc+0x75e>
     85c:	00005097          	auipc	ra,0x5
     860:	fa8080e7          	jalr	-88(ra) # 5804 <open>
  if(fd < 0){
     864:	0a054d63          	bltz	a0,91e <writetest+0xe4>
     868:	892a                	mv	s2,a0
     86a:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     86c:	00006997          	auipc	s3,0x6
     870:	b1498993          	addi	s3,s3,-1260 # 6380 <malloc+0x786>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     874:	00006a97          	auipc	s5,0x6
     878:	b44a8a93          	addi	s5,s5,-1212 # 63b8 <malloc+0x7be>
  for(i = 0; i < N; i++){
     87c:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     880:	4629                	li	a2,10
     882:	85ce                	mv	a1,s3
     884:	854a                	mv	a0,s2
     886:	00005097          	auipc	ra,0x5
     88a:	f5e080e7          	jalr	-162(ra) # 57e4 <write>
     88e:	47a9                	li	a5,10
     890:	0af51563          	bne	a0,a5,93a <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     894:	4629                	li	a2,10
     896:	85d6                	mv	a1,s5
     898:	854a                	mv	a0,s2
     89a:	00005097          	auipc	ra,0x5
     89e:	f4a080e7          	jalr	-182(ra) # 57e4 <write>
     8a2:	47a9                	li	a5,10
     8a4:	0af51a63          	bne	a0,a5,958 <writetest+0x11e>
  for(i = 0; i < N; i++){
     8a8:	2485                	addiw	s1,s1,1
     8aa:	fd449be3          	bne	s1,s4,880 <writetest+0x46>
  close(fd);
     8ae:	854a                	mv	a0,s2
     8b0:	00005097          	auipc	ra,0x5
     8b4:	f3c080e7          	jalr	-196(ra) # 57ec <close>
  fd = open("small", O_RDONLY);
     8b8:	4581                	li	a1,0
     8ba:	00006517          	auipc	a0,0x6
     8be:	a9e50513          	addi	a0,a0,-1378 # 6358 <malloc+0x75e>
     8c2:	00005097          	auipc	ra,0x5
     8c6:	f42080e7          	jalr	-190(ra) # 5804 <open>
     8ca:	84aa                	mv	s1,a0
  if(fd < 0){
     8cc:	0a054563          	bltz	a0,976 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     8d0:	7d000613          	li	a2,2000
     8d4:	0000b597          	auipc	a1,0xb
     8d8:	41c58593          	addi	a1,a1,1052 # bcf0 <buf>
     8dc:	00005097          	auipc	ra,0x5
     8e0:	f00080e7          	jalr	-256(ra) # 57dc <read>
  if(i != N*SZ*2){
     8e4:	7d000793          	li	a5,2000
     8e8:	0af51563          	bne	a0,a5,992 <writetest+0x158>
  close(fd);
     8ec:	8526                	mv	a0,s1
     8ee:	00005097          	auipc	ra,0x5
     8f2:	efe080e7          	jalr	-258(ra) # 57ec <close>
  if(unlink("small") < 0){
     8f6:	00006517          	auipc	a0,0x6
     8fa:	a6250513          	addi	a0,a0,-1438 # 6358 <malloc+0x75e>
     8fe:	00005097          	auipc	ra,0x5
     902:	f16080e7          	jalr	-234(ra) # 5814 <unlink>
     906:	0a054463          	bltz	a0,9ae <writetest+0x174>
}
     90a:	70e2                	ld	ra,56(sp)
     90c:	7442                	ld	s0,48(sp)
     90e:	74a2                	ld	s1,40(sp)
     910:	7902                	ld	s2,32(sp)
     912:	69e2                	ld	s3,24(sp)
     914:	6a42                	ld	s4,16(sp)
     916:	6aa2                	ld	s5,8(sp)
     918:	6b02                	ld	s6,0(sp)
     91a:	6121                	addi	sp,sp,64
     91c:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     91e:	85da                	mv	a1,s6
     920:	00006517          	auipc	a0,0x6
     924:	a4050513          	addi	a0,a0,-1472 # 6360 <malloc+0x766>
     928:	00005097          	auipc	ra,0x5
     92c:	214080e7          	jalr	532(ra) # 5b3c <printf>
    exit(1);
     930:	4505                	li	a0,1
     932:	00005097          	auipc	ra,0x5
     936:	e92080e7          	jalr	-366(ra) # 57c4 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     93a:	8626                	mv	a2,s1
     93c:	85da                	mv	a1,s6
     93e:	00006517          	auipc	a0,0x6
     942:	a5250513          	addi	a0,a0,-1454 # 6390 <malloc+0x796>
     946:	00005097          	auipc	ra,0x5
     94a:	1f6080e7          	jalr	502(ra) # 5b3c <printf>
      exit(1);
     94e:	4505                	li	a0,1
     950:	00005097          	auipc	ra,0x5
     954:	e74080e7          	jalr	-396(ra) # 57c4 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     958:	8626                	mv	a2,s1
     95a:	85da                	mv	a1,s6
     95c:	00006517          	auipc	a0,0x6
     960:	a6c50513          	addi	a0,a0,-1428 # 63c8 <malloc+0x7ce>
     964:	00005097          	auipc	ra,0x5
     968:	1d8080e7          	jalr	472(ra) # 5b3c <printf>
      exit(1);
     96c:	4505                	li	a0,1
     96e:	00005097          	auipc	ra,0x5
     972:	e56080e7          	jalr	-426(ra) # 57c4 <exit>
    printf("%s: error: open small failed!\n", s);
     976:	85da                	mv	a1,s6
     978:	00006517          	auipc	a0,0x6
     97c:	a7850513          	addi	a0,a0,-1416 # 63f0 <malloc+0x7f6>
     980:	00005097          	auipc	ra,0x5
     984:	1bc080e7          	jalr	444(ra) # 5b3c <printf>
    exit(1);
     988:	4505                	li	a0,1
     98a:	00005097          	auipc	ra,0x5
     98e:	e3a080e7          	jalr	-454(ra) # 57c4 <exit>
    printf("%s: read failed\n", s);
     992:	85da                	mv	a1,s6
     994:	00006517          	auipc	a0,0x6
     998:	a7c50513          	addi	a0,a0,-1412 # 6410 <malloc+0x816>
     99c:	00005097          	auipc	ra,0x5
     9a0:	1a0080e7          	jalr	416(ra) # 5b3c <printf>
    exit(1);
     9a4:	4505                	li	a0,1
     9a6:	00005097          	auipc	ra,0x5
     9aa:	e1e080e7          	jalr	-482(ra) # 57c4 <exit>
    printf("%s: unlink small failed\n", s);
     9ae:	85da                	mv	a1,s6
     9b0:	00006517          	auipc	a0,0x6
     9b4:	a7850513          	addi	a0,a0,-1416 # 6428 <malloc+0x82e>
     9b8:	00005097          	auipc	ra,0x5
     9bc:	184080e7          	jalr	388(ra) # 5b3c <printf>
    exit(1);
     9c0:	4505                	li	a0,1
     9c2:	00005097          	auipc	ra,0x5
     9c6:	e02080e7          	jalr	-510(ra) # 57c4 <exit>

00000000000009ca <writebig>:
{
     9ca:	7139                	addi	sp,sp,-64
     9cc:	fc06                	sd	ra,56(sp)
     9ce:	f822                	sd	s0,48(sp)
     9d0:	f426                	sd	s1,40(sp)
     9d2:	f04a                	sd	s2,32(sp)
     9d4:	ec4e                	sd	s3,24(sp)
     9d6:	e852                	sd	s4,16(sp)
     9d8:	e456                	sd	s5,8(sp)
     9da:	0080                	addi	s0,sp,64
     9dc:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9de:	20200593          	li	a1,514
     9e2:	00006517          	auipc	a0,0x6
     9e6:	a6650513          	addi	a0,a0,-1434 # 6448 <malloc+0x84e>
     9ea:	00005097          	auipc	ra,0x5
     9ee:	e1a080e7          	jalr	-486(ra) # 5804 <open>
     9f2:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9f4:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9f6:	0000b917          	auipc	s2,0xb
     9fa:	2fa90913          	addi	s2,s2,762 # bcf0 <buf>
  for(i = 0; i < MAXFILE; i++){
     9fe:	10c00a13          	li	s4,268
  if(fd < 0){
     a02:	06054c63          	bltz	a0,a7a <writebig+0xb0>
    ((int*)buf)[0] = i;
     a06:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     a0a:	40000613          	li	a2,1024
     a0e:	85ca                	mv	a1,s2
     a10:	854e                	mv	a0,s3
     a12:	00005097          	auipc	ra,0x5
     a16:	dd2080e7          	jalr	-558(ra) # 57e4 <write>
     a1a:	40000793          	li	a5,1024
     a1e:	06f51c63          	bne	a0,a5,a96 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     a22:	2485                	addiw	s1,s1,1
     a24:	ff4491e3          	bne	s1,s4,a06 <writebig+0x3c>
  close(fd);
     a28:	854e                	mv	a0,s3
     a2a:	00005097          	auipc	ra,0x5
     a2e:	dc2080e7          	jalr	-574(ra) # 57ec <close>
  fd = open("big", O_RDONLY);
     a32:	4581                	li	a1,0
     a34:	00006517          	auipc	a0,0x6
     a38:	a1450513          	addi	a0,a0,-1516 # 6448 <malloc+0x84e>
     a3c:	00005097          	auipc	ra,0x5
     a40:	dc8080e7          	jalr	-568(ra) # 5804 <open>
     a44:	89aa                	mv	s3,a0
  n = 0;
     a46:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a48:	0000b917          	auipc	s2,0xb
     a4c:	2a890913          	addi	s2,s2,680 # bcf0 <buf>
  if(fd < 0){
     a50:	06054263          	bltz	a0,ab4 <writebig+0xea>
    i = read(fd, buf, BSIZE);
     a54:	40000613          	li	a2,1024
     a58:	85ca                	mv	a1,s2
     a5a:	854e                	mv	a0,s3
     a5c:	00005097          	auipc	ra,0x5
     a60:	d80080e7          	jalr	-640(ra) # 57dc <read>
    if(i == 0){
     a64:	c535                	beqz	a0,ad0 <writebig+0x106>
    } else if(i != BSIZE){
     a66:	40000793          	li	a5,1024
     a6a:	0af51f63          	bne	a0,a5,b28 <writebig+0x15e>
    if(((int*)buf)[0] != n){
     a6e:	00092683          	lw	a3,0(s2)
     a72:	0c969a63          	bne	a3,s1,b46 <writebig+0x17c>
    n++;
     a76:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a78:	bff1                	j	a54 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     a7a:	85d6                	mv	a1,s5
     a7c:	00006517          	auipc	a0,0x6
     a80:	9d450513          	addi	a0,a0,-1580 # 6450 <malloc+0x856>
     a84:	00005097          	auipc	ra,0x5
     a88:	0b8080e7          	jalr	184(ra) # 5b3c <printf>
    exit(1);
     a8c:	4505                	li	a0,1
     a8e:	00005097          	auipc	ra,0x5
     a92:	d36080e7          	jalr	-714(ra) # 57c4 <exit>
      printf("%s: error: write big file failed\n", s, i);
     a96:	8626                	mv	a2,s1
     a98:	85d6                	mv	a1,s5
     a9a:	00006517          	auipc	a0,0x6
     a9e:	9d650513          	addi	a0,a0,-1578 # 6470 <malloc+0x876>
     aa2:	00005097          	auipc	ra,0x5
     aa6:	09a080e7          	jalr	154(ra) # 5b3c <printf>
      exit(1);
     aaa:	4505                	li	a0,1
     aac:	00005097          	auipc	ra,0x5
     ab0:	d18080e7          	jalr	-744(ra) # 57c4 <exit>
    printf("%s: error: open big failed!\n", s);
     ab4:	85d6                	mv	a1,s5
     ab6:	00006517          	auipc	a0,0x6
     aba:	9e250513          	addi	a0,a0,-1566 # 6498 <malloc+0x89e>
     abe:	00005097          	auipc	ra,0x5
     ac2:	07e080e7          	jalr	126(ra) # 5b3c <printf>
    exit(1);
     ac6:	4505                	li	a0,1
     ac8:	00005097          	auipc	ra,0x5
     acc:	cfc080e7          	jalr	-772(ra) # 57c4 <exit>
      if(n == MAXFILE - 1){
     ad0:	10b00793          	li	a5,267
     ad4:	02f48a63          	beq	s1,a5,b08 <writebig+0x13e>
  close(fd);
     ad8:	854e                	mv	a0,s3
     ada:	00005097          	auipc	ra,0x5
     ade:	d12080e7          	jalr	-750(ra) # 57ec <close>
  if(unlink("big") < 0){
     ae2:	00006517          	auipc	a0,0x6
     ae6:	96650513          	addi	a0,a0,-1690 # 6448 <malloc+0x84e>
     aea:	00005097          	auipc	ra,0x5
     aee:	d2a080e7          	jalr	-726(ra) # 5814 <unlink>
     af2:	06054963          	bltz	a0,b64 <writebig+0x19a>
}
     af6:	70e2                	ld	ra,56(sp)
     af8:	7442                	ld	s0,48(sp)
     afa:	74a2                	ld	s1,40(sp)
     afc:	7902                	ld	s2,32(sp)
     afe:	69e2                	ld	s3,24(sp)
     b00:	6a42                	ld	s4,16(sp)
     b02:	6aa2                	ld	s5,8(sp)
     b04:	6121                	addi	sp,sp,64
     b06:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     b08:	10b00613          	li	a2,267
     b0c:	85d6                	mv	a1,s5
     b0e:	00006517          	auipc	a0,0x6
     b12:	9aa50513          	addi	a0,a0,-1622 # 64b8 <malloc+0x8be>
     b16:	00005097          	auipc	ra,0x5
     b1a:	026080e7          	jalr	38(ra) # 5b3c <printf>
        exit(1);
     b1e:	4505                	li	a0,1
     b20:	00005097          	auipc	ra,0x5
     b24:	ca4080e7          	jalr	-860(ra) # 57c4 <exit>
      printf("%s: read failed %d\n", s, i);
     b28:	862a                	mv	a2,a0
     b2a:	85d6                	mv	a1,s5
     b2c:	00006517          	auipc	a0,0x6
     b30:	9b450513          	addi	a0,a0,-1612 # 64e0 <malloc+0x8e6>
     b34:	00005097          	auipc	ra,0x5
     b38:	008080e7          	jalr	8(ra) # 5b3c <printf>
      exit(1);
     b3c:	4505                	li	a0,1
     b3e:	00005097          	auipc	ra,0x5
     b42:	c86080e7          	jalr	-890(ra) # 57c4 <exit>
      printf("%s: read content of block %d is %d\n", s,
     b46:	8626                	mv	a2,s1
     b48:	85d6                	mv	a1,s5
     b4a:	00006517          	auipc	a0,0x6
     b4e:	9ae50513          	addi	a0,a0,-1618 # 64f8 <malloc+0x8fe>
     b52:	00005097          	auipc	ra,0x5
     b56:	fea080e7          	jalr	-22(ra) # 5b3c <printf>
      exit(1);
     b5a:	4505                	li	a0,1
     b5c:	00005097          	auipc	ra,0x5
     b60:	c68080e7          	jalr	-920(ra) # 57c4 <exit>
    printf("%s: unlink big failed\n", s);
     b64:	85d6                	mv	a1,s5
     b66:	00006517          	auipc	a0,0x6
     b6a:	9ba50513          	addi	a0,a0,-1606 # 6520 <malloc+0x926>
     b6e:	00005097          	auipc	ra,0x5
     b72:	fce080e7          	jalr	-50(ra) # 5b3c <printf>
    exit(1);
     b76:	4505                	li	a0,1
     b78:	00005097          	auipc	ra,0x5
     b7c:	c4c080e7          	jalr	-948(ra) # 57c4 <exit>

0000000000000b80 <unlinkread>:
{
     b80:	7179                	addi	sp,sp,-48
     b82:	f406                	sd	ra,40(sp)
     b84:	f022                	sd	s0,32(sp)
     b86:	ec26                	sd	s1,24(sp)
     b88:	e84a                	sd	s2,16(sp)
     b8a:	e44e                	sd	s3,8(sp)
     b8c:	1800                	addi	s0,sp,48
     b8e:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b90:	20200593          	li	a1,514
     b94:	00005517          	auipc	a0,0x5
     b98:	2bc50513          	addi	a0,a0,700 # 5e50 <malloc+0x256>
     b9c:	00005097          	auipc	ra,0x5
     ba0:	c68080e7          	jalr	-920(ra) # 5804 <open>
  if(fd < 0){
     ba4:	0e054563          	bltz	a0,c8e <unlinkread+0x10e>
     ba8:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     baa:	4615                	li	a2,5
     bac:	00006597          	auipc	a1,0x6
     bb0:	9ac58593          	addi	a1,a1,-1620 # 6558 <malloc+0x95e>
     bb4:	00005097          	auipc	ra,0x5
     bb8:	c30080e7          	jalr	-976(ra) # 57e4 <write>
  close(fd);
     bbc:	8526                	mv	a0,s1
     bbe:	00005097          	auipc	ra,0x5
     bc2:	c2e080e7          	jalr	-978(ra) # 57ec <close>
  fd = open("unlinkread", O_RDWR);
     bc6:	4589                	li	a1,2
     bc8:	00005517          	auipc	a0,0x5
     bcc:	28850513          	addi	a0,a0,648 # 5e50 <malloc+0x256>
     bd0:	00005097          	auipc	ra,0x5
     bd4:	c34080e7          	jalr	-972(ra) # 5804 <open>
     bd8:	84aa                	mv	s1,a0
  if(fd < 0){
     bda:	0c054863          	bltz	a0,caa <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     bde:	00005517          	auipc	a0,0x5
     be2:	27250513          	addi	a0,a0,626 # 5e50 <malloc+0x256>
     be6:	00005097          	auipc	ra,0x5
     bea:	c2e080e7          	jalr	-978(ra) # 5814 <unlink>
     bee:	ed61                	bnez	a0,cc6 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bf0:	20200593          	li	a1,514
     bf4:	00005517          	auipc	a0,0x5
     bf8:	25c50513          	addi	a0,a0,604 # 5e50 <malloc+0x256>
     bfc:	00005097          	auipc	ra,0x5
     c00:	c08080e7          	jalr	-1016(ra) # 5804 <open>
     c04:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     c06:	460d                	li	a2,3
     c08:	00006597          	auipc	a1,0x6
     c0c:	99858593          	addi	a1,a1,-1640 # 65a0 <malloc+0x9a6>
     c10:	00005097          	auipc	ra,0x5
     c14:	bd4080e7          	jalr	-1068(ra) # 57e4 <write>
  close(fd1);
     c18:	854a                	mv	a0,s2
     c1a:	00005097          	auipc	ra,0x5
     c1e:	bd2080e7          	jalr	-1070(ra) # 57ec <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c22:	660d                	lui	a2,0x3
     c24:	0000b597          	auipc	a1,0xb
     c28:	0cc58593          	addi	a1,a1,204 # bcf0 <buf>
     c2c:	8526                	mv	a0,s1
     c2e:	00005097          	auipc	ra,0x5
     c32:	bae080e7          	jalr	-1106(ra) # 57dc <read>
     c36:	4795                	li	a5,5
     c38:	0af51563          	bne	a0,a5,ce2 <unlinkread+0x162>
  if(buf[0] != 'h'){
     c3c:	0000b717          	auipc	a4,0xb
     c40:	0b474703          	lbu	a4,180(a4) # bcf0 <buf>
     c44:	06800793          	li	a5,104
     c48:	0af71b63          	bne	a4,a5,cfe <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     c4c:	4629                	li	a2,10
     c4e:	0000b597          	auipc	a1,0xb
     c52:	0a258593          	addi	a1,a1,162 # bcf0 <buf>
     c56:	8526                	mv	a0,s1
     c58:	00005097          	auipc	ra,0x5
     c5c:	b8c080e7          	jalr	-1140(ra) # 57e4 <write>
     c60:	47a9                	li	a5,10
     c62:	0af51c63          	bne	a0,a5,d1a <unlinkread+0x19a>
  close(fd);
     c66:	8526                	mv	a0,s1
     c68:	00005097          	auipc	ra,0x5
     c6c:	b84080e7          	jalr	-1148(ra) # 57ec <close>
  unlink("unlinkread");
     c70:	00005517          	auipc	a0,0x5
     c74:	1e050513          	addi	a0,a0,480 # 5e50 <malloc+0x256>
     c78:	00005097          	auipc	ra,0x5
     c7c:	b9c080e7          	jalr	-1124(ra) # 5814 <unlink>
}
     c80:	70a2                	ld	ra,40(sp)
     c82:	7402                	ld	s0,32(sp)
     c84:	64e2                	ld	s1,24(sp)
     c86:	6942                	ld	s2,16(sp)
     c88:	69a2                	ld	s3,8(sp)
     c8a:	6145                	addi	sp,sp,48
     c8c:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c8e:	85ce                	mv	a1,s3
     c90:	00006517          	auipc	a0,0x6
     c94:	8a850513          	addi	a0,a0,-1880 # 6538 <malloc+0x93e>
     c98:	00005097          	auipc	ra,0x5
     c9c:	ea4080e7          	jalr	-348(ra) # 5b3c <printf>
    exit(1);
     ca0:	4505                	li	a0,1
     ca2:	00005097          	auipc	ra,0x5
     ca6:	b22080e7          	jalr	-1246(ra) # 57c4 <exit>
    printf("%s: open unlinkread failed\n", s);
     caa:	85ce                	mv	a1,s3
     cac:	00006517          	auipc	a0,0x6
     cb0:	8b450513          	addi	a0,a0,-1868 # 6560 <malloc+0x966>
     cb4:	00005097          	auipc	ra,0x5
     cb8:	e88080e7          	jalr	-376(ra) # 5b3c <printf>
    exit(1);
     cbc:	4505                	li	a0,1
     cbe:	00005097          	auipc	ra,0x5
     cc2:	b06080e7          	jalr	-1274(ra) # 57c4 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     cc6:	85ce                	mv	a1,s3
     cc8:	00006517          	auipc	a0,0x6
     ccc:	8b850513          	addi	a0,a0,-1864 # 6580 <malloc+0x986>
     cd0:	00005097          	auipc	ra,0x5
     cd4:	e6c080e7          	jalr	-404(ra) # 5b3c <printf>
    exit(1);
     cd8:	4505                	li	a0,1
     cda:	00005097          	auipc	ra,0x5
     cde:	aea080e7          	jalr	-1302(ra) # 57c4 <exit>
    printf("%s: unlinkread read failed", s);
     ce2:	85ce                	mv	a1,s3
     ce4:	00006517          	auipc	a0,0x6
     ce8:	8c450513          	addi	a0,a0,-1852 # 65a8 <malloc+0x9ae>
     cec:	00005097          	auipc	ra,0x5
     cf0:	e50080e7          	jalr	-432(ra) # 5b3c <printf>
    exit(1);
     cf4:	4505                	li	a0,1
     cf6:	00005097          	auipc	ra,0x5
     cfa:	ace080e7          	jalr	-1330(ra) # 57c4 <exit>
    printf("%s: unlinkread wrong data\n", s);
     cfe:	85ce                	mv	a1,s3
     d00:	00006517          	auipc	a0,0x6
     d04:	8c850513          	addi	a0,a0,-1848 # 65c8 <malloc+0x9ce>
     d08:	00005097          	auipc	ra,0x5
     d0c:	e34080e7          	jalr	-460(ra) # 5b3c <printf>
    exit(1);
     d10:	4505                	li	a0,1
     d12:	00005097          	auipc	ra,0x5
     d16:	ab2080e7          	jalr	-1358(ra) # 57c4 <exit>
    printf("%s: unlinkread write failed\n", s);
     d1a:	85ce                	mv	a1,s3
     d1c:	00006517          	auipc	a0,0x6
     d20:	8cc50513          	addi	a0,a0,-1844 # 65e8 <malloc+0x9ee>
     d24:	00005097          	auipc	ra,0x5
     d28:	e18080e7          	jalr	-488(ra) # 5b3c <printf>
    exit(1);
     d2c:	4505                	li	a0,1
     d2e:	00005097          	auipc	ra,0x5
     d32:	a96080e7          	jalr	-1386(ra) # 57c4 <exit>

0000000000000d36 <linktest>:
{
     d36:	1101                	addi	sp,sp,-32
     d38:	ec06                	sd	ra,24(sp)
     d3a:	e822                	sd	s0,16(sp)
     d3c:	e426                	sd	s1,8(sp)
     d3e:	e04a                	sd	s2,0(sp)
     d40:	1000                	addi	s0,sp,32
     d42:	892a                	mv	s2,a0
  unlink("lf1");
     d44:	00006517          	auipc	a0,0x6
     d48:	8c450513          	addi	a0,a0,-1852 # 6608 <malloc+0xa0e>
     d4c:	00005097          	auipc	ra,0x5
     d50:	ac8080e7          	jalr	-1336(ra) # 5814 <unlink>
  unlink("lf2");
     d54:	00006517          	auipc	a0,0x6
     d58:	8bc50513          	addi	a0,a0,-1860 # 6610 <malloc+0xa16>
     d5c:	00005097          	auipc	ra,0x5
     d60:	ab8080e7          	jalr	-1352(ra) # 5814 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d64:	20200593          	li	a1,514
     d68:	00006517          	auipc	a0,0x6
     d6c:	8a050513          	addi	a0,a0,-1888 # 6608 <malloc+0xa0e>
     d70:	00005097          	auipc	ra,0x5
     d74:	a94080e7          	jalr	-1388(ra) # 5804 <open>
  if(fd < 0){
     d78:	10054763          	bltz	a0,e86 <linktest+0x150>
     d7c:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d7e:	4615                	li	a2,5
     d80:	00005597          	auipc	a1,0x5
     d84:	7d858593          	addi	a1,a1,2008 # 6558 <malloc+0x95e>
     d88:	00005097          	auipc	ra,0x5
     d8c:	a5c080e7          	jalr	-1444(ra) # 57e4 <write>
     d90:	4795                	li	a5,5
     d92:	10f51863          	bne	a0,a5,ea2 <linktest+0x16c>
  close(fd);
     d96:	8526                	mv	a0,s1
     d98:	00005097          	auipc	ra,0x5
     d9c:	a54080e7          	jalr	-1452(ra) # 57ec <close>
  if(link("lf1", "lf2") < 0){
     da0:	00006597          	auipc	a1,0x6
     da4:	87058593          	addi	a1,a1,-1936 # 6610 <malloc+0xa16>
     da8:	00006517          	auipc	a0,0x6
     dac:	86050513          	addi	a0,a0,-1952 # 6608 <malloc+0xa0e>
     db0:	00005097          	auipc	ra,0x5
     db4:	a74080e7          	jalr	-1420(ra) # 5824 <link>
     db8:	10054363          	bltz	a0,ebe <linktest+0x188>
  unlink("lf1");
     dbc:	00006517          	auipc	a0,0x6
     dc0:	84c50513          	addi	a0,a0,-1972 # 6608 <malloc+0xa0e>
     dc4:	00005097          	auipc	ra,0x5
     dc8:	a50080e7          	jalr	-1456(ra) # 5814 <unlink>
  if(open("lf1", 0) >= 0){
     dcc:	4581                	li	a1,0
     dce:	00006517          	auipc	a0,0x6
     dd2:	83a50513          	addi	a0,a0,-1990 # 6608 <malloc+0xa0e>
     dd6:	00005097          	auipc	ra,0x5
     dda:	a2e080e7          	jalr	-1490(ra) # 5804 <open>
     dde:	0e055e63          	bgez	a0,eda <linktest+0x1a4>
  fd = open("lf2", 0);
     de2:	4581                	li	a1,0
     de4:	00006517          	auipc	a0,0x6
     de8:	82c50513          	addi	a0,a0,-2004 # 6610 <malloc+0xa16>
     dec:	00005097          	auipc	ra,0x5
     df0:	a18080e7          	jalr	-1512(ra) # 5804 <open>
     df4:	84aa                	mv	s1,a0
  if(fd < 0){
     df6:	10054063          	bltz	a0,ef6 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     dfa:	660d                	lui	a2,0x3
     dfc:	0000b597          	auipc	a1,0xb
     e00:	ef458593          	addi	a1,a1,-268 # bcf0 <buf>
     e04:	00005097          	auipc	ra,0x5
     e08:	9d8080e7          	jalr	-1576(ra) # 57dc <read>
     e0c:	4795                	li	a5,5
     e0e:	10f51263          	bne	a0,a5,f12 <linktest+0x1dc>
  close(fd);
     e12:	8526                	mv	a0,s1
     e14:	00005097          	auipc	ra,0x5
     e18:	9d8080e7          	jalr	-1576(ra) # 57ec <close>
  if(link("lf2", "lf2") >= 0){
     e1c:	00005597          	auipc	a1,0x5
     e20:	7f458593          	addi	a1,a1,2036 # 6610 <malloc+0xa16>
     e24:	852e                	mv	a0,a1
     e26:	00005097          	auipc	ra,0x5
     e2a:	9fe080e7          	jalr	-1538(ra) # 5824 <link>
     e2e:	10055063          	bgez	a0,f2e <linktest+0x1f8>
  unlink("lf2");
     e32:	00005517          	auipc	a0,0x5
     e36:	7de50513          	addi	a0,a0,2014 # 6610 <malloc+0xa16>
     e3a:	00005097          	auipc	ra,0x5
     e3e:	9da080e7          	jalr	-1574(ra) # 5814 <unlink>
  if(link("lf2", "lf1") >= 0){
     e42:	00005597          	auipc	a1,0x5
     e46:	7c658593          	addi	a1,a1,1990 # 6608 <malloc+0xa0e>
     e4a:	00005517          	auipc	a0,0x5
     e4e:	7c650513          	addi	a0,a0,1990 # 6610 <malloc+0xa16>
     e52:	00005097          	auipc	ra,0x5
     e56:	9d2080e7          	jalr	-1582(ra) # 5824 <link>
     e5a:	0e055863          	bgez	a0,f4a <linktest+0x214>
  if(link(".", "lf1") >= 0){
     e5e:	00005597          	auipc	a1,0x5
     e62:	7aa58593          	addi	a1,a1,1962 # 6608 <malloc+0xa0e>
     e66:	00006517          	auipc	a0,0x6
     e6a:	8b250513          	addi	a0,a0,-1870 # 6718 <malloc+0xb1e>
     e6e:	00005097          	auipc	ra,0x5
     e72:	9b6080e7          	jalr	-1610(ra) # 5824 <link>
     e76:	0e055863          	bgez	a0,f66 <linktest+0x230>
}
     e7a:	60e2                	ld	ra,24(sp)
     e7c:	6442                	ld	s0,16(sp)
     e7e:	64a2                	ld	s1,8(sp)
     e80:	6902                	ld	s2,0(sp)
     e82:	6105                	addi	sp,sp,32
     e84:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     e86:	85ca                	mv	a1,s2
     e88:	00005517          	auipc	a0,0x5
     e8c:	79050513          	addi	a0,a0,1936 # 6618 <malloc+0xa1e>
     e90:	00005097          	auipc	ra,0x5
     e94:	cac080e7          	jalr	-852(ra) # 5b3c <printf>
    exit(1);
     e98:	4505                	li	a0,1
     e9a:	00005097          	auipc	ra,0x5
     e9e:	92a080e7          	jalr	-1750(ra) # 57c4 <exit>
    printf("%s: write lf1 failed\n", s);
     ea2:	85ca                	mv	a1,s2
     ea4:	00005517          	auipc	a0,0x5
     ea8:	78c50513          	addi	a0,a0,1932 # 6630 <malloc+0xa36>
     eac:	00005097          	auipc	ra,0x5
     eb0:	c90080e7          	jalr	-880(ra) # 5b3c <printf>
    exit(1);
     eb4:	4505                	li	a0,1
     eb6:	00005097          	auipc	ra,0x5
     eba:	90e080e7          	jalr	-1778(ra) # 57c4 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     ebe:	85ca                	mv	a1,s2
     ec0:	00005517          	auipc	a0,0x5
     ec4:	78850513          	addi	a0,a0,1928 # 6648 <malloc+0xa4e>
     ec8:	00005097          	auipc	ra,0x5
     ecc:	c74080e7          	jalr	-908(ra) # 5b3c <printf>
    exit(1);
     ed0:	4505                	li	a0,1
     ed2:	00005097          	auipc	ra,0x5
     ed6:	8f2080e7          	jalr	-1806(ra) # 57c4 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     eda:	85ca                	mv	a1,s2
     edc:	00005517          	auipc	a0,0x5
     ee0:	78c50513          	addi	a0,a0,1932 # 6668 <malloc+0xa6e>
     ee4:	00005097          	auipc	ra,0x5
     ee8:	c58080e7          	jalr	-936(ra) # 5b3c <printf>
    exit(1);
     eec:	4505                	li	a0,1
     eee:	00005097          	auipc	ra,0x5
     ef2:	8d6080e7          	jalr	-1834(ra) # 57c4 <exit>
    printf("%s: open lf2 failed\n", s);
     ef6:	85ca                	mv	a1,s2
     ef8:	00005517          	auipc	a0,0x5
     efc:	7a050513          	addi	a0,a0,1952 # 6698 <malloc+0xa9e>
     f00:	00005097          	auipc	ra,0x5
     f04:	c3c080e7          	jalr	-964(ra) # 5b3c <printf>
    exit(1);
     f08:	4505                	li	a0,1
     f0a:	00005097          	auipc	ra,0x5
     f0e:	8ba080e7          	jalr	-1862(ra) # 57c4 <exit>
    printf("%s: read lf2 failed\n", s);
     f12:	85ca                	mv	a1,s2
     f14:	00005517          	auipc	a0,0x5
     f18:	79c50513          	addi	a0,a0,1948 # 66b0 <malloc+0xab6>
     f1c:	00005097          	auipc	ra,0x5
     f20:	c20080e7          	jalr	-992(ra) # 5b3c <printf>
    exit(1);
     f24:	4505                	li	a0,1
     f26:	00005097          	auipc	ra,0x5
     f2a:	89e080e7          	jalr	-1890(ra) # 57c4 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f2e:	85ca                	mv	a1,s2
     f30:	00005517          	auipc	a0,0x5
     f34:	79850513          	addi	a0,a0,1944 # 66c8 <malloc+0xace>
     f38:	00005097          	auipc	ra,0x5
     f3c:	c04080e7          	jalr	-1020(ra) # 5b3c <printf>
    exit(1);
     f40:	4505                	li	a0,1
     f42:	00005097          	auipc	ra,0x5
     f46:	882080e7          	jalr	-1918(ra) # 57c4 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     f4a:	85ca                	mv	a1,s2
     f4c:	00005517          	auipc	a0,0x5
     f50:	7a450513          	addi	a0,a0,1956 # 66f0 <malloc+0xaf6>
     f54:	00005097          	auipc	ra,0x5
     f58:	be8080e7          	jalr	-1048(ra) # 5b3c <printf>
    exit(1);
     f5c:	4505                	li	a0,1
     f5e:	00005097          	auipc	ra,0x5
     f62:	866080e7          	jalr	-1946(ra) # 57c4 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f66:	85ca                	mv	a1,s2
     f68:	00005517          	auipc	a0,0x5
     f6c:	7b850513          	addi	a0,a0,1976 # 6720 <malloc+0xb26>
     f70:	00005097          	auipc	ra,0x5
     f74:	bcc080e7          	jalr	-1076(ra) # 5b3c <printf>
    exit(1);
     f78:	4505                	li	a0,1
     f7a:	00005097          	auipc	ra,0x5
     f7e:	84a080e7          	jalr	-1974(ra) # 57c4 <exit>

0000000000000f82 <bigdir>:
{
     f82:	715d                	addi	sp,sp,-80
     f84:	e486                	sd	ra,72(sp)
     f86:	e0a2                	sd	s0,64(sp)
     f88:	fc26                	sd	s1,56(sp)
     f8a:	f84a                	sd	s2,48(sp)
     f8c:	f44e                	sd	s3,40(sp)
     f8e:	f052                	sd	s4,32(sp)
     f90:	ec56                	sd	s5,24(sp)
     f92:	e85a                	sd	s6,16(sp)
     f94:	0880                	addi	s0,sp,80
     f96:	89aa                	mv	s3,a0
  unlink("bd");
     f98:	00005517          	auipc	a0,0x5
     f9c:	7a850513          	addi	a0,a0,1960 # 6740 <malloc+0xb46>
     fa0:	00005097          	auipc	ra,0x5
     fa4:	874080e7          	jalr	-1932(ra) # 5814 <unlink>
  fd = open("bd", O_CREATE);
     fa8:	20000593          	li	a1,512
     fac:	00005517          	auipc	a0,0x5
     fb0:	79450513          	addi	a0,a0,1940 # 6740 <malloc+0xb46>
     fb4:	00005097          	auipc	ra,0x5
     fb8:	850080e7          	jalr	-1968(ra) # 5804 <open>
  if(fd < 0){
     fbc:	0c054963          	bltz	a0,108e <bigdir+0x10c>
  close(fd);
     fc0:	00005097          	auipc	ra,0x5
     fc4:	82c080e7          	jalr	-2004(ra) # 57ec <close>
  for(i = 0; i < N; i++){
     fc8:	4901                	li	s2,0
    name[0] = 'x';
     fca:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     fce:	00005a17          	auipc	s4,0x5
     fd2:	772a0a13          	addi	s4,s4,1906 # 6740 <malloc+0xb46>
  for(i = 0; i < N; i++){
     fd6:	1f400b13          	li	s6,500
    name[0] = 'x';
     fda:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     fde:	41f9579b          	sraiw	a5,s2,0x1f
     fe2:	01a7d71b          	srliw	a4,a5,0x1a
     fe6:	012707bb          	addw	a5,a4,s2
     fea:	4067d69b          	sraiw	a3,a5,0x6
     fee:	0306869b          	addiw	a3,a3,48
     ff2:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     ff6:	03f7f793          	andi	a5,a5,63
     ffa:	9f99                	subw	a5,a5,a4
     ffc:	0307879b          	addiw	a5,a5,48
    1000:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1004:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    1008:	fb040593          	addi	a1,s0,-80
    100c:	8552                	mv	a0,s4
    100e:	00005097          	auipc	ra,0x5
    1012:	816080e7          	jalr	-2026(ra) # 5824 <link>
    1016:	84aa                	mv	s1,a0
    1018:	e949                	bnez	a0,10aa <bigdir+0x128>
  for(i = 0; i < N; i++){
    101a:	2905                	addiw	s2,s2,1
    101c:	fb691fe3          	bne	s2,s6,fda <bigdir+0x58>
  unlink("bd");
    1020:	00005517          	auipc	a0,0x5
    1024:	72050513          	addi	a0,a0,1824 # 6740 <malloc+0xb46>
    1028:	00004097          	auipc	ra,0x4
    102c:	7ec080e7          	jalr	2028(ra) # 5814 <unlink>
    name[0] = 'x';
    1030:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1034:	1f400a13          	li	s4,500
    name[0] = 'x';
    1038:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    103c:	41f4d79b          	sraiw	a5,s1,0x1f
    1040:	01a7d71b          	srliw	a4,a5,0x1a
    1044:	009707bb          	addw	a5,a4,s1
    1048:	4067d69b          	sraiw	a3,a5,0x6
    104c:	0306869b          	addiw	a3,a3,48
    1050:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1054:	03f7f793          	andi	a5,a5,63
    1058:	9f99                	subw	a5,a5,a4
    105a:	0307879b          	addiw	a5,a5,48
    105e:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1062:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1066:	fb040513          	addi	a0,s0,-80
    106a:	00004097          	auipc	ra,0x4
    106e:	7aa080e7          	jalr	1962(ra) # 5814 <unlink>
    1072:	ed21                	bnez	a0,10ca <bigdir+0x148>
  for(i = 0; i < N; i++){
    1074:	2485                	addiw	s1,s1,1
    1076:	fd4491e3          	bne	s1,s4,1038 <bigdir+0xb6>
}
    107a:	60a6                	ld	ra,72(sp)
    107c:	6406                	ld	s0,64(sp)
    107e:	74e2                	ld	s1,56(sp)
    1080:	7942                	ld	s2,48(sp)
    1082:	79a2                	ld	s3,40(sp)
    1084:	7a02                	ld	s4,32(sp)
    1086:	6ae2                	ld	s5,24(sp)
    1088:	6b42                	ld	s6,16(sp)
    108a:	6161                	addi	sp,sp,80
    108c:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    108e:	85ce                	mv	a1,s3
    1090:	00005517          	auipc	a0,0x5
    1094:	6b850513          	addi	a0,a0,1720 # 6748 <malloc+0xb4e>
    1098:	00005097          	auipc	ra,0x5
    109c:	aa4080e7          	jalr	-1372(ra) # 5b3c <printf>
    exit(1);
    10a0:	4505                	li	a0,1
    10a2:	00004097          	auipc	ra,0x4
    10a6:	722080e7          	jalr	1826(ra) # 57c4 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    10aa:	fb040613          	addi	a2,s0,-80
    10ae:	85ce                	mv	a1,s3
    10b0:	00005517          	auipc	a0,0x5
    10b4:	6b850513          	addi	a0,a0,1720 # 6768 <malloc+0xb6e>
    10b8:	00005097          	auipc	ra,0x5
    10bc:	a84080e7          	jalr	-1404(ra) # 5b3c <printf>
      exit(1);
    10c0:	4505                	li	a0,1
    10c2:	00004097          	auipc	ra,0x4
    10c6:	702080e7          	jalr	1794(ra) # 57c4 <exit>
      printf("%s: bigdir unlink failed", s);
    10ca:	85ce                	mv	a1,s3
    10cc:	00005517          	auipc	a0,0x5
    10d0:	6bc50513          	addi	a0,a0,1724 # 6788 <malloc+0xb8e>
    10d4:	00005097          	auipc	ra,0x5
    10d8:	a68080e7          	jalr	-1432(ra) # 5b3c <printf>
      exit(1);
    10dc:	4505                	li	a0,1
    10de:	00004097          	auipc	ra,0x4
    10e2:	6e6080e7          	jalr	1766(ra) # 57c4 <exit>

00000000000010e6 <validatetest>:
{
    10e6:	7139                	addi	sp,sp,-64
    10e8:	fc06                	sd	ra,56(sp)
    10ea:	f822                	sd	s0,48(sp)
    10ec:	f426                	sd	s1,40(sp)
    10ee:	f04a                	sd	s2,32(sp)
    10f0:	ec4e                	sd	s3,24(sp)
    10f2:	e852                	sd	s4,16(sp)
    10f4:	e456                	sd	s5,8(sp)
    10f6:	e05a                	sd	s6,0(sp)
    10f8:	0080                	addi	s0,sp,64
    10fa:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10fc:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    10fe:	00005997          	auipc	s3,0x5
    1102:	6aa98993          	addi	s3,s3,1706 # 67a8 <malloc+0xbae>
    1106:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1108:	6a85                	lui	s5,0x1
    110a:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    110e:	85a6                	mv	a1,s1
    1110:	854e                	mv	a0,s3
    1112:	00004097          	auipc	ra,0x4
    1116:	712080e7          	jalr	1810(ra) # 5824 <link>
    111a:	01251f63          	bne	a0,s2,1138 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    111e:	94d6                	add	s1,s1,s5
    1120:	ff4497e3          	bne	s1,s4,110e <validatetest+0x28>
}
    1124:	70e2                	ld	ra,56(sp)
    1126:	7442                	ld	s0,48(sp)
    1128:	74a2                	ld	s1,40(sp)
    112a:	7902                	ld	s2,32(sp)
    112c:	69e2                	ld	s3,24(sp)
    112e:	6a42                	ld	s4,16(sp)
    1130:	6aa2                	ld	s5,8(sp)
    1132:	6b02                	ld	s6,0(sp)
    1134:	6121                	addi	sp,sp,64
    1136:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1138:	85da                	mv	a1,s6
    113a:	00005517          	auipc	a0,0x5
    113e:	67e50513          	addi	a0,a0,1662 # 67b8 <malloc+0xbbe>
    1142:	00005097          	auipc	ra,0x5
    1146:	9fa080e7          	jalr	-1542(ra) # 5b3c <printf>
      exit(1);
    114a:	4505                	li	a0,1
    114c:	00004097          	auipc	ra,0x4
    1150:	678080e7          	jalr	1656(ra) # 57c4 <exit>

0000000000001154 <pgbug>:
// regression test. copyin(), copyout(), and copyinstr() used to cast
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void
pgbug(char *s)
{
    1154:	7179                	addi	sp,sp,-48
    1156:	f406                	sd	ra,40(sp)
    1158:	f022                	sd	s0,32(sp)
    115a:	ec26                	sd	s1,24(sp)
    115c:	1800                	addi	s0,sp,48
  char *argv[1];
  argv[0] = 0;
    115e:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    1162:	00007497          	auipc	s1,0x7
    1166:	3664b483          	ld	s1,870(s1) # 84c8 <__SDATA_BEGIN__>
    116a:	fd840593          	addi	a1,s0,-40
    116e:	8526                	mv	a0,s1
    1170:	00004097          	auipc	ra,0x4
    1174:	68c080e7          	jalr	1676(ra) # 57fc <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
    1178:	8526                	mv	a0,s1
    117a:	00004097          	auipc	ra,0x4
    117e:	65a080e7          	jalr	1626(ra) # 57d4 <pipe>

  exit(0);
    1182:	4501                	li	a0,0
    1184:	00004097          	auipc	ra,0x4
    1188:	640080e7          	jalr	1600(ra) # 57c4 <exit>

000000000000118c <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    118c:	7139                	addi	sp,sp,-64
    118e:	fc06                	sd	ra,56(sp)
    1190:	f822                	sd	s0,48(sp)
    1192:	f426                	sd	s1,40(sp)
    1194:	f04a                	sd	s2,32(sp)
    1196:	ec4e                	sd	s3,24(sp)
    1198:	0080                	addi	s0,sp,64
    119a:	64b1                	lui	s1,0xc
    119c:	35048493          	addi	s1,s1,848 # c350 <buf+0x660>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    11a0:	597d                	li	s2,-1
    11a2:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    11a6:	00005997          	auipc	s3,0x5
    11aa:	eda98993          	addi	s3,s3,-294 # 6080 <malloc+0x486>
    argv[0] = (char*)0xffffffff;
    11ae:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    11b2:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    11b6:	fc040593          	addi	a1,s0,-64
    11ba:	854e                	mv	a0,s3
    11bc:	00004097          	auipc	ra,0x4
    11c0:	640080e7          	jalr	1600(ra) # 57fc <exec>
  for(int i = 0; i < 50000; i++){
    11c4:	34fd                	addiw	s1,s1,-1
    11c6:	f4e5                	bnez	s1,11ae <badarg+0x22>
  }
  
  exit(0);
    11c8:	4501                	li	a0,0
    11ca:	00004097          	auipc	ra,0x4
    11ce:	5fa080e7          	jalr	1530(ra) # 57c4 <exit>

00000000000011d2 <copyinstr2>:
{
    11d2:	7155                	addi	sp,sp,-208
    11d4:	e586                	sd	ra,200(sp)
    11d6:	e1a2                	sd	s0,192(sp)
    11d8:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    11da:	f6840793          	addi	a5,s0,-152
    11de:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    11e2:	07800713          	li	a4,120
    11e6:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    11ea:	0785                	addi	a5,a5,1
    11ec:	fed79de3          	bne	a5,a3,11e6 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    11f0:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    11f4:	f6840513          	addi	a0,s0,-152
    11f8:	00004097          	auipc	ra,0x4
    11fc:	61c080e7          	jalr	1564(ra) # 5814 <unlink>
  if(ret != -1){
    1200:	57fd                	li	a5,-1
    1202:	0ef51063          	bne	a0,a5,12e2 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    1206:	20100593          	li	a1,513
    120a:	f6840513          	addi	a0,s0,-152
    120e:	00004097          	auipc	ra,0x4
    1212:	5f6080e7          	jalr	1526(ra) # 5804 <open>
  if(fd != -1){
    1216:	57fd                	li	a5,-1
    1218:	0ef51563          	bne	a0,a5,1302 <copyinstr2+0x130>
  ret = link(b, b);
    121c:	f6840593          	addi	a1,s0,-152
    1220:	852e                	mv	a0,a1
    1222:	00004097          	auipc	ra,0x4
    1226:	602080e7          	jalr	1538(ra) # 5824 <link>
  if(ret != -1){
    122a:	57fd                	li	a5,-1
    122c:	0ef51b63          	bne	a0,a5,1322 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    1230:	00006797          	auipc	a5,0x6
    1234:	75878793          	addi	a5,a5,1880 # 7988 <malloc+0x1d8e>
    1238:	f4f43c23          	sd	a5,-168(s0)
    123c:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1240:	f5840593          	addi	a1,s0,-168
    1244:	f6840513          	addi	a0,s0,-152
    1248:	00004097          	auipc	ra,0x4
    124c:	5b4080e7          	jalr	1460(ra) # 57fc <exec>
  if(ret != -1){
    1250:	57fd                	li	a5,-1
    1252:	0ef51963          	bne	a0,a5,1344 <copyinstr2+0x172>
  int pid = fork();
    1256:	00004097          	auipc	ra,0x4
    125a:	566080e7          	jalr	1382(ra) # 57bc <fork>
  if(pid < 0){
    125e:	10054363          	bltz	a0,1364 <copyinstr2+0x192>
  if(pid == 0){
    1262:	12051463          	bnez	a0,138a <copyinstr2+0x1b8>
    1266:	00007797          	auipc	a5,0x7
    126a:	37278793          	addi	a5,a5,882 # 85d8 <big.1270>
    126e:	00008697          	auipc	a3,0x8
    1272:	36a68693          	addi	a3,a3,874 # 95d8 <__global_pointer$+0x910>
      big[i] = 'x';
    1276:	07800713          	li	a4,120
    127a:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    127e:	0785                	addi	a5,a5,1
    1280:	fed79de3          	bne	a5,a3,127a <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1284:	00008797          	auipc	a5,0x8
    1288:	34078a23          	sb	zero,852(a5) # 95d8 <__global_pointer$+0x910>
    char *args2[] = { big, big, big, 0 };
    128c:	00007797          	auipc	a5,0x7
    1290:	e0c78793          	addi	a5,a5,-500 # 8098 <malloc+0x249e>
    1294:	6390                	ld	a2,0(a5)
    1296:	6794                	ld	a3,8(a5)
    1298:	6b98                	ld	a4,16(a5)
    129a:	6f9c                	ld	a5,24(a5)
    129c:	f2c43823          	sd	a2,-208(s0)
    12a0:	f2d43c23          	sd	a3,-200(s0)
    12a4:	f4e43023          	sd	a4,-192(s0)
    12a8:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    12ac:	f3040593          	addi	a1,s0,-208
    12b0:	00005517          	auipc	a0,0x5
    12b4:	dd050513          	addi	a0,a0,-560 # 6080 <malloc+0x486>
    12b8:	00004097          	auipc	ra,0x4
    12bc:	544080e7          	jalr	1348(ra) # 57fc <exec>
    if(ret != -1){
    12c0:	57fd                	li	a5,-1
    12c2:	0af50e63          	beq	a0,a5,137e <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    12c6:	55fd                	li	a1,-1
    12c8:	00005517          	auipc	a0,0x5
    12cc:	59850513          	addi	a0,a0,1432 # 6860 <malloc+0xc66>
    12d0:	00005097          	auipc	ra,0x5
    12d4:	86c080e7          	jalr	-1940(ra) # 5b3c <printf>
      exit(1);
    12d8:	4505                	li	a0,1
    12da:	00004097          	auipc	ra,0x4
    12de:	4ea080e7          	jalr	1258(ra) # 57c4 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    12e2:	862a                	mv	a2,a0
    12e4:	f6840593          	addi	a1,s0,-152
    12e8:	00005517          	auipc	a0,0x5
    12ec:	4f050513          	addi	a0,a0,1264 # 67d8 <malloc+0xbde>
    12f0:	00005097          	auipc	ra,0x5
    12f4:	84c080e7          	jalr	-1972(ra) # 5b3c <printf>
    exit(1);
    12f8:	4505                	li	a0,1
    12fa:	00004097          	auipc	ra,0x4
    12fe:	4ca080e7          	jalr	1226(ra) # 57c4 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1302:	862a                	mv	a2,a0
    1304:	f6840593          	addi	a1,s0,-152
    1308:	00005517          	auipc	a0,0x5
    130c:	4f050513          	addi	a0,a0,1264 # 67f8 <malloc+0xbfe>
    1310:	00005097          	auipc	ra,0x5
    1314:	82c080e7          	jalr	-2004(ra) # 5b3c <printf>
    exit(1);
    1318:	4505                	li	a0,1
    131a:	00004097          	auipc	ra,0x4
    131e:	4aa080e7          	jalr	1194(ra) # 57c4 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1322:	86aa                	mv	a3,a0
    1324:	f6840613          	addi	a2,s0,-152
    1328:	85b2                	mv	a1,a2
    132a:	00005517          	auipc	a0,0x5
    132e:	4ee50513          	addi	a0,a0,1262 # 6818 <malloc+0xc1e>
    1332:	00005097          	auipc	ra,0x5
    1336:	80a080e7          	jalr	-2038(ra) # 5b3c <printf>
    exit(1);
    133a:	4505                	li	a0,1
    133c:	00004097          	auipc	ra,0x4
    1340:	488080e7          	jalr	1160(ra) # 57c4 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1344:	567d                	li	a2,-1
    1346:	f6840593          	addi	a1,s0,-152
    134a:	00005517          	auipc	a0,0x5
    134e:	4f650513          	addi	a0,a0,1270 # 6840 <malloc+0xc46>
    1352:	00004097          	auipc	ra,0x4
    1356:	7ea080e7          	jalr	2026(ra) # 5b3c <printf>
    exit(1);
    135a:	4505                	li	a0,1
    135c:	00004097          	auipc	ra,0x4
    1360:	468080e7          	jalr	1128(ra) # 57c4 <exit>
    printf("fork failed\n");
    1364:	00006517          	auipc	a0,0x6
    1368:	95c50513          	addi	a0,a0,-1700 # 6cc0 <malloc+0x10c6>
    136c:	00004097          	auipc	ra,0x4
    1370:	7d0080e7          	jalr	2000(ra) # 5b3c <printf>
    exit(1);
    1374:	4505                	li	a0,1
    1376:	00004097          	auipc	ra,0x4
    137a:	44e080e7          	jalr	1102(ra) # 57c4 <exit>
    exit(747); // OK
    137e:	2eb00513          	li	a0,747
    1382:	00004097          	auipc	ra,0x4
    1386:	442080e7          	jalr	1090(ra) # 57c4 <exit>
  int st = 0;
    138a:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    138e:	f5440513          	addi	a0,s0,-172
    1392:	00004097          	auipc	ra,0x4
    1396:	43a080e7          	jalr	1082(ra) # 57cc <wait>
  if(st != 747){
    139a:	f5442703          	lw	a4,-172(s0)
    139e:	2eb00793          	li	a5,747
    13a2:	00f71663          	bne	a4,a5,13ae <copyinstr2+0x1dc>
}
    13a6:	60ae                	ld	ra,200(sp)
    13a8:	640e                	ld	s0,192(sp)
    13aa:	6169                	addi	sp,sp,208
    13ac:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    13ae:	00005517          	auipc	a0,0x5
    13b2:	4da50513          	addi	a0,a0,1242 # 6888 <malloc+0xc8e>
    13b6:	00004097          	auipc	ra,0x4
    13ba:	786080e7          	jalr	1926(ra) # 5b3c <printf>
    exit(1);
    13be:	4505                	li	a0,1
    13c0:	00004097          	auipc	ra,0x4
    13c4:	404080e7          	jalr	1028(ra) # 57c4 <exit>

00000000000013c8 <truncate3>:
{
    13c8:	7159                	addi	sp,sp,-112
    13ca:	f486                	sd	ra,104(sp)
    13cc:	f0a2                	sd	s0,96(sp)
    13ce:	eca6                	sd	s1,88(sp)
    13d0:	e8ca                	sd	s2,80(sp)
    13d2:	e4ce                	sd	s3,72(sp)
    13d4:	e0d2                	sd	s4,64(sp)
    13d6:	fc56                	sd	s5,56(sp)
    13d8:	1880                	addi	s0,sp,112
    13da:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    13dc:	60100593          	li	a1,1537
    13e0:	00005517          	auipc	a0,0x5
    13e4:	cf850513          	addi	a0,a0,-776 # 60d8 <malloc+0x4de>
    13e8:	00004097          	auipc	ra,0x4
    13ec:	41c080e7          	jalr	1052(ra) # 5804 <open>
    13f0:	00004097          	auipc	ra,0x4
    13f4:	3fc080e7          	jalr	1020(ra) # 57ec <close>
  pid = fork();
    13f8:	00004097          	auipc	ra,0x4
    13fc:	3c4080e7          	jalr	964(ra) # 57bc <fork>
  if(pid < 0){
    1400:	08054063          	bltz	a0,1480 <truncate3+0xb8>
  if(pid == 0){
    1404:	e969                	bnez	a0,14d6 <truncate3+0x10e>
    1406:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    140a:	00005a17          	auipc	s4,0x5
    140e:	ccea0a13          	addi	s4,s4,-818 # 60d8 <malloc+0x4de>
      int n = write(fd, "1234567890", 10);
    1412:	00005a97          	auipc	s5,0x5
    1416:	4d6a8a93          	addi	s5,s5,1238 # 68e8 <malloc+0xcee>
      int fd = open("truncfile", O_WRONLY);
    141a:	4585                	li	a1,1
    141c:	8552                	mv	a0,s4
    141e:	00004097          	auipc	ra,0x4
    1422:	3e6080e7          	jalr	998(ra) # 5804 <open>
    1426:	84aa                	mv	s1,a0
      if(fd < 0){
    1428:	06054a63          	bltz	a0,149c <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    142c:	4629                	li	a2,10
    142e:	85d6                	mv	a1,s5
    1430:	00004097          	auipc	ra,0x4
    1434:	3b4080e7          	jalr	948(ra) # 57e4 <write>
      if(n != 10){
    1438:	47a9                	li	a5,10
    143a:	06f51f63          	bne	a0,a5,14b8 <truncate3+0xf0>
      close(fd);
    143e:	8526                	mv	a0,s1
    1440:	00004097          	auipc	ra,0x4
    1444:	3ac080e7          	jalr	940(ra) # 57ec <close>
      fd = open("truncfile", O_RDONLY);
    1448:	4581                	li	a1,0
    144a:	8552                	mv	a0,s4
    144c:	00004097          	auipc	ra,0x4
    1450:	3b8080e7          	jalr	952(ra) # 5804 <open>
    1454:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1456:	02000613          	li	a2,32
    145a:	f9840593          	addi	a1,s0,-104
    145e:	00004097          	auipc	ra,0x4
    1462:	37e080e7          	jalr	894(ra) # 57dc <read>
      close(fd);
    1466:	8526                	mv	a0,s1
    1468:	00004097          	auipc	ra,0x4
    146c:	384080e7          	jalr	900(ra) # 57ec <close>
    for(int i = 0; i < 100; i++){
    1470:	39fd                	addiw	s3,s3,-1
    1472:	fa0994e3          	bnez	s3,141a <truncate3+0x52>
    exit(0);
    1476:	4501                	li	a0,0
    1478:	00004097          	auipc	ra,0x4
    147c:	34c080e7          	jalr	844(ra) # 57c4 <exit>
    printf("%s: fork failed\n", s);
    1480:	85ca                	mv	a1,s2
    1482:	00005517          	auipc	a0,0x5
    1486:	43650513          	addi	a0,a0,1078 # 68b8 <malloc+0xcbe>
    148a:	00004097          	auipc	ra,0x4
    148e:	6b2080e7          	jalr	1714(ra) # 5b3c <printf>
    exit(1);
    1492:	4505                	li	a0,1
    1494:	00004097          	auipc	ra,0x4
    1498:	330080e7          	jalr	816(ra) # 57c4 <exit>
        printf("%s: open failed\n", s);
    149c:	85ca                	mv	a1,s2
    149e:	00005517          	auipc	a0,0x5
    14a2:	43250513          	addi	a0,a0,1074 # 68d0 <malloc+0xcd6>
    14a6:	00004097          	auipc	ra,0x4
    14aa:	696080e7          	jalr	1686(ra) # 5b3c <printf>
        exit(1);
    14ae:	4505                	li	a0,1
    14b0:	00004097          	auipc	ra,0x4
    14b4:	314080e7          	jalr	788(ra) # 57c4 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    14b8:	862a                	mv	a2,a0
    14ba:	85ca                	mv	a1,s2
    14bc:	00005517          	auipc	a0,0x5
    14c0:	43c50513          	addi	a0,a0,1084 # 68f8 <malloc+0xcfe>
    14c4:	00004097          	auipc	ra,0x4
    14c8:	678080e7          	jalr	1656(ra) # 5b3c <printf>
        exit(1);
    14cc:	4505                	li	a0,1
    14ce:	00004097          	auipc	ra,0x4
    14d2:	2f6080e7          	jalr	758(ra) # 57c4 <exit>
    14d6:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14da:	00005a17          	auipc	s4,0x5
    14de:	bfea0a13          	addi	s4,s4,-1026 # 60d8 <malloc+0x4de>
    int n = write(fd, "xxx", 3);
    14e2:	00005a97          	auipc	s5,0x5
    14e6:	436a8a93          	addi	s5,s5,1078 # 6918 <malloc+0xd1e>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14ea:	60100593          	li	a1,1537
    14ee:	8552                	mv	a0,s4
    14f0:	00004097          	auipc	ra,0x4
    14f4:	314080e7          	jalr	788(ra) # 5804 <open>
    14f8:	84aa                	mv	s1,a0
    if(fd < 0){
    14fa:	04054763          	bltz	a0,1548 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    14fe:	460d                	li	a2,3
    1500:	85d6                	mv	a1,s5
    1502:	00004097          	auipc	ra,0x4
    1506:	2e2080e7          	jalr	738(ra) # 57e4 <write>
    if(n != 3){
    150a:	478d                	li	a5,3
    150c:	04f51c63          	bne	a0,a5,1564 <truncate3+0x19c>
    close(fd);
    1510:	8526                	mv	a0,s1
    1512:	00004097          	auipc	ra,0x4
    1516:	2da080e7          	jalr	730(ra) # 57ec <close>
  for(int i = 0; i < 150; i++){
    151a:	39fd                	addiw	s3,s3,-1
    151c:	fc0997e3          	bnez	s3,14ea <truncate3+0x122>
  wait(&xstatus);
    1520:	fbc40513          	addi	a0,s0,-68
    1524:	00004097          	auipc	ra,0x4
    1528:	2a8080e7          	jalr	680(ra) # 57cc <wait>
  unlink("truncfile");
    152c:	00005517          	auipc	a0,0x5
    1530:	bac50513          	addi	a0,a0,-1108 # 60d8 <malloc+0x4de>
    1534:	00004097          	auipc	ra,0x4
    1538:	2e0080e7          	jalr	736(ra) # 5814 <unlink>
  exit(xstatus);
    153c:	fbc42503          	lw	a0,-68(s0)
    1540:	00004097          	auipc	ra,0x4
    1544:	284080e7          	jalr	644(ra) # 57c4 <exit>
      printf("%s: open failed\n", s);
    1548:	85ca                	mv	a1,s2
    154a:	00005517          	auipc	a0,0x5
    154e:	38650513          	addi	a0,a0,902 # 68d0 <malloc+0xcd6>
    1552:	00004097          	auipc	ra,0x4
    1556:	5ea080e7          	jalr	1514(ra) # 5b3c <printf>
      exit(1);
    155a:	4505                	li	a0,1
    155c:	00004097          	auipc	ra,0x4
    1560:	268080e7          	jalr	616(ra) # 57c4 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1564:	862a                	mv	a2,a0
    1566:	85ca                	mv	a1,s2
    1568:	00005517          	auipc	a0,0x5
    156c:	3b850513          	addi	a0,a0,952 # 6920 <malloc+0xd26>
    1570:	00004097          	auipc	ra,0x4
    1574:	5cc080e7          	jalr	1484(ra) # 5b3c <printf>
      exit(1);
    1578:	4505                	li	a0,1
    157a:	00004097          	auipc	ra,0x4
    157e:	24a080e7          	jalr	586(ra) # 57c4 <exit>

0000000000001582 <exectest>:
{
    1582:	715d                	addi	sp,sp,-80
    1584:	e486                	sd	ra,72(sp)
    1586:	e0a2                	sd	s0,64(sp)
    1588:	fc26                	sd	s1,56(sp)
    158a:	f84a                	sd	s2,48(sp)
    158c:	0880                	addi	s0,sp,80
    158e:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1590:	00005797          	auipc	a5,0x5
    1594:	af078793          	addi	a5,a5,-1296 # 6080 <malloc+0x486>
    1598:	fcf43023          	sd	a5,-64(s0)
    159c:	00005797          	auipc	a5,0x5
    15a0:	3a478793          	addi	a5,a5,932 # 6940 <malloc+0xd46>
    15a4:	fcf43423          	sd	a5,-56(s0)
    15a8:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    15ac:	00005517          	auipc	a0,0x5
    15b0:	39c50513          	addi	a0,a0,924 # 6948 <malloc+0xd4e>
    15b4:	00004097          	auipc	ra,0x4
    15b8:	260080e7          	jalr	608(ra) # 5814 <unlink>
  pid = fork();
    15bc:	00004097          	auipc	ra,0x4
    15c0:	200080e7          	jalr	512(ra) # 57bc <fork>
  if(pid < 0) {
    15c4:	04054663          	bltz	a0,1610 <exectest+0x8e>
    15c8:	84aa                	mv	s1,a0
  if(pid == 0) {
    15ca:	e959                	bnez	a0,1660 <exectest+0xde>
    close(1);
    15cc:	4505                	li	a0,1
    15ce:	00004097          	auipc	ra,0x4
    15d2:	21e080e7          	jalr	542(ra) # 57ec <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    15d6:	20100593          	li	a1,513
    15da:	00005517          	auipc	a0,0x5
    15de:	36e50513          	addi	a0,a0,878 # 6948 <malloc+0xd4e>
    15e2:	00004097          	auipc	ra,0x4
    15e6:	222080e7          	jalr	546(ra) # 5804 <open>
    if(fd < 0) {
    15ea:	04054163          	bltz	a0,162c <exectest+0xaa>
    if(fd != 1) {
    15ee:	4785                	li	a5,1
    15f0:	04f50c63          	beq	a0,a5,1648 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    15f4:	85ca                	mv	a1,s2
    15f6:	00005517          	auipc	a0,0x5
    15fa:	37250513          	addi	a0,a0,882 # 6968 <malloc+0xd6e>
    15fe:	00004097          	auipc	ra,0x4
    1602:	53e080e7          	jalr	1342(ra) # 5b3c <printf>
      exit(1);
    1606:	4505                	li	a0,1
    1608:	00004097          	auipc	ra,0x4
    160c:	1bc080e7          	jalr	444(ra) # 57c4 <exit>
     printf("%s: fork failed\n", s);
    1610:	85ca                	mv	a1,s2
    1612:	00005517          	auipc	a0,0x5
    1616:	2a650513          	addi	a0,a0,678 # 68b8 <malloc+0xcbe>
    161a:	00004097          	auipc	ra,0x4
    161e:	522080e7          	jalr	1314(ra) # 5b3c <printf>
     exit(1);
    1622:	4505                	li	a0,1
    1624:	00004097          	auipc	ra,0x4
    1628:	1a0080e7          	jalr	416(ra) # 57c4 <exit>
      printf("%s: create failed\n", s);
    162c:	85ca                	mv	a1,s2
    162e:	00005517          	auipc	a0,0x5
    1632:	32250513          	addi	a0,a0,802 # 6950 <malloc+0xd56>
    1636:	00004097          	auipc	ra,0x4
    163a:	506080e7          	jalr	1286(ra) # 5b3c <printf>
      exit(1);
    163e:	4505                	li	a0,1
    1640:	00004097          	auipc	ra,0x4
    1644:	184080e7          	jalr	388(ra) # 57c4 <exit>
    if(exec("echo", echoargv) < 0){
    1648:	fc040593          	addi	a1,s0,-64
    164c:	00005517          	auipc	a0,0x5
    1650:	a3450513          	addi	a0,a0,-1484 # 6080 <malloc+0x486>
    1654:	00004097          	auipc	ra,0x4
    1658:	1a8080e7          	jalr	424(ra) # 57fc <exec>
    165c:	02054163          	bltz	a0,167e <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1660:	fdc40513          	addi	a0,s0,-36
    1664:	00004097          	auipc	ra,0x4
    1668:	168080e7          	jalr	360(ra) # 57cc <wait>
    166c:	02951763          	bne	a0,s1,169a <exectest+0x118>
  if(xstatus != 0)
    1670:	fdc42503          	lw	a0,-36(s0)
    1674:	cd0d                	beqz	a0,16ae <exectest+0x12c>
    exit(xstatus);
    1676:	00004097          	auipc	ra,0x4
    167a:	14e080e7          	jalr	334(ra) # 57c4 <exit>
      printf("%s: exec echo failed\n", s);
    167e:	85ca                	mv	a1,s2
    1680:	00005517          	auipc	a0,0x5
    1684:	2f850513          	addi	a0,a0,760 # 6978 <malloc+0xd7e>
    1688:	00004097          	auipc	ra,0x4
    168c:	4b4080e7          	jalr	1204(ra) # 5b3c <printf>
      exit(1);
    1690:	4505                	li	a0,1
    1692:	00004097          	auipc	ra,0x4
    1696:	132080e7          	jalr	306(ra) # 57c4 <exit>
    printf("%s: wait failed!\n", s);
    169a:	85ca                	mv	a1,s2
    169c:	00005517          	auipc	a0,0x5
    16a0:	2f450513          	addi	a0,a0,756 # 6990 <malloc+0xd96>
    16a4:	00004097          	auipc	ra,0x4
    16a8:	498080e7          	jalr	1176(ra) # 5b3c <printf>
    16ac:	b7d1                	j	1670 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    16ae:	4581                	li	a1,0
    16b0:	00005517          	auipc	a0,0x5
    16b4:	29850513          	addi	a0,a0,664 # 6948 <malloc+0xd4e>
    16b8:	00004097          	auipc	ra,0x4
    16bc:	14c080e7          	jalr	332(ra) # 5804 <open>
  if(fd < 0) {
    16c0:	02054a63          	bltz	a0,16f4 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    16c4:	4609                	li	a2,2
    16c6:	fb840593          	addi	a1,s0,-72
    16ca:	00004097          	auipc	ra,0x4
    16ce:	112080e7          	jalr	274(ra) # 57dc <read>
    16d2:	4789                	li	a5,2
    16d4:	02f50e63          	beq	a0,a5,1710 <exectest+0x18e>
    printf("%s: read failed\n", s);
    16d8:	85ca                	mv	a1,s2
    16da:	00005517          	auipc	a0,0x5
    16de:	d3650513          	addi	a0,a0,-714 # 6410 <malloc+0x816>
    16e2:	00004097          	auipc	ra,0x4
    16e6:	45a080e7          	jalr	1114(ra) # 5b3c <printf>
    exit(1);
    16ea:	4505                	li	a0,1
    16ec:	00004097          	auipc	ra,0x4
    16f0:	0d8080e7          	jalr	216(ra) # 57c4 <exit>
    printf("%s: open failed\n", s);
    16f4:	85ca                	mv	a1,s2
    16f6:	00005517          	auipc	a0,0x5
    16fa:	1da50513          	addi	a0,a0,474 # 68d0 <malloc+0xcd6>
    16fe:	00004097          	auipc	ra,0x4
    1702:	43e080e7          	jalr	1086(ra) # 5b3c <printf>
    exit(1);
    1706:	4505                	li	a0,1
    1708:	00004097          	auipc	ra,0x4
    170c:	0bc080e7          	jalr	188(ra) # 57c4 <exit>
  unlink("echo-ok");
    1710:	00005517          	auipc	a0,0x5
    1714:	23850513          	addi	a0,a0,568 # 6948 <malloc+0xd4e>
    1718:	00004097          	auipc	ra,0x4
    171c:	0fc080e7          	jalr	252(ra) # 5814 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1720:	fb844703          	lbu	a4,-72(s0)
    1724:	04f00793          	li	a5,79
    1728:	00f71863          	bne	a4,a5,1738 <exectest+0x1b6>
    172c:	fb944703          	lbu	a4,-71(s0)
    1730:	04b00793          	li	a5,75
    1734:	02f70063          	beq	a4,a5,1754 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    1738:	85ca                	mv	a1,s2
    173a:	00005517          	auipc	a0,0x5
    173e:	26e50513          	addi	a0,a0,622 # 69a8 <malloc+0xdae>
    1742:	00004097          	auipc	ra,0x4
    1746:	3fa080e7          	jalr	1018(ra) # 5b3c <printf>
    exit(1);
    174a:	4505                	li	a0,1
    174c:	00004097          	auipc	ra,0x4
    1750:	078080e7          	jalr	120(ra) # 57c4 <exit>
    exit(0);
    1754:	4501                	li	a0,0
    1756:	00004097          	auipc	ra,0x4
    175a:	06e080e7          	jalr	110(ra) # 57c4 <exit>

000000000000175e <pipe1>:
{
    175e:	711d                	addi	sp,sp,-96
    1760:	ec86                	sd	ra,88(sp)
    1762:	e8a2                	sd	s0,80(sp)
    1764:	e4a6                	sd	s1,72(sp)
    1766:	e0ca                	sd	s2,64(sp)
    1768:	fc4e                	sd	s3,56(sp)
    176a:	f852                	sd	s4,48(sp)
    176c:	f456                	sd	s5,40(sp)
    176e:	f05a                	sd	s6,32(sp)
    1770:	ec5e                	sd	s7,24(sp)
    1772:	1080                	addi	s0,sp,96
    1774:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1776:	fa840513          	addi	a0,s0,-88
    177a:	00004097          	auipc	ra,0x4
    177e:	05a080e7          	jalr	90(ra) # 57d4 <pipe>
    1782:	ed25                	bnez	a0,17fa <pipe1+0x9c>
    1784:	84aa                	mv	s1,a0
  pid = fork();
    1786:	00004097          	auipc	ra,0x4
    178a:	036080e7          	jalr	54(ra) # 57bc <fork>
    178e:	8a2a                	mv	s4,a0
  if(pid == 0){
    1790:	c159                	beqz	a0,1816 <pipe1+0xb8>
  } else if(pid > 0){
    1792:	16a05e63          	blez	a0,190e <pipe1+0x1b0>
    close(fds[1]);
    1796:	fac42503          	lw	a0,-84(s0)
    179a:	00004097          	auipc	ra,0x4
    179e:	052080e7          	jalr	82(ra) # 57ec <close>
    total = 0;
    17a2:	8a26                	mv	s4,s1
    cc = 1;
    17a4:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    17a6:	0000aa97          	auipc	s5,0xa
    17aa:	54aa8a93          	addi	s5,s5,1354 # bcf0 <buf>
      if(cc > sizeof(buf))
    17ae:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    17b0:	864e                	mv	a2,s3
    17b2:	85d6                	mv	a1,s5
    17b4:	fa842503          	lw	a0,-88(s0)
    17b8:	00004097          	auipc	ra,0x4
    17bc:	024080e7          	jalr	36(ra) # 57dc <read>
    17c0:	10a05263          	blez	a0,18c4 <pipe1+0x166>
      for(i = 0; i < n; i++){
    17c4:	0000a717          	auipc	a4,0xa
    17c8:	52c70713          	addi	a4,a4,1324 # bcf0 <buf>
    17cc:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17d0:	00074683          	lbu	a3,0(a4)
    17d4:	0ff4f793          	andi	a5,s1,255
    17d8:	2485                	addiw	s1,s1,1
    17da:	0cf69163          	bne	a3,a5,189c <pipe1+0x13e>
      for(i = 0; i < n; i++){
    17de:	0705                	addi	a4,a4,1
    17e0:	fec498e3          	bne	s1,a2,17d0 <pipe1+0x72>
      total += n;
    17e4:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    17e8:	0019979b          	slliw	a5,s3,0x1
    17ec:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    17f0:	013b7363          	bgeu	s6,s3,17f6 <pipe1+0x98>
        cc = sizeof(buf);
    17f4:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17f6:	84b2                	mv	s1,a2
    17f8:	bf65                	j	17b0 <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    17fa:	85ca                	mv	a1,s2
    17fc:	00005517          	auipc	a0,0x5
    1800:	1c450513          	addi	a0,a0,452 # 69c0 <malloc+0xdc6>
    1804:	00004097          	auipc	ra,0x4
    1808:	338080e7          	jalr	824(ra) # 5b3c <printf>
    exit(1);
    180c:	4505                	li	a0,1
    180e:	00004097          	auipc	ra,0x4
    1812:	fb6080e7          	jalr	-74(ra) # 57c4 <exit>
    close(fds[0]);
    1816:	fa842503          	lw	a0,-88(s0)
    181a:	00004097          	auipc	ra,0x4
    181e:	fd2080e7          	jalr	-46(ra) # 57ec <close>
    for(n = 0; n < N; n++){
    1822:	0000ab17          	auipc	s6,0xa
    1826:	4ceb0b13          	addi	s6,s6,1230 # bcf0 <buf>
    182a:	416004bb          	negw	s1,s6
    182e:	0ff4f493          	andi	s1,s1,255
    1832:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1836:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1838:	6a85                	lui	s5,0x1
    183a:	42da8a93          	addi	s5,s5,1069 # 142d <truncate3+0x65>
{
    183e:	87da                	mv	a5,s6
        buf[i] = seq++;
    1840:	0097873b          	addw	a4,a5,s1
    1844:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1848:	0785                	addi	a5,a5,1
    184a:	fef99be3          	bne	s3,a5,1840 <pipe1+0xe2>
    184e:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1852:	40900613          	li	a2,1033
    1856:	85de                	mv	a1,s7
    1858:	fac42503          	lw	a0,-84(s0)
    185c:	00004097          	auipc	ra,0x4
    1860:	f88080e7          	jalr	-120(ra) # 57e4 <write>
    1864:	40900793          	li	a5,1033
    1868:	00f51c63          	bne	a0,a5,1880 <pipe1+0x122>
    for(n = 0; n < N; n++){
    186c:	24a5                	addiw	s1,s1,9
    186e:	0ff4f493          	andi	s1,s1,255
    1872:	fd5a16e3          	bne	s4,s5,183e <pipe1+0xe0>
    exit(0);
    1876:	4501                	li	a0,0
    1878:	00004097          	auipc	ra,0x4
    187c:	f4c080e7          	jalr	-180(ra) # 57c4 <exit>
        printf("%s: pipe1 oops 1\n", s);
    1880:	85ca                	mv	a1,s2
    1882:	00005517          	auipc	a0,0x5
    1886:	15650513          	addi	a0,a0,342 # 69d8 <malloc+0xdde>
    188a:	00004097          	auipc	ra,0x4
    188e:	2b2080e7          	jalr	690(ra) # 5b3c <printf>
        exit(1);
    1892:	4505                	li	a0,1
    1894:	00004097          	auipc	ra,0x4
    1898:	f30080e7          	jalr	-208(ra) # 57c4 <exit>
          printf("%s: pipe1 oops 2\n", s);
    189c:	85ca                	mv	a1,s2
    189e:	00005517          	auipc	a0,0x5
    18a2:	15250513          	addi	a0,a0,338 # 69f0 <malloc+0xdf6>
    18a6:	00004097          	auipc	ra,0x4
    18aa:	296080e7          	jalr	662(ra) # 5b3c <printf>
}
    18ae:	60e6                	ld	ra,88(sp)
    18b0:	6446                	ld	s0,80(sp)
    18b2:	64a6                	ld	s1,72(sp)
    18b4:	6906                	ld	s2,64(sp)
    18b6:	79e2                	ld	s3,56(sp)
    18b8:	7a42                	ld	s4,48(sp)
    18ba:	7aa2                	ld	s5,40(sp)
    18bc:	7b02                	ld	s6,32(sp)
    18be:	6be2                	ld	s7,24(sp)
    18c0:	6125                	addi	sp,sp,96
    18c2:	8082                	ret
    if(total != N * SZ){
    18c4:	6785                	lui	a5,0x1
    18c6:	42d78793          	addi	a5,a5,1069 # 142d <truncate3+0x65>
    18ca:	02fa0063          	beq	s4,a5,18ea <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
    18ce:	85d2                	mv	a1,s4
    18d0:	00005517          	auipc	a0,0x5
    18d4:	13850513          	addi	a0,a0,312 # 6a08 <malloc+0xe0e>
    18d8:	00004097          	auipc	ra,0x4
    18dc:	264080e7          	jalr	612(ra) # 5b3c <printf>
      exit(1);
    18e0:	4505                	li	a0,1
    18e2:	00004097          	auipc	ra,0x4
    18e6:	ee2080e7          	jalr	-286(ra) # 57c4 <exit>
    close(fds[0]);
    18ea:	fa842503          	lw	a0,-88(s0)
    18ee:	00004097          	auipc	ra,0x4
    18f2:	efe080e7          	jalr	-258(ra) # 57ec <close>
    wait(&xstatus);
    18f6:	fa440513          	addi	a0,s0,-92
    18fa:	00004097          	auipc	ra,0x4
    18fe:	ed2080e7          	jalr	-302(ra) # 57cc <wait>
    exit(xstatus);
    1902:	fa442503          	lw	a0,-92(s0)
    1906:	00004097          	auipc	ra,0x4
    190a:	ebe080e7          	jalr	-322(ra) # 57c4 <exit>
    printf("%s: fork() failed\n", s);
    190e:	85ca                	mv	a1,s2
    1910:	00005517          	auipc	a0,0x5
    1914:	11850513          	addi	a0,a0,280 # 6a28 <malloc+0xe2e>
    1918:	00004097          	auipc	ra,0x4
    191c:	224080e7          	jalr	548(ra) # 5b3c <printf>
    exit(1);
    1920:	4505                	li	a0,1
    1922:	00004097          	auipc	ra,0x4
    1926:	ea2080e7          	jalr	-350(ra) # 57c4 <exit>

000000000000192a <exitwait>:
{
    192a:	7139                	addi	sp,sp,-64
    192c:	fc06                	sd	ra,56(sp)
    192e:	f822                	sd	s0,48(sp)
    1930:	f426                	sd	s1,40(sp)
    1932:	f04a                	sd	s2,32(sp)
    1934:	ec4e                	sd	s3,24(sp)
    1936:	e852                	sd	s4,16(sp)
    1938:	0080                	addi	s0,sp,64
    193a:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    193c:	4901                	li	s2,0
    193e:	06400993          	li	s3,100
    pid = fork();
    1942:	00004097          	auipc	ra,0x4
    1946:	e7a080e7          	jalr	-390(ra) # 57bc <fork>
    194a:	84aa                	mv	s1,a0
    if(pid < 0){
    194c:	02054a63          	bltz	a0,1980 <exitwait+0x56>
    if(pid){
    1950:	c151                	beqz	a0,19d4 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1952:	fcc40513          	addi	a0,s0,-52
    1956:	00004097          	auipc	ra,0x4
    195a:	e76080e7          	jalr	-394(ra) # 57cc <wait>
    195e:	02951f63          	bne	a0,s1,199c <exitwait+0x72>
      if(i != xstate) {
    1962:	fcc42783          	lw	a5,-52(s0)
    1966:	05279963          	bne	a5,s2,19b8 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    196a:	2905                	addiw	s2,s2,1
    196c:	fd391be3          	bne	s2,s3,1942 <exitwait+0x18>
}
    1970:	70e2                	ld	ra,56(sp)
    1972:	7442                	ld	s0,48(sp)
    1974:	74a2                	ld	s1,40(sp)
    1976:	7902                	ld	s2,32(sp)
    1978:	69e2                	ld	s3,24(sp)
    197a:	6a42                	ld	s4,16(sp)
    197c:	6121                	addi	sp,sp,64
    197e:	8082                	ret
      printf("%s: fork failed\n", s);
    1980:	85d2                	mv	a1,s4
    1982:	00005517          	auipc	a0,0x5
    1986:	f3650513          	addi	a0,a0,-202 # 68b8 <malloc+0xcbe>
    198a:	00004097          	auipc	ra,0x4
    198e:	1b2080e7          	jalr	434(ra) # 5b3c <printf>
      exit(1);
    1992:	4505                	li	a0,1
    1994:	00004097          	auipc	ra,0x4
    1998:	e30080e7          	jalr	-464(ra) # 57c4 <exit>
        printf("%s: wait wrong pid\n", s);
    199c:	85d2                	mv	a1,s4
    199e:	00005517          	auipc	a0,0x5
    19a2:	0a250513          	addi	a0,a0,162 # 6a40 <malloc+0xe46>
    19a6:	00004097          	auipc	ra,0x4
    19aa:	196080e7          	jalr	406(ra) # 5b3c <printf>
        exit(1);
    19ae:	4505                	li	a0,1
    19b0:	00004097          	auipc	ra,0x4
    19b4:	e14080e7          	jalr	-492(ra) # 57c4 <exit>
        printf("%s: wait wrong exit status\n", s);
    19b8:	85d2                	mv	a1,s4
    19ba:	00005517          	auipc	a0,0x5
    19be:	09e50513          	addi	a0,a0,158 # 6a58 <malloc+0xe5e>
    19c2:	00004097          	auipc	ra,0x4
    19c6:	17a080e7          	jalr	378(ra) # 5b3c <printf>
        exit(1);
    19ca:	4505                	li	a0,1
    19cc:	00004097          	auipc	ra,0x4
    19d0:	df8080e7          	jalr	-520(ra) # 57c4 <exit>
      exit(i);
    19d4:	854a                	mv	a0,s2
    19d6:	00004097          	auipc	ra,0x4
    19da:	dee080e7          	jalr	-530(ra) # 57c4 <exit>

00000000000019de <twochildren>:
{
    19de:	1101                	addi	sp,sp,-32
    19e0:	ec06                	sd	ra,24(sp)
    19e2:	e822                	sd	s0,16(sp)
    19e4:	e426                	sd	s1,8(sp)
    19e6:	e04a                	sd	s2,0(sp)
    19e8:	1000                	addi	s0,sp,32
    19ea:	892a                	mv	s2,a0
    19ec:	3e800493          	li	s1,1000
    int pid1 = fork();
    19f0:	00004097          	auipc	ra,0x4
    19f4:	dcc080e7          	jalr	-564(ra) # 57bc <fork>
    if(pid1 < 0){
    19f8:	02054c63          	bltz	a0,1a30 <twochildren+0x52>
    if(pid1 == 0){
    19fc:	c921                	beqz	a0,1a4c <twochildren+0x6e>
      int pid2 = fork();
    19fe:	00004097          	auipc	ra,0x4
    1a02:	dbe080e7          	jalr	-578(ra) # 57bc <fork>
      if(pid2 < 0){
    1a06:	04054763          	bltz	a0,1a54 <twochildren+0x76>
      if(pid2 == 0){
    1a0a:	c13d                	beqz	a0,1a70 <twochildren+0x92>
        wait(0);
    1a0c:	4501                	li	a0,0
    1a0e:	00004097          	auipc	ra,0x4
    1a12:	dbe080e7          	jalr	-578(ra) # 57cc <wait>
        wait(0);
    1a16:	4501                	li	a0,0
    1a18:	00004097          	auipc	ra,0x4
    1a1c:	db4080e7          	jalr	-588(ra) # 57cc <wait>
  for(int i = 0; i < 1000; i++){
    1a20:	34fd                	addiw	s1,s1,-1
    1a22:	f4f9                	bnez	s1,19f0 <twochildren+0x12>
}
    1a24:	60e2                	ld	ra,24(sp)
    1a26:	6442                	ld	s0,16(sp)
    1a28:	64a2                	ld	s1,8(sp)
    1a2a:	6902                	ld	s2,0(sp)
    1a2c:	6105                	addi	sp,sp,32
    1a2e:	8082                	ret
      printf("%s: fork failed\n", s);
    1a30:	85ca                	mv	a1,s2
    1a32:	00005517          	auipc	a0,0x5
    1a36:	e8650513          	addi	a0,a0,-378 # 68b8 <malloc+0xcbe>
    1a3a:	00004097          	auipc	ra,0x4
    1a3e:	102080e7          	jalr	258(ra) # 5b3c <printf>
      exit(1);
    1a42:	4505                	li	a0,1
    1a44:	00004097          	auipc	ra,0x4
    1a48:	d80080e7          	jalr	-640(ra) # 57c4 <exit>
      exit(0);
    1a4c:	00004097          	auipc	ra,0x4
    1a50:	d78080e7          	jalr	-648(ra) # 57c4 <exit>
        printf("%s: fork failed\n", s);
    1a54:	85ca                	mv	a1,s2
    1a56:	00005517          	auipc	a0,0x5
    1a5a:	e6250513          	addi	a0,a0,-414 # 68b8 <malloc+0xcbe>
    1a5e:	00004097          	auipc	ra,0x4
    1a62:	0de080e7          	jalr	222(ra) # 5b3c <printf>
        exit(1);
    1a66:	4505                	li	a0,1
    1a68:	00004097          	auipc	ra,0x4
    1a6c:	d5c080e7          	jalr	-676(ra) # 57c4 <exit>
        exit(0);
    1a70:	00004097          	auipc	ra,0x4
    1a74:	d54080e7          	jalr	-684(ra) # 57c4 <exit>

0000000000001a78 <forkfork>:
{
    1a78:	7179                	addi	sp,sp,-48
    1a7a:	f406                	sd	ra,40(sp)
    1a7c:	f022                	sd	s0,32(sp)
    1a7e:	ec26                	sd	s1,24(sp)
    1a80:	1800                	addi	s0,sp,48
    1a82:	84aa                	mv	s1,a0
    int pid = fork();
    1a84:	00004097          	auipc	ra,0x4
    1a88:	d38080e7          	jalr	-712(ra) # 57bc <fork>
    if(pid < 0){
    1a8c:	04054163          	bltz	a0,1ace <forkfork+0x56>
    if(pid == 0){
    1a90:	cd29                	beqz	a0,1aea <forkfork+0x72>
    int pid = fork();
    1a92:	00004097          	auipc	ra,0x4
    1a96:	d2a080e7          	jalr	-726(ra) # 57bc <fork>
    if(pid < 0){
    1a9a:	02054a63          	bltz	a0,1ace <forkfork+0x56>
    if(pid == 0){
    1a9e:	c531                	beqz	a0,1aea <forkfork+0x72>
    wait(&xstatus);
    1aa0:	fdc40513          	addi	a0,s0,-36
    1aa4:	00004097          	auipc	ra,0x4
    1aa8:	d28080e7          	jalr	-728(ra) # 57cc <wait>
    if(xstatus != 0) {
    1aac:	fdc42783          	lw	a5,-36(s0)
    1ab0:	ebbd                	bnez	a5,1b26 <forkfork+0xae>
    wait(&xstatus);
    1ab2:	fdc40513          	addi	a0,s0,-36
    1ab6:	00004097          	auipc	ra,0x4
    1aba:	d16080e7          	jalr	-746(ra) # 57cc <wait>
    if(xstatus != 0) {
    1abe:	fdc42783          	lw	a5,-36(s0)
    1ac2:	e3b5                	bnez	a5,1b26 <forkfork+0xae>
}
    1ac4:	70a2                	ld	ra,40(sp)
    1ac6:	7402                	ld	s0,32(sp)
    1ac8:	64e2                	ld	s1,24(sp)
    1aca:	6145                	addi	sp,sp,48
    1acc:	8082                	ret
      printf("%s: fork failed", s);
    1ace:	85a6                	mv	a1,s1
    1ad0:	00005517          	auipc	a0,0x5
    1ad4:	fa850513          	addi	a0,a0,-88 # 6a78 <malloc+0xe7e>
    1ad8:	00004097          	auipc	ra,0x4
    1adc:	064080e7          	jalr	100(ra) # 5b3c <printf>
      exit(1);
    1ae0:	4505                	li	a0,1
    1ae2:	00004097          	auipc	ra,0x4
    1ae6:	ce2080e7          	jalr	-798(ra) # 57c4 <exit>
{
    1aea:	0c800493          	li	s1,200
        int pid1 = fork();
    1aee:	00004097          	auipc	ra,0x4
    1af2:	cce080e7          	jalr	-818(ra) # 57bc <fork>
        if(pid1 < 0){
    1af6:	00054f63          	bltz	a0,1b14 <forkfork+0x9c>
        if(pid1 == 0){
    1afa:	c115                	beqz	a0,1b1e <forkfork+0xa6>
        wait(0);
    1afc:	4501                	li	a0,0
    1afe:	00004097          	auipc	ra,0x4
    1b02:	cce080e7          	jalr	-818(ra) # 57cc <wait>
      for(int j = 0; j < 200; j++){
    1b06:	34fd                	addiw	s1,s1,-1
    1b08:	f0fd                	bnez	s1,1aee <forkfork+0x76>
      exit(0);
    1b0a:	4501                	li	a0,0
    1b0c:	00004097          	auipc	ra,0x4
    1b10:	cb8080e7          	jalr	-840(ra) # 57c4 <exit>
          exit(1);
    1b14:	4505                	li	a0,1
    1b16:	00004097          	auipc	ra,0x4
    1b1a:	cae080e7          	jalr	-850(ra) # 57c4 <exit>
          exit(0);
    1b1e:	00004097          	auipc	ra,0x4
    1b22:	ca6080e7          	jalr	-858(ra) # 57c4 <exit>
      printf("%s: fork in child failed", s);
    1b26:	85a6                	mv	a1,s1
    1b28:	00005517          	auipc	a0,0x5
    1b2c:	f6050513          	addi	a0,a0,-160 # 6a88 <malloc+0xe8e>
    1b30:	00004097          	auipc	ra,0x4
    1b34:	00c080e7          	jalr	12(ra) # 5b3c <printf>
      exit(1);
    1b38:	4505                	li	a0,1
    1b3a:	00004097          	auipc	ra,0x4
    1b3e:	c8a080e7          	jalr	-886(ra) # 57c4 <exit>

0000000000001b42 <reparent2>:
{
    1b42:	1101                	addi	sp,sp,-32
    1b44:	ec06                	sd	ra,24(sp)
    1b46:	e822                	sd	s0,16(sp)
    1b48:	e426                	sd	s1,8(sp)
    1b4a:	1000                	addi	s0,sp,32
    1b4c:	32000493          	li	s1,800
    int pid1 = fork();
    1b50:	00004097          	auipc	ra,0x4
    1b54:	c6c080e7          	jalr	-916(ra) # 57bc <fork>
    if(pid1 < 0){
    1b58:	00054f63          	bltz	a0,1b76 <reparent2+0x34>
    if(pid1 == 0){
    1b5c:	c915                	beqz	a0,1b90 <reparent2+0x4e>
    wait(0);
    1b5e:	4501                	li	a0,0
    1b60:	00004097          	auipc	ra,0x4
    1b64:	c6c080e7          	jalr	-916(ra) # 57cc <wait>
  for(int i = 0; i < 800; i++){
    1b68:	34fd                	addiw	s1,s1,-1
    1b6a:	f0fd                	bnez	s1,1b50 <reparent2+0xe>
  exit(0);
    1b6c:	4501                	li	a0,0
    1b6e:	00004097          	auipc	ra,0x4
    1b72:	c56080e7          	jalr	-938(ra) # 57c4 <exit>
      printf("fork failed\n");
    1b76:	00005517          	auipc	a0,0x5
    1b7a:	14a50513          	addi	a0,a0,330 # 6cc0 <malloc+0x10c6>
    1b7e:	00004097          	auipc	ra,0x4
    1b82:	fbe080e7          	jalr	-66(ra) # 5b3c <printf>
      exit(1);
    1b86:	4505                	li	a0,1
    1b88:	00004097          	auipc	ra,0x4
    1b8c:	c3c080e7          	jalr	-964(ra) # 57c4 <exit>
      fork();
    1b90:	00004097          	auipc	ra,0x4
    1b94:	c2c080e7          	jalr	-980(ra) # 57bc <fork>
      fork();
    1b98:	00004097          	auipc	ra,0x4
    1b9c:	c24080e7          	jalr	-988(ra) # 57bc <fork>
      exit(0);
    1ba0:	4501                	li	a0,0
    1ba2:	00004097          	auipc	ra,0x4
    1ba6:	c22080e7          	jalr	-990(ra) # 57c4 <exit>

0000000000001baa <createdelete>:
{
    1baa:	7175                	addi	sp,sp,-144
    1bac:	e506                	sd	ra,136(sp)
    1bae:	e122                	sd	s0,128(sp)
    1bb0:	fca6                	sd	s1,120(sp)
    1bb2:	f8ca                	sd	s2,112(sp)
    1bb4:	f4ce                	sd	s3,104(sp)
    1bb6:	f0d2                	sd	s4,96(sp)
    1bb8:	ecd6                	sd	s5,88(sp)
    1bba:	e8da                	sd	s6,80(sp)
    1bbc:	e4de                	sd	s7,72(sp)
    1bbe:	e0e2                	sd	s8,64(sp)
    1bc0:	fc66                	sd	s9,56(sp)
    1bc2:	0900                	addi	s0,sp,144
    1bc4:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1bc6:	4901                	li	s2,0
    1bc8:	4991                	li	s3,4
    pid = fork();
    1bca:	00004097          	auipc	ra,0x4
    1bce:	bf2080e7          	jalr	-1038(ra) # 57bc <fork>
    1bd2:	84aa                	mv	s1,a0
    if(pid < 0){
    1bd4:	02054f63          	bltz	a0,1c12 <createdelete+0x68>
    if(pid == 0){
    1bd8:	c939                	beqz	a0,1c2e <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1bda:	2905                	addiw	s2,s2,1
    1bdc:	ff3917e3          	bne	s2,s3,1bca <createdelete+0x20>
    1be0:	4491                	li	s1,4
    wait(&xstatus);
    1be2:	f7c40513          	addi	a0,s0,-132
    1be6:	00004097          	auipc	ra,0x4
    1bea:	be6080e7          	jalr	-1050(ra) # 57cc <wait>
    if(xstatus != 0)
    1bee:	f7c42903          	lw	s2,-132(s0)
    1bf2:	0e091263          	bnez	s2,1cd6 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1bf6:	34fd                	addiw	s1,s1,-1
    1bf8:	f4ed                	bnez	s1,1be2 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1bfa:	f8040123          	sb	zero,-126(s0)
    1bfe:	03000993          	li	s3,48
    1c02:	5a7d                	li	s4,-1
    1c04:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1c08:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1c0a:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1c0c:	07400a93          	li	s5,116
    1c10:	a29d                	j	1d76 <createdelete+0x1cc>
      printf("fork failed\n", s);
    1c12:	85e6                	mv	a1,s9
    1c14:	00005517          	auipc	a0,0x5
    1c18:	0ac50513          	addi	a0,a0,172 # 6cc0 <malloc+0x10c6>
    1c1c:	00004097          	auipc	ra,0x4
    1c20:	f20080e7          	jalr	-224(ra) # 5b3c <printf>
      exit(1);
    1c24:	4505                	li	a0,1
    1c26:	00004097          	auipc	ra,0x4
    1c2a:	b9e080e7          	jalr	-1122(ra) # 57c4 <exit>
      name[0] = 'p' + pi;
    1c2e:	0709091b          	addiw	s2,s2,112
    1c32:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1c36:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1c3a:	4951                	li	s2,20
    1c3c:	a015                	j	1c60 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1c3e:	85e6                	mv	a1,s9
    1c40:	00005517          	auipc	a0,0x5
    1c44:	d1050513          	addi	a0,a0,-752 # 6950 <malloc+0xd56>
    1c48:	00004097          	auipc	ra,0x4
    1c4c:	ef4080e7          	jalr	-268(ra) # 5b3c <printf>
          exit(1);
    1c50:	4505                	li	a0,1
    1c52:	00004097          	auipc	ra,0x4
    1c56:	b72080e7          	jalr	-1166(ra) # 57c4 <exit>
      for(i = 0; i < N; i++){
    1c5a:	2485                	addiw	s1,s1,1
    1c5c:	07248863          	beq	s1,s2,1ccc <createdelete+0x122>
        name[1] = '0' + i;
    1c60:	0304879b          	addiw	a5,s1,48
    1c64:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1c68:	20200593          	li	a1,514
    1c6c:	f8040513          	addi	a0,s0,-128
    1c70:	00004097          	auipc	ra,0x4
    1c74:	b94080e7          	jalr	-1132(ra) # 5804 <open>
        if(fd < 0){
    1c78:	fc0543e3          	bltz	a0,1c3e <createdelete+0x94>
        close(fd);
    1c7c:	00004097          	auipc	ra,0x4
    1c80:	b70080e7          	jalr	-1168(ra) # 57ec <close>
        if(i > 0 && (i % 2 ) == 0){
    1c84:	fc905be3          	blez	s1,1c5a <createdelete+0xb0>
    1c88:	0014f793          	andi	a5,s1,1
    1c8c:	f7f9                	bnez	a5,1c5a <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1c8e:	01f4d79b          	srliw	a5,s1,0x1f
    1c92:	9fa5                	addw	a5,a5,s1
    1c94:	4017d79b          	sraiw	a5,a5,0x1
    1c98:	0307879b          	addiw	a5,a5,48
    1c9c:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1ca0:	f8040513          	addi	a0,s0,-128
    1ca4:	00004097          	auipc	ra,0x4
    1ca8:	b70080e7          	jalr	-1168(ra) # 5814 <unlink>
    1cac:	fa0557e3          	bgez	a0,1c5a <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1cb0:	85e6                	mv	a1,s9
    1cb2:	00005517          	auipc	a0,0x5
    1cb6:	df650513          	addi	a0,a0,-522 # 6aa8 <malloc+0xeae>
    1cba:	00004097          	auipc	ra,0x4
    1cbe:	e82080e7          	jalr	-382(ra) # 5b3c <printf>
            exit(1);
    1cc2:	4505                	li	a0,1
    1cc4:	00004097          	auipc	ra,0x4
    1cc8:	b00080e7          	jalr	-1280(ra) # 57c4 <exit>
      exit(0);
    1ccc:	4501                	li	a0,0
    1cce:	00004097          	auipc	ra,0x4
    1cd2:	af6080e7          	jalr	-1290(ra) # 57c4 <exit>
      exit(1);
    1cd6:	4505                	li	a0,1
    1cd8:	00004097          	auipc	ra,0x4
    1cdc:	aec080e7          	jalr	-1300(ra) # 57c4 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1ce0:	f8040613          	addi	a2,s0,-128
    1ce4:	85e6                	mv	a1,s9
    1ce6:	00005517          	auipc	a0,0x5
    1cea:	dda50513          	addi	a0,a0,-550 # 6ac0 <malloc+0xec6>
    1cee:	00004097          	auipc	ra,0x4
    1cf2:	e4e080e7          	jalr	-434(ra) # 5b3c <printf>
        exit(1);
    1cf6:	4505                	li	a0,1
    1cf8:	00004097          	auipc	ra,0x4
    1cfc:	acc080e7          	jalr	-1332(ra) # 57c4 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d00:	054b7163          	bgeu	s6,s4,1d42 <createdelete+0x198>
      if(fd >= 0)
    1d04:	02055a63          	bgez	a0,1d38 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1d08:	2485                	addiw	s1,s1,1
    1d0a:	0ff4f493          	andi	s1,s1,255
    1d0e:	05548c63          	beq	s1,s5,1d66 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1d12:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1d16:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1d1a:	4581                	li	a1,0
    1d1c:	f8040513          	addi	a0,s0,-128
    1d20:	00004097          	auipc	ra,0x4
    1d24:	ae4080e7          	jalr	-1308(ra) # 5804 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1d28:	00090463          	beqz	s2,1d30 <createdelete+0x186>
    1d2c:	fd2bdae3          	bge	s7,s2,1d00 <createdelete+0x156>
    1d30:	fa0548e3          	bltz	a0,1ce0 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d34:	014b7963          	bgeu	s6,s4,1d46 <createdelete+0x19c>
        close(fd);
    1d38:	00004097          	auipc	ra,0x4
    1d3c:	ab4080e7          	jalr	-1356(ra) # 57ec <close>
    1d40:	b7e1                	j	1d08 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d42:	fc0543e3          	bltz	a0,1d08 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1d46:	f8040613          	addi	a2,s0,-128
    1d4a:	85e6                	mv	a1,s9
    1d4c:	00005517          	auipc	a0,0x5
    1d50:	d9c50513          	addi	a0,a0,-612 # 6ae8 <malloc+0xeee>
    1d54:	00004097          	auipc	ra,0x4
    1d58:	de8080e7          	jalr	-536(ra) # 5b3c <printf>
        exit(1);
    1d5c:	4505                	li	a0,1
    1d5e:	00004097          	auipc	ra,0x4
    1d62:	a66080e7          	jalr	-1434(ra) # 57c4 <exit>
  for(i = 0; i < N; i++){
    1d66:	2905                	addiw	s2,s2,1
    1d68:	2a05                	addiw	s4,s4,1
    1d6a:	2985                	addiw	s3,s3,1
    1d6c:	0ff9f993          	andi	s3,s3,255
    1d70:	47d1                	li	a5,20
    1d72:	02f90a63          	beq	s2,a5,1da6 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1d76:	84e2                	mv	s1,s8
    1d78:	bf69                	j	1d12 <createdelete+0x168>
  for(i = 0; i < N; i++){
    1d7a:	2905                	addiw	s2,s2,1
    1d7c:	0ff97913          	andi	s2,s2,255
    1d80:	2985                	addiw	s3,s3,1
    1d82:	0ff9f993          	andi	s3,s3,255
    1d86:	03490863          	beq	s2,s4,1db6 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1d8a:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1d8c:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1d90:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1d94:	f8040513          	addi	a0,s0,-128
    1d98:	00004097          	auipc	ra,0x4
    1d9c:	a7c080e7          	jalr	-1412(ra) # 5814 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1da0:	34fd                	addiw	s1,s1,-1
    1da2:	f4ed                	bnez	s1,1d8c <createdelete+0x1e2>
    1da4:	bfd9                	j	1d7a <createdelete+0x1d0>
    1da6:	03000993          	li	s3,48
    1daa:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1dae:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1db0:	08400a13          	li	s4,132
    1db4:	bfd9                	j	1d8a <createdelete+0x1e0>
}
    1db6:	60aa                	ld	ra,136(sp)
    1db8:	640a                	ld	s0,128(sp)
    1dba:	74e6                	ld	s1,120(sp)
    1dbc:	7946                	ld	s2,112(sp)
    1dbe:	79a6                	ld	s3,104(sp)
    1dc0:	7a06                	ld	s4,96(sp)
    1dc2:	6ae6                	ld	s5,88(sp)
    1dc4:	6b46                	ld	s6,80(sp)
    1dc6:	6ba6                	ld	s7,72(sp)
    1dc8:	6c06                	ld	s8,64(sp)
    1dca:	7ce2                	ld	s9,56(sp)
    1dcc:	6149                	addi	sp,sp,144
    1dce:	8082                	ret

0000000000001dd0 <linkunlink>:
{
    1dd0:	711d                	addi	sp,sp,-96
    1dd2:	ec86                	sd	ra,88(sp)
    1dd4:	e8a2                	sd	s0,80(sp)
    1dd6:	e4a6                	sd	s1,72(sp)
    1dd8:	e0ca                	sd	s2,64(sp)
    1dda:	fc4e                	sd	s3,56(sp)
    1ddc:	f852                	sd	s4,48(sp)
    1dde:	f456                	sd	s5,40(sp)
    1de0:	f05a                	sd	s6,32(sp)
    1de2:	ec5e                	sd	s7,24(sp)
    1de4:	e862                	sd	s8,16(sp)
    1de6:	e466                	sd	s9,8(sp)
    1de8:	1080                	addi	s0,sp,96
    1dea:	84aa                	mv	s1,a0
  unlink("x");
    1dec:	00004517          	auipc	a0,0x4
    1df0:	30450513          	addi	a0,a0,772 # 60f0 <malloc+0x4f6>
    1df4:	00004097          	auipc	ra,0x4
    1df8:	a20080e7          	jalr	-1504(ra) # 5814 <unlink>
  pid = fork();
    1dfc:	00004097          	auipc	ra,0x4
    1e00:	9c0080e7          	jalr	-1600(ra) # 57bc <fork>
  if(pid < 0){
    1e04:	02054b63          	bltz	a0,1e3a <linkunlink+0x6a>
    1e08:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1e0a:	4c85                	li	s9,1
    1e0c:	e119                	bnez	a0,1e12 <linkunlink+0x42>
    1e0e:	06100c93          	li	s9,97
    1e12:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1e16:	41c659b7          	lui	s3,0x41c65
    1e1a:	e6d9899b          	addiw	s3,s3,-403
    1e1e:	690d                	lui	s2,0x3
    1e20:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    1e24:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1e26:	4b05                	li	s6,1
      unlink("x");
    1e28:	00004a97          	auipc	s5,0x4
    1e2c:	2c8a8a93          	addi	s5,s5,712 # 60f0 <malloc+0x4f6>
      link("cat", "x");
    1e30:	00005b97          	auipc	s7,0x5
    1e34:	ce0b8b93          	addi	s7,s7,-800 # 6b10 <malloc+0xf16>
    1e38:	a091                	j	1e7c <linkunlink+0xac>
    printf("%s: fork failed\n", s);
    1e3a:	85a6                	mv	a1,s1
    1e3c:	00005517          	auipc	a0,0x5
    1e40:	a7c50513          	addi	a0,a0,-1412 # 68b8 <malloc+0xcbe>
    1e44:	00004097          	auipc	ra,0x4
    1e48:	cf8080e7          	jalr	-776(ra) # 5b3c <printf>
    exit(1);
    1e4c:	4505                	li	a0,1
    1e4e:	00004097          	auipc	ra,0x4
    1e52:	976080e7          	jalr	-1674(ra) # 57c4 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1e56:	20200593          	li	a1,514
    1e5a:	8556                	mv	a0,s5
    1e5c:	00004097          	auipc	ra,0x4
    1e60:	9a8080e7          	jalr	-1624(ra) # 5804 <open>
    1e64:	00004097          	auipc	ra,0x4
    1e68:	988080e7          	jalr	-1656(ra) # 57ec <close>
    1e6c:	a031                	j	1e78 <linkunlink+0xa8>
      unlink("x");
    1e6e:	8556                	mv	a0,s5
    1e70:	00004097          	auipc	ra,0x4
    1e74:	9a4080e7          	jalr	-1628(ra) # 5814 <unlink>
  for(i = 0; i < 100; i++){
    1e78:	34fd                	addiw	s1,s1,-1
    1e7a:	c09d                	beqz	s1,1ea0 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    1e7c:	033c87bb          	mulw	a5,s9,s3
    1e80:	012787bb          	addw	a5,a5,s2
    1e84:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1e88:	0347f7bb          	remuw	a5,a5,s4
    1e8c:	d7e9                	beqz	a5,1e56 <linkunlink+0x86>
    } else if((x % 3) == 1){
    1e8e:	ff6790e3          	bne	a5,s6,1e6e <linkunlink+0x9e>
      link("cat", "x");
    1e92:	85d6                	mv	a1,s5
    1e94:	855e                	mv	a0,s7
    1e96:	00004097          	auipc	ra,0x4
    1e9a:	98e080e7          	jalr	-1650(ra) # 5824 <link>
    1e9e:	bfe9                	j	1e78 <linkunlink+0xa8>
  if(pid)
    1ea0:	020c0463          	beqz	s8,1ec8 <linkunlink+0xf8>
    wait(0);
    1ea4:	4501                	li	a0,0
    1ea6:	00004097          	auipc	ra,0x4
    1eaa:	926080e7          	jalr	-1754(ra) # 57cc <wait>
}
    1eae:	60e6                	ld	ra,88(sp)
    1eb0:	6446                	ld	s0,80(sp)
    1eb2:	64a6                	ld	s1,72(sp)
    1eb4:	6906                	ld	s2,64(sp)
    1eb6:	79e2                	ld	s3,56(sp)
    1eb8:	7a42                	ld	s4,48(sp)
    1eba:	7aa2                	ld	s5,40(sp)
    1ebc:	7b02                	ld	s6,32(sp)
    1ebe:	6be2                	ld	s7,24(sp)
    1ec0:	6c42                	ld	s8,16(sp)
    1ec2:	6ca2                	ld	s9,8(sp)
    1ec4:	6125                	addi	sp,sp,96
    1ec6:	8082                	ret
    exit(0);
    1ec8:	4501                	li	a0,0
    1eca:	00004097          	auipc	ra,0x4
    1ece:	8fa080e7          	jalr	-1798(ra) # 57c4 <exit>

0000000000001ed2 <manywrites>:
{
    1ed2:	711d                	addi	sp,sp,-96
    1ed4:	ec86                	sd	ra,88(sp)
    1ed6:	e8a2                	sd	s0,80(sp)
    1ed8:	e4a6                	sd	s1,72(sp)
    1eda:	e0ca                	sd	s2,64(sp)
    1edc:	fc4e                	sd	s3,56(sp)
    1ede:	f852                	sd	s4,48(sp)
    1ee0:	f456                	sd	s5,40(sp)
    1ee2:	f05a                	sd	s6,32(sp)
    1ee4:	ec5e                	sd	s7,24(sp)
    1ee6:	1080                	addi	s0,sp,96
    1ee8:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1eea:	4901                	li	s2,0
    1eec:	4991                	li	s3,4
    int pid = fork();
    1eee:	00004097          	auipc	ra,0x4
    1ef2:	8ce080e7          	jalr	-1842(ra) # 57bc <fork>
    1ef6:	84aa                	mv	s1,a0
    if(pid < 0){
    1ef8:	02054963          	bltz	a0,1f2a <manywrites+0x58>
    if(pid == 0){
    1efc:	c521                	beqz	a0,1f44 <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    1efe:	2905                	addiw	s2,s2,1
    1f00:	ff3917e3          	bne	s2,s3,1eee <manywrites+0x1c>
    1f04:	4491                	li	s1,4
    int st = 0;
    1f06:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1f0a:	fa840513          	addi	a0,s0,-88
    1f0e:	00004097          	auipc	ra,0x4
    1f12:	8be080e7          	jalr	-1858(ra) # 57cc <wait>
    if(st != 0)
    1f16:	fa842503          	lw	a0,-88(s0)
    1f1a:	ed6d                	bnez	a0,2014 <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    1f1c:	34fd                	addiw	s1,s1,-1
    1f1e:	f4e5                	bnez	s1,1f06 <manywrites+0x34>
  exit(0);
    1f20:	4501                	li	a0,0
    1f22:	00004097          	auipc	ra,0x4
    1f26:	8a2080e7          	jalr	-1886(ra) # 57c4 <exit>
      printf("fork failed\n");
    1f2a:	00005517          	auipc	a0,0x5
    1f2e:	d9650513          	addi	a0,a0,-618 # 6cc0 <malloc+0x10c6>
    1f32:	00004097          	auipc	ra,0x4
    1f36:	c0a080e7          	jalr	-1014(ra) # 5b3c <printf>
      exit(1);
    1f3a:	4505                	li	a0,1
    1f3c:	00004097          	auipc	ra,0x4
    1f40:	888080e7          	jalr	-1912(ra) # 57c4 <exit>
      name[0] = 'b';
    1f44:	06200793          	li	a5,98
    1f48:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1f4c:	0619079b          	addiw	a5,s2,97
    1f50:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1f54:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1f58:	fa840513          	addi	a0,s0,-88
    1f5c:	00004097          	auipc	ra,0x4
    1f60:	8b8080e7          	jalr	-1864(ra) # 5814 <unlink>
    1f64:	4b79                	li	s6,30
          int cc = write(fd, buf, sz);
    1f66:	0000ab97          	auipc	s7,0xa
    1f6a:	d8ab8b93          	addi	s7,s7,-630 # bcf0 <buf>
        for(int i = 0; i < ci+1; i++){
    1f6e:	8a26                	mv	s4,s1
    1f70:	02094e63          	bltz	s2,1fac <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    1f74:	20200593          	li	a1,514
    1f78:	fa840513          	addi	a0,s0,-88
    1f7c:	00004097          	auipc	ra,0x4
    1f80:	888080e7          	jalr	-1912(ra) # 5804 <open>
    1f84:	89aa                	mv	s3,a0
          if(fd < 0){
    1f86:	04054763          	bltz	a0,1fd4 <manywrites+0x102>
          int cc = write(fd, buf, sz);
    1f8a:	660d                	lui	a2,0x3
    1f8c:	85de                	mv	a1,s7
    1f8e:	00004097          	auipc	ra,0x4
    1f92:	856080e7          	jalr	-1962(ra) # 57e4 <write>
          if(cc != sz){
    1f96:	678d                	lui	a5,0x3
    1f98:	04f51e63          	bne	a0,a5,1ff4 <manywrites+0x122>
          close(fd);
    1f9c:	854e                	mv	a0,s3
    1f9e:	00004097          	auipc	ra,0x4
    1fa2:	84e080e7          	jalr	-1970(ra) # 57ec <close>
        for(int i = 0; i < ci+1; i++){
    1fa6:	2a05                	addiw	s4,s4,1
    1fa8:	fd4956e3          	bge	s2,s4,1f74 <manywrites+0xa2>
        unlink(name);
    1fac:	fa840513          	addi	a0,s0,-88
    1fb0:	00004097          	auipc	ra,0x4
    1fb4:	864080e7          	jalr	-1948(ra) # 5814 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1fb8:	3b7d                	addiw	s6,s6,-1
    1fba:	fa0b1ae3          	bnez	s6,1f6e <manywrites+0x9c>
      unlink(name);
    1fbe:	fa840513          	addi	a0,s0,-88
    1fc2:	00004097          	auipc	ra,0x4
    1fc6:	852080e7          	jalr	-1966(ra) # 5814 <unlink>
      exit(0);
    1fca:	4501                	li	a0,0
    1fcc:	00003097          	auipc	ra,0x3
    1fd0:	7f8080e7          	jalr	2040(ra) # 57c4 <exit>
            printf("%s: cannot create %s\n", s, name);
    1fd4:	fa840613          	addi	a2,s0,-88
    1fd8:	85d6                	mv	a1,s5
    1fda:	00005517          	auipc	a0,0x5
    1fde:	b3e50513          	addi	a0,a0,-1218 # 6b18 <malloc+0xf1e>
    1fe2:	00004097          	auipc	ra,0x4
    1fe6:	b5a080e7          	jalr	-1190(ra) # 5b3c <printf>
            exit(1);
    1fea:	4505                	li	a0,1
    1fec:	00003097          	auipc	ra,0x3
    1ff0:	7d8080e7          	jalr	2008(ra) # 57c4 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1ff4:	86aa                	mv	a3,a0
    1ff6:	660d                	lui	a2,0x3
    1ff8:	85d6                	mv	a1,s5
    1ffa:	00004517          	auipc	a0,0x4
    1ffe:	14650513          	addi	a0,a0,326 # 6140 <malloc+0x546>
    2002:	00004097          	auipc	ra,0x4
    2006:	b3a080e7          	jalr	-1222(ra) # 5b3c <printf>
            exit(1);
    200a:	4505                	li	a0,1
    200c:	00003097          	auipc	ra,0x3
    2010:	7b8080e7          	jalr	1976(ra) # 57c4 <exit>
      exit(st);
    2014:	00003097          	auipc	ra,0x3
    2018:	7b0080e7          	jalr	1968(ra) # 57c4 <exit>

000000000000201c <forktest>:
{
    201c:	7179                	addi	sp,sp,-48
    201e:	f406                	sd	ra,40(sp)
    2020:	f022                	sd	s0,32(sp)
    2022:	ec26                	sd	s1,24(sp)
    2024:	e84a                	sd	s2,16(sp)
    2026:	e44e                	sd	s3,8(sp)
    2028:	1800                	addi	s0,sp,48
    202a:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    202c:	4481                	li	s1,0
    202e:	3e800913          	li	s2,1000
    pid = fork();
    2032:	00003097          	auipc	ra,0x3
    2036:	78a080e7          	jalr	1930(ra) # 57bc <fork>
    if(pid < 0)
    203a:	02054863          	bltz	a0,206a <forktest+0x4e>
    if(pid == 0)
    203e:	c115                	beqz	a0,2062 <forktest+0x46>
  for(n=0; n<N; n++){
    2040:	2485                	addiw	s1,s1,1
    2042:	ff2498e3          	bne	s1,s2,2032 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    2046:	85ce                	mv	a1,s3
    2048:	00005517          	auipc	a0,0x5
    204c:	b0050513          	addi	a0,a0,-1280 # 6b48 <malloc+0xf4e>
    2050:	00004097          	auipc	ra,0x4
    2054:	aec080e7          	jalr	-1300(ra) # 5b3c <printf>
    exit(1);
    2058:	4505                	li	a0,1
    205a:	00003097          	auipc	ra,0x3
    205e:	76a080e7          	jalr	1898(ra) # 57c4 <exit>
      exit(0);
    2062:	00003097          	auipc	ra,0x3
    2066:	762080e7          	jalr	1890(ra) # 57c4 <exit>
  if (n == 0) {
    206a:	cc9d                	beqz	s1,20a8 <forktest+0x8c>
  if(n == N){
    206c:	3e800793          	li	a5,1000
    2070:	fcf48be3          	beq	s1,a5,2046 <forktest+0x2a>
  for(; n > 0; n--){
    2074:	00905b63          	blez	s1,208a <forktest+0x6e>
    if(wait(0) < 0){
    2078:	4501                	li	a0,0
    207a:	00003097          	auipc	ra,0x3
    207e:	752080e7          	jalr	1874(ra) # 57cc <wait>
    2082:	04054163          	bltz	a0,20c4 <forktest+0xa8>
  for(; n > 0; n--){
    2086:	34fd                	addiw	s1,s1,-1
    2088:	f8e5                	bnez	s1,2078 <forktest+0x5c>
  if(wait(0) != -1){
    208a:	4501                	li	a0,0
    208c:	00003097          	auipc	ra,0x3
    2090:	740080e7          	jalr	1856(ra) # 57cc <wait>
    2094:	57fd                	li	a5,-1
    2096:	04f51563          	bne	a0,a5,20e0 <forktest+0xc4>
}
    209a:	70a2                	ld	ra,40(sp)
    209c:	7402                	ld	s0,32(sp)
    209e:	64e2                	ld	s1,24(sp)
    20a0:	6942                	ld	s2,16(sp)
    20a2:	69a2                	ld	s3,8(sp)
    20a4:	6145                	addi	sp,sp,48
    20a6:	8082                	ret
    printf("%s: no fork at all!\n", s);
    20a8:	85ce                	mv	a1,s3
    20aa:	00005517          	auipc	a0,0x5
    20ae:	a8650513          	addi	a0,a0,-1402 # 6b30 <malloc+0xf36>
    20b2:	00004097          	auipc	ra,0x4
    20b6:	a8a080e7          	jalr	-1398(ra) # 5b3c <printf>
    exit(1);
    20ba:	4505                	li	a0,1
    20bc:	00003097          	auipc	ra,0x3
    20c0:	708080e7          	jalr	1800(ra) # 57c4 <exit>
      printf("%s: wait stopped early\n", s);
    20c4:	85ce                	mv	a1,s3
    20c6:	00005517          	auipc	a0,0x5
    20ca:	aaa50513          	addi	a0,a0,-1366 # 6b70 <malloc+0xf76>
    20ce:	00004097          	auipc	ra,0x4
    20d2:	a6e080e7          	jalr	-1426(ra) # 5b3c <printf>
      exit(1);
    20d6:	4505                	li	a0,1
    20d8:	00003097          	auipc	ra,0x3
    20dc:	6ec080e7          	jalr	1772(ra) # 57c4 <exit>
    printf("%s: wait got too many\n", s);
    20e0:	85ce                	mv	a1,s3
    20e2:	00005517          	auipc	a0,0x5
    20e6:	aa650513          	addi	a0,a0,-1370 # 6b88 <malloc+0xf8e>
    20ea:	00004097          	auipc	ra,0x4
    20ee:	a52080e7          	jalr	-1454(ra) # 5b3c <printf>
    exit(1);
    20f2:	4505                	li	a0,1
    20f4:	00003097          	auipc	ra,0x3
    20f8:	6d0080e7          	jalr	1744(ra) # 57c4 <exit>

00000000000020fc <kernmem>:
{
    20fc:	715d                	addi	sp,sp,-80
    20fe:	e486                	sd	ra,72(sp)
    2100:	e0a2                	sd	s0,64(sp)
    2102:	fc26                	sd	s1,56(sp)
    2104:	f84a                	sd	s2,48(sp)
    2106:	f44e                	sd	s3,40(sp)
    2108:	f052                	sd	s4,32(sp)
    210a:	ec56                	sd	s5,24(sp)
    210c:	0880                	addi	s0,sp,80
    210e:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2110:	4485                	li	s1,1
    2112:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    2114:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2116:	69b1                	lui	s3,0xc
    2118:	35098993          	addi	s3,s3,848 # c350 <buf+0x660>
    211c:	1003d937          	lui	s2,0x1003d
    2120:	090e                	slli	s2,s2,0x3
    2122:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002e780>
    pid = fork();
    2126:	00003097          	auipc	ra,0x3
    212a:	696080e7          	jalr	1686(ra) # 57bc <fork>
    if(pid < 0){
    212e:	02054963          	bltz	a0,2160 <kernmem+0x64>
    if(pid == 0){
    2132:	c529                	beqz	a0,217c <kernmem+0x80>
    wait(&xstatus);
    2134:	fbc40513          	addi	a0,s0,-68
    2138:	00003097          	auipc	ra,0x3
    213c:	694080e7          	jalr	1684(ra) # 57cc <wait>
    if(xstatus != -1)  // did kernel kill child?
    2140:	fbc42783          	lw	a5,-68(s0)
    2144:	05579d63          	bne	a5,s5,219e <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2148:	94ce                	add	s1,s1,s3
    214a:	fd249ee3          	bne	s1,s2,2126 <kernmem+0x2a>
}
    214e:	60a6                	ld	ra,72(sp)
    2150:	6406                	ld	s0,64(sp)
    2152:	74e2                	ld	s1,56(sp)
    2154:	7942                	ld	s2,48(sp)
    2156:	79a2                	ld	s3,40(sp)
    2158:	7a02                	ld	s4,32(sp)
    215a:	6ae2                	ld	s5,24(sp)
    215c:	6161                	addi	sp,sp,80
    215e:	8082                	ret
      printf("%s: fork failed\n", s);
    2160:	85d2                	mv	a1,s4
    2162:	00004517          	auipc	a0,0x4
    2166:	75650513          	addi	a0,a0,1878 # 68b8 <malloc+0xcbe>
    216a:	00004097          	auipc	ra,0x4
    216e:	9d2080e7          	jalr	-1582(ra) # 5b3c <printf>
      exit(1);
    2172:	4505                	li	a0,1
    2174:	00003097          	auipc	ra,0x3
    2178:	650080e7          	jalr	1616(ra) # 57c4 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    217c:	0004c683          	lbu	a3,0(s1)
    2180:	8626                	mv	a2,s1
    2182:	85d2                	mv	a1,s4
    2184:	00005517          	auipc	a0,0x5
    2188:	a1c50513          	addi	a0,a0,-1508 # 6ba0 <malloc+0xfa6>
    218c:	00004097          	auipc	ra,0x4
    2190:	9b0080e7          	jalr	-1616(ra) # 5b3c <printf>
      exit(1);
    2194:	4505                	li	a0,1
    2196:	00003097          	auipc	ra,0x3
    219a:	62e080e7          	jalr	1582(ra) # 57c4 <exit>
      exit(1);
    219e:	4505                	li	a0,1
    21a0:	00003097          	auipc	ra,0x3
    21a4:	624080e7          	jalr	1572(ra) # 57c4 <exit>

00000000000021a8 <bigargtest>:
{
    21a8:	7179                	addi	sp,sp,-48
    21aa:	f406                	sd	ra,40(sp)
    21ac:	f022                	sd	s0,32(sp)
    21ae:	ec26                	sd	s1,24(sp)
    21b0:	1800                	addi	s0,sp,48
    21b2:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    21b4:	00005517          	auipc	a0,0x5
    21b8:	a0c50513          	addi	a0,a0,-1524 # 6bc0 <malloc+0xfc6>
    21bc:	00003097          	auipc	ra,0x3
    21c0:	658080e7          	jalr	1624(ra) # 5814 <unlink>
  pid = fork();
    21c4:	00003097          	auipc	ra,0x3
    21c8:	5f8080e7          	jalr	1528(ra) # 57bc <fork>
  if(pid == 0){
    21cc:	c121                	beqz	a0,220c <bigargtest+0x64>
  } else if(pid < 0){
    21ce:	0a054063          	bltz	a0,226e <bigargtest+0xc6>
  wait(&xstatus);
    21d2:	fdc40513          	addi	a0,s0,-36
    21d6:	00003097          	auipc	ra,0x3
    21da:	5f6080e7          	jalr	1526(ra) # 57cc <wait>
  if(xstatus != 0)
    21de:	fdc42503          	lw	a0,-36(s0)
    21e2:	e545                	bnez	a0,228a <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    21e4:	4581                	li	a1,0
    21e6:	00005517          	auipc	a0,0x5
    21ea:	9da50513          	addi	a0,a0,-1574 # 6bc0 <malloc+0xfc6>
    21ee:	00003097          	auipc	ra,0x3
    21f2:	616080e7          	jalr	1558(ra) # 5804 <open>
  if(fd < 0){
    21f6:	08054e63          	bltz	a0,2292 <bigargtest+0xea>
  close(fd);
    21fa:	00003097          	auipc	ra,0x3
    21fe:	5f2080e7          	jalr	1522(ra) # 57ec <close>
}
    2202:	70a2                	ld	ra,40(sp)
    2204:	7402                	ld	s0,32(sp)
    2206:	64e2                	ld	s1,24(sp)
    2208:	6145                	addi	sp,sp,48
    220a:	8082                	ret
    220c:	00006797          	auipc	a5,0x6
    2210:	2cc78793          	addi	a5,a5,716 # 84d8 <args.1853>
    2214:	00006697          	auipc	a3,0x6
    2218:	3bc68693          	addi	a3,a3,956 # 85d0 <args.1853+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    221c:	00005717          	auipc	a4,0x5
    2220:	9b470713          	addi	a4,a4,-1612 # 6bd0 <malloc+0xfd6>
    2224:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    2226:	07a1                	addi	a5,a5,8
    2228:	fed79ee3          	bne	a5,a3,2224 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    222c:	00006597          	auipc	a1,0x6
    2230:	2ac58593          	addi	a1,a1,684 # 84d8 <args.1853>
    2234:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2238:	00004517          	auipc	a0,0x4
    223c:	e4850513          	addi	a0,a0,-440 # 6080 <malloc+0x486>
    2240:	00003097          	auipc	ra,0x3
    2244:	5bc080e7          	jalr	1468(ra) # 57fc <exec>
    fd = open("bigarg-ok", O_CREATE);
    2248:	20000593          	li	a1,512
    224c:	00005517          	auipc	a0,0x5
    2250:	97450513          	addi	a0,a0,-1676 # 6bc0 <malloc+0xfc6>
    2254:	00003097          	auipc	ra,0x3
    2258:	5b0080e7          	jalr	1456(ra) # 5804 <open>
    close(fd);
    225c:	00003097          	auipc	ra,0x3
    2260:	590080e7          	jalr	1424(ra) # 57ec <close>
    exit(0);
    2264:	4501                	li	a0,0
    2266:	00003097          	auipc	ra,0x3
    226a:	55e080e7          	jalr	1374(ra) # 57c4 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    226e:	85a6                	mv	a1,s1
    2270:	00005517          	auipc	a0,0x5
    2274:	a4050513          	addi	a0,a0,-1472 # 6cb0 <malloc+0x10b6>
    2278:	00004097          	auipc	ra,0x4
    227c:	8c4080e7          	jalr	-1852(ra) # 5b3c <printf>
    exit(1);
    2280:	4505                	li	a0,1
    2282:	00003097          	auipc	ra,0x3
    2286:	542080e7          	jalr	1346(ra) # 57c4 <exit>
    exit(xstatus);
    228a:	00003097          	auipc	ra,0x3
    228e:	53a080e7          	jalr	1338(ra) # 57c4 <exit>
    printf("%s: bigarg test failed!\n", s);
    2292:	85a6                	mv	a1,s1
    2294:	00005517          	auipc	a0,0x5
    2298:	a3c50513          	addi	a0,a0,-1476 # 6cd0 <malloc+0x10d6>
    229c:	00004097          	auipc	ra,0x4
    22a0:	8a0080e7          	jalr	-1888(ra) # 5b3c <printf>
    exit(1);
    22a4:	4505                	li	a0,1
    22a6:	00003097          	auipc	ra,0x3
    22aa:	51e080e7          	jalr	1310(ra) # 57c4 <exit>

00000000000022ae <stacktest>:
{
    22ae:	7179                	addi	sp,sp,-48
    22b0:	f406                	sd	ra,40(sp)
    22b2:	f022                	sd	s0,32(sp)
    22b4:	ec26                	sd	s1,24(sp)
    22b6:	1800                	addi	s0,sp,48
    22b8:	84aa                	mv	s1,a0
  pid = fork();
    22ba:	00003097          	auipc	ra,0x3
    22be:	502080e7          	jalr	1282(ra) # 57bc <fork>
  if(pid == 0) {
    22c2:	c115                	beqz	a0,22e6 <stacktest+0x38>
  } else if(pid < 0){
    22c4:	04054463          	bltz	a0,230c <stacktest+0x5e>
  wait(&xstatus);
    22c8:	fdc40513          	addi	a0,s0,-36
    22cc:	00003097          	auipc	ra,0x3
    22d0:	500080e7          	jalr	1280(ra) # 57cc <wait>
  if(xstatus == -1)  // kernel killed child?
    22d4:	fdc42503          	lw	a0,-36(s0)
    22d8:	57fd                	li	a5,-1
    22da:	04f50763          	beq	a0,a5,2328 <stacktest+0x7a>
    exit(xstatus);
    22de:	00003097          	auipc	ra,0x3
    22e2:	4e6080e7          	jalr	1254(ra) # 57c4 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    22e6:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    22e8:	77fd                	lui	a5,0xfffff
    22ea:	97ba                	add	a5,a5,a4
    22ec:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff0300>
    22f0:	85a6                	mv	a1,s1
    22f2:	00005517          	auipc	a0,0x5
    22f6:	9fe50513          	addi	a0,a0,-1538 # 6cf0 <malloc+0x10f6>
    22fa:	00004097          	auipc	ra,0x4
    22fe:	842080e7          	jalr	-1982(ra) # 5b3c <printf>
    exit(1);
    2302:	4505                	li	a0,1
    2304:	00003097          	auipc	ra,0x3
    2308:	4c0080e7          	jalr	1216(ra) # 57c4 <exit>
    printf("%s: fork failed\n", s);
    230c:	85a6                	mv	a1,s1
    230e:	00004517          	auipc	a0,0x4
    2312:	5aa50513          	addi	a0,a0,1450 # 68b8 <malloc+0xcbe>
    2316:	00004097          	auipc	ra,0x4
    231a:	826080e7          	jalr	-2010(ra) # 5b3c <printf>
    exit(1);
    231e:	4505                	li	a0,1
    2320:	00003097          	auipc	ra,0x3
    2324:	4a4080e7          	jalr	1188(ra) # 57c4 <exit>
    exit(0);
    2328:	4501                	li	a0,0
    232a:	00003097          	auipc	ra,0x3
    232e:	49a080e7          	jalr	1178(ra) # 57c4 <exit>

0000000000002332 <copyinstr3>:
{
    2332:	7179                	addi	sp,sp,-48
    2334:	f406                	sd	ra,40(sp)
    2336:	f022                	sd	s0,32(sp)
    2338:	ec26                	sd	s1,24(sp)
    233a:	1800                	addi	s0,sp,48
  sbrk(8192);
    233c:	6509                	lui	a0,0x2
    233e:	00003097          	auipc	ra,0x3
    2342:	50e080e7          	jalr	1294(ra) # 584c <sbrk>
  uint64 top = (uint64) sbrk(0);
    2346:	4501                	li	a0,0
    2348:	00003097          	auipc	ra,0x3
    234c:	504080e7          	jalr	1284(ra) # 584c <sbrk>
  if((top % PGSIZE) != 0){
    2350:	03451793          	slli	a5,a0,0x34
    2354:	e3c9                	bnez	a5,23d6 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    2356:	4501                	li	a0,0
    2358:	00003097          	auipc	ra,0x3
    235c:	4f4080e7          	jalr	1268(ra) # 584c <sbrk>
  if(top % PGSIZE){
    2360:	03451793          	slli	a5,a0,0x34
    2364:	e3d9                	bnez	a5,23ea <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2366:	fff50493          	addi	s1,a0,-1 # 1fff <manywrites+0x12d>
  *b = 'x';
    236a:	07800793          	li	a5,120
    236e:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2372:	8526                	mv	a0,s1
    2374:	00003097          	auipc	ra,0x3
    2378:	4a0080e7          	jalr	1184(ra) # 5814 <unlink>
  if(ret != -1){
    237c:	57fd                	li	a5,-1
    237e:	08f51363          	bne	a0,a5,2404 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    2382:	20100593          	li	a1,513
    2386:	8526                	mv	a0,s1
    2388:	00003097          	auipc	ra,0x3
    238c:	47c080e7          	jalr	1148(ra) # 5804 <open>
  if(fd != -1){
    2390:	57fd                	li	a5,-1
    2392:	08f51863          	bne	a0,a5,2422 <copyinstr3+0xf0>
  ret = link(b, b);
    2396:	85a6                	mv	a1,s1
    2398:	8526                	mv	a0,s1
    239a:	00003097          	auipc	ra,0x3
    239e:	48a080e7          	jalr	1162(ra) # 5824 <link>
  if(ret != -1){
    23a2:	57fd                	li	a5,-1
    23a4:	08f51e63          	bne	a0,a5,2440 <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    23a8:	00005797          	auipc	a5,0x5
    23ac:	5e078793          	addi	a5,a5,1504 # 7988 <malloc+0x1d8e>
    23b0:	fcf43823          	sd	a5,-48(s0)
    23b4:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    23b8:	fd040593          	addi	a1,s0,-48
    23bc:	8526                	mv	a0,s1
    23be:	00003097          	auipc	ra,0x3
    23c2:	43e080e7          	jalr	1086(ra) # 57fc <exec>
  if(ret != -1){
    23c6:	57fd                	li	a5,-1
    23c8:	08f51c63          	bne	a0,a5,2460 <copyinstr3+0x12e>
}
    23cc:	70a2                	ld	ra,40(sp)
    23ce:	7402                	ld	s0,32(sp)
    23d0:	64e2                	ld	s1,24(sp)
    23d2:	6145                	addi	sp,sp,48
    23d4:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    23d6:	0347d513          	srli	a0,a5,0x34
    23da:	6785                	lui	a5,0x1
    23dc:	40a7853b          	subw	a0,a5,a0
    23e0:	00003097          	auipc	ra,0x3
    23e4:	46c080e7          	jalr	1132(ra) # 584c <sbrk>
    23e8:	b7bd                	j	2356 <copyinstr3+0x24>
    printf("oops\n");
    23ea:	00005517          	auipc	a0,0x5
    23ee:	92e50513          	addi	a0,a0,-1746 # 6d18 <malloc+0x111e>
    23f2:	00003097          	auipc	ra,0x3
    23f6:	74a080e7          	jalr	1866(ra) # 5b3c <printf>
    exit(1);
    23fa:	4505                	li	a0,1
    23fc:	00003097          	auipc	ra,0x3
    2400:	3c8080e7          	jalr	968(ra) # 57c4 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    2404:	862a                	mv	a2,a0
    2406:	85a6                	mv	a1,s1
    2408:	00004517          	auipc	a0,0x4
    240c:	3d050513          	addi	a0,a0,976 # 67d8 <malloc+0xbde>
    2410:	00003097          	auipc	ra,0x3
    2414:	72c080e7          	jalr	1836(ra) # 5b3c <printf>
    exit(1);
    2418:	4505                	li	a0,1
    241a:	00003097          	auipc	ra,0x3
    241e:	3aa080e7          	jalr	938(ra) # 57c4 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2422:	862a                	mv	a2,a0
    2424:	85a6                	mv	a1,s1
    2426:	00004517          	auipc	a0,0x4
    242a:	3d250513          	addi	a0,a0,978 # 67f8 <malloc+0xbfe>
    242e:	00003097          	auipc	ra,0x3
    2432:	70e080e7          	jalr	1806(ra) # 5b3c <printf>
    exit(1);
    2436:	4505                	li	a0,1
    2438:	00003097          	auipc	ra,0x3
    243c:	38c080e7          	jalr	908(ra) # 57c4 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    2440:	86aa                	mv	a3,a0
    2442:	8626                	mv	a2,s1
    2444:	85a6                	mv	a1,s1
    2446:	00004517          	auipc	a0,0x4
    244a:	3d250513          	addi	a0,a0,978 # 6818 <malloc+0xc1e>
    244e:	00003097          	auipc	ra,0x3
    2452:	6ee080e7          	jalr	1774(ra) # 5b3c <printf>
    exit(1);
    2456:	4505                	li	a0,1
    2458:	00003097          	auipc	ra,0x3
    245c:	36c080e7          	jalr	876(ra) # 57c4 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2460:	567d                	li	a2,-1
    2462:	85a6                	mv	a1,s1
    2464:	00004517          	auipc	a0,0x4
    2468:	3dc50513          	addi	a0,a0,988 # 6840 <malloc+0xc46>
    246c:	00003097          	auipc	ra,0x3
    2470:	6d0080e7          	jalr	1744(ra) # 5b3c <printf>
    exit(1);
    2474:	4505                	li	a0,1
    2476:	00003097          	auipc	ra,0x3
    247a:	34e080e7          	jalr	846(ra) # 57c4 <exit>

000000000000247e <rwsbrk>:
{
    247e:	1101                	addi	sp,sp,-32
    2480:	ec06                	sd	ra,24(sp)
    2482:	e822                	sd	s0,16(sp)
    2484:	e426                	sd	s1,8(sp)
    2486:	e04a                	sd	s2,0(sp)
    2488:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    248a:	6509                	lui	a0,0x2
    248c:	00003097          	auipc	ra,0x3
    2490:	3c0080e7          	jalr	960(ra) # 584c <sbrk>
  if(a == 0xffffffffffffffffLL) {
    2494:	57fd                	li	a5,-1
    2496:	06f50363          	beq	a0,a5,24fc <rwsbrk+0x7e>
    249a:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    249c:	7579                	lui	a0,0xffffe
    249e:	00003097          	auipc	ra,0x3
    24a2:	3ae080e7          	jalr	942(ra) # 584c <sbrk>
    24a6:	57fd                	li	a5,-1
    24a8:	06f50763          	beq	a0,a5,2516 <rwsbrk+0x98>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    24ac:	20100593          	li	a1,513
    24b0:	00004517          	auipc	a0,0x4
    24b4:	8b850513          	addi	a0,a0,-1864 # 5d68 <malloc+0x16e>
    24b8:	00003097          	auipc	ra,0x3
    24bc:	34c080e7          	jalr	844(ra) # 5804 <open>
    24c0:	892a                	mv	s2,a0
  if(fd < 0){
    24c2:	06054763          	bltz	a0,2530 <rwsbrk+0xb2>
  n = write(fd, (void*)(a+4096), 1024);
    24c6:	6505                	lui	a0,0x1
    24c8:	94aa                	add	s1,s1,a0
    24ca:	40000613          	li	a2,1024
    24ce:	85a6                	mv	a1,s1
    24d0:	854a                	mv	a0,s2
    24d2:	00003097          	auipc	ra,0x3
    24d6:	312080e7          	jalr	786(ra) # 57e4 <write>
    24da:	862a                	mv	a2,a0
  if(n >= 0){
    24dc:	06054763          	bltz	a0,254a <rwsbrk+0xcc>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    24e0:	85a6                	mv	a1,s1
    24e2:	00005517          	auipc	a0,0x5
    24e6:	88e50513          	addi	a0,a0,-1906 # 6d70 <malloc+0x1176>
    24ea:	00003097          	auipc	ra,0x3
    24ee:	652080e7          	jalr	1618(ra) # 5b3c <printf>
    exit(1);
    24f2:	4505                	li	a0,1
    24f4:	00003097          	auipc	ra,0x3
    24f8:	2d0080e7          	jalr	720(ra) # 57c4 <exit>
    printf("sbrk(rwsbrk) failed\n");
    24fc:	00005517          	auipc	a0,0x5
    2500:	82450513          	addi	a0,a0,-2012 # 6d20 <malloc+0x1126>
    2504:	00003097          	auipc	ra,0x3
    2508:	638080e7          	jalr	1592(ra) # 5b3c <printf>
    exit(1);
    250c:	4505                	li	a0,1
    250e:	00003097          	auipc	ra,0x3
    2512:	2b6080e7          	jalr	694(ra) # 57c4 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    2516:	00005517          	auipc	a0,0x5
    251a:	82250513          	addi	a0,a0,-2014 # 6d38 <malloc+0x113e>
    251e:	00003097          	auipc	ra,0x3
    2522:	61e080e7          	jalr	1566(ra) # 5b3c <printf>
    exit(1);
    2526:	4505                	li	a0,1
    2528:	00003097          	auipc	ra,0x3
    252c:	29c080e7          	jalr	668(ra) # 57c4 <exit>
    printf("open(rwsbrk) failed\n");
    2530:	00005517          	auipc	a0,0x5
    2534:	82850513          	addi	a0,a0,-2008 # 6d58 <malloc+0x115e>
    2538:	00003097          	auipc	ra,0x3
    253c:	604080e7          	jalr	1540(ra) # 5b3c <printf>
    exit(1);
    2540:	4505                	li	a0,1
    2542:	00003097          	auipc	ra,0x3
    2546:	282080e7          	jalr	642(ra) # 57c4 <exit>
  close(fd);
    254a:	854a                	mv	a0,s2
    254c:	00003097          	auipc	ra,0x3
    2550:	2a0080e7          	jalr	672(ra) # 57ec <close>
  unlink("rwsbrk");
    2554:	00004517          	auipc	a0,0x4
    2558:	81450513          	addi	a0,a0,-2028 # 5d68 <malloc+0x16e>
    255c:	00003097          	auipc	ra,0x3
    2560:	2b8080e7          	jalr	696(ra) # 5814 <unlink>
  fd = open("README", O_RDONLY);
    2564:	4581                	li	a1,0
    2566:	00004517          	auipc	a0,0x4
    256a:	cb250513          	addi	a0,a0,-846 # 6218 <malloc+0x61e>
    256e:	00003097          	auipc	ra,0x3
    2572:	296080e7          	jalr	662(ra) # 5804 <open>
    2576:	892a                	mv	s2,a0
  if(fd < 0){
    2578:	02054963          	bltz	a0,25aa <rwsbrk+0x12c>
  n = read(fd, (void*)(a+4096), 10);
    257c:	4629                	li	a2,10
    257e:	85a6                	mv	a1,s1
    2580:	00003097          	auipc	ra,0x3
    2584:	25c080e7          	jalr	604(ra) # 57dc <read>
    2588:	862a                	mv	a2,a0
  if(n >= 0){
    258a:	02054d63          	bltz	a0,25c4 <rwsbrk+0x146>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    258e:	85a6                	mv	a1,s1
    2590:	00005517          	auipc	a0,0x5
    2594:	81050513          	addi	a0,a0,-2032 # 6da0 <malloc+0x11a6>
    2598:	00003097          	auipc	ra,0x3
    259c:	5a4080e7          	jalr	1444(ra) # 5b3c <printf>
    exit(1);
    25a0:	4505                	li	a0,1
    25a2:	00003097          	auipc	ra,0x3
    25a6:	222080e7          	jalr	546(ra) # 57c4 <exit>
    printf("open(rwsbrk) failed\n");
    25aa:	00004517          	auipc	a0,0x4
    25ae:	7ae50513          	addi	a0,a0,1966 # 6d58 <malloc+0x115e>
    25b2:	00003097          	auipc	ra,0x3
    25b6:	58a080e7          	jalr	1418(ra) # 5b3c <printf>
    exit(1);
    25ba:	4505                	li	a0,1
    25bc:	00003097          	auipc	ra,0x3
    25c0:	208080e7          	jalr	520(ra) # 57c4 <exit>
  close(fd);
    25c4:	854a                	mv	a0,s2
    25c6:	00003097          	auipc	ra,0x3
    25ca:	226080e7          	jalr	550(ra) # 57ec <close>
  exit(0);
    25ce:	4501                	li	a0,0
    25d0:	00003097          	auipc	ra,0x3
    25d4:	1f4080e7          	jalr	500(ra) # 57c4 <exit>

00000000000025d8 <sbrkbasic>:
{
    25d8:	715d                	addi	sp,sp,-80
    25da:	e486                	sd	ra,72(sp)
    25dc:	e0a2                	sd	s0,64(sp)
    25de:	fc26                	sd	s1,56(sp)
    25e0:	f84a                	sd	s2,48(sp)
    25e2:	f44e                	sd	s3,40(sp)
    25e4:	f052                	sd	s4,32(sp)
    25e6:	ec56                	sd	s5,24(sp)
    25e8:	0880                	addi	s0,sp,80
    25ea:	8a2a                	mv	s4,a0
  pid = fork();
    25ec:	00003097          	auipc	ra,0x3
    25f0:	1d0080e7          	jalr	464(ra) # 57bc <fork>
  if(pid < 0){
    25f4:	02054c63          	bltz	a0,262c <sbrkbasic+0x54>
  if(pid == 0){
    25f8:	ed21                	bnez	a0,2650 <sbrkbasic+0x78>
    a = sbrk(TOOMUCH);
    25fa:	40000537          	lui	a0,0x40000
    25fe:	00003097          	auipc	ra,0x3
    2602:	24e080e7          	jalr	590(ra) # 584c <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    2606:	57fd                	li	a5,-1
    2608:	02f50f63          	beq	a0,a5,2646 <sbrkbasic+0x6e>
    for(b = a; b < a+TOOMUCH; b += 4096){
    260c:	400007b7          	lui	a5,0x40000
    2610:	97aa                	add	a5,a5,a0
      *b = 99;
    2612:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    2616:	6705                	lui	a4,0x1
      *b = 99;
    2618:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3fff1300>
    for(b = a; b < a+TOOMUCH; b += 4096){
    261c:	953a                	add	a0,a0,a4
    261e:	fef51de3          	bne	a0,a5,2618 <sbrkbasic+0x40>
    exit(1);
    2622:	4505                	li	a0,1
    2624:	00003097          	auipc	ra,0x3
    2628:	1a0080e7          	jalr	416(ra) # 57c4 <exit>
    printf("fork failed in sbrkbasic\n");
    262c:	00004517          	auipc	a0,0x4
    2630:	79c50513          	addi	a0,a0,1948 # 6dc8 <malloc+0x11ce>
    2634:	00003097          	auipc	ra,0x3
    2638:	508080e7          	jalr	1288(ra) # 5b3c <printf>
    exit(1);
    263c:	4505                	li	a0,1
    263e:	00003097          	auipc	ra,0x3
    2642:	186080e7          	jalr	390(ra) # 57c4 <exit>
      exit(0);
    2646:	4501                	li	a0,0
    2648:	00003097          	auipc	ra,0x3
    264c:	17c080e7          	jalr	380(ra) # 57c4 <exit>
  wait(&xstatus);
    2650:	fbc40513          	addi	a0,s0,-68
    2654:	00003097          	auipc	ra,0x3
    2658:	178080e7          	jalr	376(ra) # 57cc <wait>
  if(xstatus == 1){
    265c:	fbc42703          	lw	a4,-68(s0)
    2660:	4785                	li	a5,1
    2662:	00f70e63          	beq	a4,a5,267e <sbrkbasic+0xa6>
  a = sbrk(0);
    2666:	4501                	li	a0,0
    2668:	00003097          	auipc	ra,0x3
    266c:	1e4080e7          	jalr	484(ra) # 584c <sbrk>
    2670:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2672:	4901                	li	s2,0
    *b = 1;
    2674:	4a85                	li	s5,1
  for(i = 0; i < 5000; i++){
    2676:	6985                	lui	s3,0x1
    2678:	38898993          	addi	s3,s3,904 # 1388 <copyinstr2+0x1b6>
    267c:	a005                	j	269c <sbrkbasic+0xc4>
    printf("%s: too much memory allocated!\n", s);
    267e:	85d2                	mv	a1,s4
    2680:	00004517          	auipc	a0,0x4
    2684:	76850513          	addi	a0,a0,1896 # 6de8 <malloc+0x11ee>
    2688:	00003097          	auipc	ra,0x3
    268c:	4b4080e7          	jalr	1204(ra) # 5b3c <printf>
    exit(1);
    2690:	4505                	li	a0,1
    2692:	00003097          	auipc	ra,0x3
    2696:	132080e7          	jalr	306(ra) # 57c4 <exit>
    a = b + 1;
    269a:	84be                	mv	s1,a5
    b = sbrk(1);
    269c:	4505                	li	a0,1
    269e:	00003097          	auipc	ra,0x3
    26a2:	1ae080e7          	jalr	430(ra) # 584c <sbrk>
    if(b != a){
    26a6:	04951b63          	bne	a0,s1,26fc <sbrkbasic+0x124>
    *b = 1;
    26aa:	01548023          	sb	s5,0(s1)
    a = b + 1;
    26ae:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    26b2:	2905                	addiw	s2,s2,1
    26b4:	ff3913e3          	bne	s2,s3,269a <sbrkbasic+0xc2>
  pid = fork();
    26b8:	00003097          	auipc	ra,0x3
    26bc:	104080e7          	jalr	260(ra) # 57bc <fork>
    26c0:	892a                	mv	s2,a0
  if(pid < 0){
    26c2:	04054e63          	bltz	a0,271e <sbrkbasic+0x146>
  c = sbrk(1);
    26c6:	4505                	li	a0,1
    26c8:	00003097          	auipc	ra,0x3
    26cc:	184080e7          	jalr	388(ra) # 584c <sbrk>
  c = sbrk(1);
    26d0:	4505                	li	a0,1
    26d2:	00003097          	auipc	ra,0x3
    26d6:	17a080e7          	jalr	378(ra) # 584c <sbrk>
  if(c != a + 1){
    26da:	0489                	addi	s1,s1,2
    26dc:	04a48f63          	beq	s1,a0,273a <sbrkbasic+0x162>
    printf("%s: sbrk test failed post-fork\n", s);
    26e0:	85d2                	mv	a1,s4
    26e2:	00004517          	auipc	a0,0x4
    26e6:	76650513          	addi	a0,a0,1894 # 6e48 <malloc+0x124e>
    26ea:	00003097          	auipc	ra,0x3
    26ee:	452080e7          	jalr	1106(ra) # 5b3c <printf>
    exit(1);
    26f2:	4505                	li	a0,1
    26f4:	00003097          	auipc	ra,0x3
    26f8:	0d0080e7          	jalr	208(ra) # 57c4 <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    26fc:	872a                	mv	a4,a0
    26fe:	86a6                	mv	a3,s1
    2700:	864a                	mv	a2,s2
    2702:	85d2                	mv	a1,s4
    2704:	00004517          	auipc	a0,0x4
    2708:	70450513          	addi	a0,a0,1796 # 6e08 <malloc+0x120e>
    270c:	00003097          	auipc	ra,0x3
    2710:	430080e7          	jalr	1072(ra) # 5b3c <printf>
      exit(1);
    2714:	4505                	li	a0,1
    2716:	00003097          	auipc	ra,0x3
    271a:	0ae080e7          	jalr	174(ra) # 57c4 <exit>
    printf("%s: sbrk test fork failed\n", s);
    271e:	85d2                	mv	a1,s4
    2720:	00004517          	auipc	a0,0x4
    2724:	70850513          	addi	a0,a0,1800 # 6e28 <malloc+0x122e>
    2728:	00003097          	auipc	ra,0x3
    272c:	414080e7          	jalr	1044(ra) # 5b3c <printf>
    exit(1);
    2730:	4505                	li	a0,1
    2732:	00003097          	auipc	ra,0x3
    2736:	092080e7          	jalr	146(ra) # 57c4 <exit>
  if(pid == 0)
    273a:	00091763          	bnez	s2,2748 <sbrkbasic+0x170>
    exit(0);
    273e:	4501                	li	a0,0
    2740:	00003097          	auipc	ra,0x3
    2744:	084080e7          	jalr	132(ra) # 57c4 <exit>
  wait(&xstatus);
    2748:	fbc40513          	addi	a0,s0,-68
    274c:	00003097          	auipc	ra,0x3
    2750:	080080e7          	jalr	128(ra) # 57cc <wait>
  exit(xstatus);
    2754:	fbc42503          	lw	a0,-68(s0)
    2758:	00003097          	auipc	ra,0x3
    275c:	06c080e7          	jalr	108(ra) # 57c4 <exit>

0000000000002760 <sbrkmuch>:
{
    2760:	7179                	addi	sp,sp,-48
    2762:	f406                	sd	ra,40(sp)
    2764:	f022                	sd	s0,32(sp)
    2766:	ec26                	sd	s1,24(sp)
    2768:	e84a                	sd	s2,16(sp)
    276a:	e44e                	sd	s3,8(sp)
    276c:	e052                	sd	s4,0(sp)
    276e:	1800                	addi	s0,sp,48
    2770:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2772:	4501                	li	a0,0
    2774:	00003097          	auipc	ra,0x3
    2778:	0d8080e7          	jalr	216(ra) # 584c <sbrk>
    277c:	892a                	mv	s2,a0
  a = sbrk(0);
    277e:	4501                	li	a0,0
    2780:	00003097          	auipc	ra,0x3
    2784:	0cc080e7          	jalr	204(ra) # 584c <sbrk>
    2788:	84aa                	mv	s1,a0
  p = sbrk(amt);
    278a:	06400537          	lui	a0,0x6400
    278e:	9d05                	subw	a0,a0,s1
    2790:	00003097          	auipc	ra,0x3
    2794:	0bc080e7          	jalr	188(ra) # 584c <sbrk>
  if (p != a) {
    2798:	0ca49863          	bne	s1,a0,2868 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    279c:	4501                	li	a0,0
    279e:	00003097          	auipc	ra,0x3
    27a2:	0ae080e7          	jalr	174(ra) # 584c <sbrk>
    27a6:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    27a8:	00a4f963          	bgeu	s1,a0,27ba <sbrkmuch+0x5a>
    *pp = 1;
    27ac:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    27ae:	6705                	lui	a4,0x1
    *pp = 1;
    27b0:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    27b4:	94ba                	add	s1,s1,a4
    27b6:	fef4ede3          	bltu	s1,a5,27b0 <sbrkmuch+0x50>
  *lastaddr = 99;
    27ba:	064007b7          	lui	a5,0x6400
    27be:	06300713          	li	a4,99
    27c2:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f12ff>
  a = sbrk(0);
    27c6:	4501                	li	a0,0
    27c8:	00003097          	auipc	ra,0x3
    27cc:	084080e7          	jalr	132(ra) # 584c <sbrk>
    27d0:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    27d2:	757d                	lui	a0,0xfffff
    27d4:	00003097          	auipc	ra,0x3
    27d8:	078080e7          	jalr	120(ra) # 584c <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    27dc:	57fd                	li	a5,-1
    27de:	0af50363          	beq	a0,a5,2884 <sbrkmuch+0x124>
  c = sbrk(0);
    27e2:	4501                	li	a0,0
    27e4:	00003097          	auipc	ra,0x3
    27e8:	068080e7          	jalr	104(ra) # 584c <sbrk>
  if(c != a - PGSIZE){
    27ec:	77fd                	lui	a5,0xfffff
    27ee:	97a6                	add	a5,a5,s1
    27f0:	0af51863          	bne	a0,a5,28a0 <sbrkmuch+0x140>
  a = sbrk(0);
    27f4:	4501                	li	a0,0
    27f6:	00003097          	auipc	ra,0x3
    27fa:	056080e7          	jalr	86(ra) # 584c <sbrk>
    27fe:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2800:	6505                	lui	a0,0x1
    2802:	00003097          	auipc	ra,0x3
    2806:	04a080e7          	jalr	74(ra) # 584c <sbrk>
    280a:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    280c:	0aa49a63          	bne	s1,a0,28c0 <sbrkmuch+0x160>
    2810:	4501                	li	a0,0
    2812:	00003097          	auipc	ra,0x3
    2816:	03a080e7          	jalr	58(ra) # 584c <sbrk>
    281a:	6785                	lui	a5,0x1
    281c:	97a6                	add	a5,a5,s1
    281e:	0af51163          	bne	a0,a5,28c0 <sbrkmuch+0x160>
  if(*lastaddr == 99){
    2822:	064007b7          	lui	a5,0x6400
    2826:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f12ff>
    282a:	06300793          	li	a5,99
    282e:	0af70963          	beq	a4,a5,28e0 <sbrkmuch+0x180>
  a = sbrk(0);
    2832:	4501                	li	a0,0
    2834:	00003097          	auipc	ra,0x3
    2838:	018080e7          	jalr	24(ra) # 584c <sbrk>
    283c:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    283e:	4501                	li	a0,0
    2840:	00003097          	auipc	ra,0x3
    2844:	00c080e7          	jalr	12(ra) # 584c <sbrk>
    2848:	40a9053b          	subw	a0,s2,a0
    284c:	00003097          	auipc	ra,0x3
    2850:	000080e7          	jalr	ra # 584c <sbrk>
  if(c != a){
    2854:	0aa49463          	bne	s1,a0,28fc <sbrkmuch+0x19c>
}
    2858:	70a2                	ld	ra,40(sp)
    285a:	7402                	ld	s0,32(sp)
    285c:	64e2                	ld	s1,24(sp)
    285e:	6942                	ld	s2,16(sp)
    2860:	69a2                	ld	s3,8(sp)
    2862:	6a02                	ld	s4,0(sp)
    2864:	6145                	addi	sp,sp,48
    2866:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2868:	85ce                	mv	a1,s3
    286a:	00004517          	auipc	a0,0x4
    286e:	5fe50513          	addi	a0,a0,1534 # 6e68 <malloc+0x126e>
    2872:	00003097          	auipc	ra,0x3
    2876:	2ca080e7          	jalr	714(ra) # 5b3c <printf>
    exit(1);
    287a:	4505                	li	a0,1
    287c:	00003097          	auipc	ra,0x3
    2880:	f48080e7          	jalr	-184(ra) # 57c4 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2884:	85ce                	mv	a1,s3
    2886:	00004517          	auipc	a0,0x4
    288a:	62a50513          	addi	a0,a0,1578 # 6eb0 <malloc+0x12b6>
    288e:	00003097          	auipc	ra,0x3
    2892:	2ae080e7          	jalr	686(ra) # 5b3c <printf>
    exit(1);
    2896:	4505                	li	a0,1
    2898:	00003097          	auipc	ra,0x3
    289c:	f2c080e7          	jalr	-212(ra) # 57c4 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    28a0:	86aa                	mv	a3,a0
    28a2:	8626                	mv	a2,s1
    28a4:	85ce                	mv	a1,s3
    28a6:	00004517          	auipc	a0,0x4
    28aa:	62a50513          	addi	a0,a0,1578 # 6ed0 <malloc+0x12d6>
    28ae:	00003097          	auipc	ra,0x3
    28b2:	28e080e7          	jalr	654(ra) # 5b3c <printf>
    exit(1);
    28b6:	4505                	li	a0,1
    28b8:	00003097          	auipc	ra,0x3
    28bc:	f0c080e7          	jalr	-244(ra) # 57c4 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    28c0:	86d2                	mv	a3,s4
    28c2:	8626                	mv	a2,s1
    28c4:	85ce                	mv	a1,s3
    28c6:	00004517          	auipc	a0,0x4
    28ca:	64a50513          	addi	a0,a0,1610 # 6f10 <malloc+0x1316>
    28ce:	00003097          	auipc	ra,0x3
    28d2:	26e080e7          	jalr	622(ra) # 5b3c <printf>
    exit(1);
    28d6:	4505                	li	a0,1
    28d8:	00003097          	auipc	ra,0x3
    28dc:	eec080e7          	jalr	-276(ra) # 57c4 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    28e0:	85ce                	mv	a1,s3
    28e2:	00004517          	auipc	a0,0x4
    28e6:	65e50513          	addi	a0,a0,1630 # 6f40 <malloc+0x1346>
    28ea:	00003097          	auipc	ra,0x3
    28ee:	252080e7          	jalr	594(ra) # 5b3c <printf>
    exit(1);
    28f2:	4505                	li	a0,1
    28f4:	00003097          	auipc	ra,0x3
    28f8:	ed0080e7          	jalr	-304(ra) # 57c4 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    28fc:	86aa                	mv	a3,a0
    28fe:	8626                	mv	a2,s1
    2900:	85ce                	mv	a1,s3
    2902:	00004517          	auipc	a0,0x4
    2906:	67650513          	addi	a0,a0,1654 # 6f78 <malloc+0x137e>
    290a:	00003097          	auipc	ra,0x3
    290e:	232080e7          	jalr	562(ra) # 5b3c <printf>
    exit(1);
    2912:	4505                	li	a0,1
    2914:	00003097          	auipc	ra,0x3
    2918:	eb0080e7          	jalr	-336(ra) # 57c4 <exit>

000000000000291c <sbrkarg>:
{
    291c:	7179                	addi	sp,sp,-48
    291e:	f406                	sd	ra,40(sp)
    2920:	f022                	sd	s0,32(sp)
    2922:	ec26                	sd	s1,24(sp)
    2924:	e84a                	sd	s2,16(sp)
    2926:	e44e                	sd	s3,8(sp)
    2928:	1800                	addi	s0,sp,48
    292a:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    292c:	6505                	lui	a0,0x1
    292e:	00003097          	auipc	ra,0x3
    2932:	f1e080e7          	jalr	-226(ra) # 584c <sbrk>
    2936:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2938:	20100593          	li	a1,513
    293c:	00004517          	auipc	a0,0x4
    2940:	66450513          	addi	a0,a0,1636 # 6fa0 <malloc+0x13a6>
    2944:	00003097          	auipc	ra,0x3
    2948:	ec0080e7          	jalr	-320(ra) # 5804 <open>
    294c:	84aa                	mv	s1,a0
  unlink("sbrk");
    294e:	00004517          	auipc	a0,0x4
    2952:	65250513          	addi	a0,a0,1618 # 6fa0 <malloc+0x13a6>
    2956:	00003097          	auipc	ra,0x3
    295a:	ebe080e7          	jalr	-322(ra) # 5814 <unlink>
  if(fd < 0)  {
    295e:	0404c163          	bltz	s1,29a0 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2962:	6605                	lui	a2,0x1
    2964:	85ca                	mv	a1,s2
    2966:	8526                	mv	a0,s1
    2968:	00003097          	auipc	ra,0x3
    296c:	e7c080e7          	jalr	-388(ra) # 57e4 <write>
    2970:	04054663          	bltz	a0,29bc <sbrkarg+0xa0>
  close(fd);
    2974:	8526                	mv	a0,s1
    2976:	00003097          	auipc	ra,0x3
    297a:	e76080e7          	jalr	-394(ra) # 57ec <close>
  a = sbrk(PGSIZE);
    297e:	6505                	lui	a0,0x1
    2980:	00003097          	auipc	ra,0x3
    2984:	ecc080e7          	jalr	-308(ra) # 584c <sbrk>
  if(pipe((int *) a) != 0){
    2988:	00003097          	auipc	ra,0x3
    298c:	e4c080e7          	jalr	-436(ra) # 57d4 <pipe>
    2990:	e521                	bnez	a0,29d8 <sbrkarg+0xbc>
}
    2992:	70a2                	ld	ra,40(sp)
    2994:	7402                	ld	s0,32(sp)
    2996:	64e2                	ld	s1,24(sp)
    2998:	6942                	ld	s2,16(sp)
    299a:	69a2                	ld	s3,8(sp)
    299c:	6145                	addi	sp,sp,48
    299e:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    29a0:	85ce                	mv	a1,s3
    29a2:	00004517          	auipc	a0,0x4
    29a6:	60650513          	addi	a0,a0,1542 # 6fa8 <malloc+0x13ae>
    29aa:	00003097          	auipc	ra,0x3
    29ae:	192080e7          	jalr	402(ra) # 5b3c <printf>
    exit(1);
    29b2:	4505                	li	a0,1
    29b4:	00003097          	auipc	ra,0x3
    29b8:	e10080e7          	jalr	-496(ra) # 57c4 <exit>
    printf("%s: write sbrk failed\n", s);
    29bc:	85ce                	mv	a1,s3
    29be:	00004517          	auipc	a0,0x4
    29c2:	60250513          	addi	a0,a0,1538 # 6fc0 <malloc+0x13c6>
    29c6:	00003097          	auipc	ra,0x3
    29ca:	176080e7          	jalr	374(ra) # 5b3c <printf>
    exit(1);
    29ce:	4505                	li	a0,1
    29d0:	00003097          	auipc	ra,0x3
    29d4:	df4080e7          	jalr	-524(ra) # 57c4 <exit>
    printf("%s: pipe() failed\n", s);
    29d8:	85ce                	mv	a1,s3
    29da:	00004517          	auipc	a0,0x4
    29de:	fe650513          	addi	a0,a0,-26 # 69c0 <malloc+0xdc6>
    29e2:	00003097          	auipc	ra,0x3
    29e6:	15a080e7          	jalr	346(ra) # 5b3c <printf>
    exit(1);
    29ea:	4505                	li	a0,1
    29ec:	00003097          	auipc	ra,0x3
    29f0:	dd8080e7          	jalr	-552(ra) # 57c4 <exit>

00000000000029f4 <argptest>:
{
    29f4:	1101                	addi	sp,sp,-32
    29f6:	ec06                	sd	ra,24(sp)
    29f8:	e822                	sd	s0,16(sp)
    29fa:	e426                	sd	s1,8(sp)
    29fc:	e04a                	sd	s2,0(sp)
    29fe:	1000                	addi	s0,sp,32
    2a00:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2a02:	4581                	li	a1,0
    2a04:	00004517          	auipc	a0,0x4
    2a08:	5d450513          	addi	a0,a0,1492 # 6fd8 <malloc+0x13de>
    2a0c:	00003097          	auipc	ra,0x3
    2a10:	df8080e7          	jalr	-520(ra) # 5804 <open>
  if (fd < 0) {
    2a14:	02054b63          	bltz	a0,2a4a <argptest+0x56>
    2a18:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2a1a:	4501                	li	a0,0
    2a1c:	00003097          	auipc	ra,0x3
    2a20:	e30080e7          	jalr	-464(ra) # 584c <sbrk>
    2a24:	567d                	li	a2,-1
    2a26:	fff50593          	addi	a1,a0,-1
    2a2a:	8526                	mv	a0,s1
    2a2c:	00003097          	auipc	ra,0x3
    2a30:	db0080e7          	jalr	-592(ra) # 57dc <read>
  close(fd);
    2a34:	8526                	mv	a0,s1
    2a36:	00003097          	auipc	ra,0x3
    2a3a:	db6080e7          	jalr	-586(ra) # 57ec <close>
}
    2a3e:	60e2                	ld	ra,24(sp)
    2a40:	6442                	ld	s0,16(sp)
    2a42:	64a2                	ld	s1,8(sp)
    2a44:	6902                	ld	s2,0(sp)
    2a46:	6105                	addi	sp,sp,32
    2a48:	8082                	ret
    printf("%s: open failed\n", s);
    2a4a:	85ca                	mv	a1,s2
    2a4c:	00004517          	auipc	a0,0x4
    2a50:	e8450513          	addi	a0,a0,-380 # 68d0 <malloc+0xcd6>
    2a54:	00003097          	auipc	ra,0x3
    2a58:	0e8080e7          	jalr	232(ra) # 5b3c <printf>
    exit(1);
    2a5c:	4505                	li	a0,1
    2a5e:	00003097          	auipc	ra,0x3
    2a62:	d66080e7          	jalr	-666(ra) # 57c4 <exit>

0000000000002a66 <sbrkbugs>:
{
    2a66:	1141                	addi	sp,sp,-16
    2a68:	e406                	sd	ra,8(sp)
    2a6a:	e022                	sd	s0,0(sp)
    2a6c:	0800                	addi	s0,sp,16
  int pid = fork();
    2a6e:	00003097          	auipc	ra,0x3
    2a72:	d4e080e7          	jalr	-690(ra) # 57bc <fork>
  if(pid < 0){
    2a76:	02054263          	bltz	a0,2a9a <sbrkbugs+0x34>
  if(pid == 0){
    2a7a:	ed0d                	bnez	a0,2ab4 <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2a7c:	00003097          	auipc	ra,0x3
    2a80:	dd0080e7          	jalr	-560(ra) # 584c <sbrk>
    sbrk(-sz);
    2a84:	40a0053b          	negw	a0,a0
    2a88:	00003097          	auipc	ra,0x3
    2a8c:	dc4080e7          	jalr	-572(ra) # 584c <sbrk>
    exit(0);
    2a90:	4501                	li	a0,0
    2a92:	00003097          	auipc	ra,0x3
    2a96:	d32080e7          	jalr	-718(ra) # 57c4 <exit>
    printf("fork failed\n");
    2a9a:	00004517          	auipc	a0,0x4
    2a9e:	22650513          	addi	a0,a0,550 # 6cc0 <malloc+0x10c6>
    2aa2:	00003097          	auipc	ra,0x3
    2aa6:	09a080e7          	jalr	154(ra) # 5b3c <printf>
    exit(1);
    2aaa:	4505                	li	a0,1
    2aac:	00003097          	auipc	ra,0x3
    2ab0:	d18080e7          	jalr	-744(ra) # 57c4 <exit>
  wait(0);
    2ab4:	4501                	li	a0,0
    2ab6:	00003097          	auipc	ra,0x3
    2aba:	d16080e7          	jalr	-746(ra) # 57cc <wait>
  pid = fork();
    2abe:	00003097          	auipc	ra,0x3
    2ac2:	cfe080e7          	jalr	-770(ra) # 57bc <fork>
  if(pid < 0){
    2ac6:	02054563          	bltz	a0,2af0 <sbrkbugs+0x8a>
  if(pid == 0){
    2aca:	e121                	bnez	a0,2b0a <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2acc:	00003097          	auipc	ra,0x3
    2ad0:	d80080e7          	jalr	-640(ra) # 584c <sbrk>
    sbrk(-(sz - 3500));
    2ad4:	6785                	lui	a5,0x1
    2ad6:	dac7879b          	addiw	a5,a5,-596
    2ada:	40a7853b          	subw	a0,a5,a0
    2ade:	00003097          	auipc	ra,0x3
    2ae2:	d6e080e7          	jalr	-658(ra) # 584c <sbrk>
    exit(0);
    2ae6:	4501                	li	a0,0
    2ae8:	00003097          	auipc	ra,0x3
    2aec:	cdc080e7          	jalr	-804(ra) # 57c4 <exit>
    printf("fork failed\n");
    2af0:	00004517          	auipc	a0,0x4
    2af4:	1d050513          	addi	a0,a0,464 # 6cc0 <malloc+0x10c6>
    2af8:	00003097          	auipc	ra,0x3
    2afc:	044080e7          	jalr	68(ra) # 5b3c <printf>
    exit(1);
    2b00:	4505                	li	a0,1
    2b02:	00003097          	auipc	ra,0x3
    2b06:	cc2080e7          	jalr	-830(ra) # 57c4 <exit>
  wait(0);
    2b0a:	4501                	li	a0,0
    2b0c:	00003097          	auipc	ra,0x3
    2b10:	cc0080e7          	jalr	-832(ra) # 57cc <wait>
  pid = fork();
    2b14:	00003097          	auipc	ra,0x3
    2b18:	ca8080e7          	jalr	-856(ra) # 57bc <fork>
  if(pid < 0){
    2b1c:	02054a63          	bltz	a0,2b50 <sbrkbugs+0xea>
  if(pid == 0){
    2b20:	e529                	bnez	a0,2b6a <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2b22:	00003097          	auipc	ra,0x3
    2b26:	d2a080e7          	jalr	-726(ra) # 584c <sbrk>
    2b2a:	67ad                	lui	a5,0xb
    2b2c:	8007879b          	addiw	a5,a5,-2048
    2b30:	40a7853b          	subw	a0,a5,a0
    2b34:	00003097          	auipc	ra,0x3
    2b38:	d18080e7          	jalr	-744(ra) # 584c <sbrk>
    sbrk(-10);
    2b3c:	5559                	li	a0,-10
    2b3e:	00003097          	auipc	ra,0x3
    2b42:	d0e080e7          	jalr	-754(ra) # 584c <sbrk>
    exit(0);
    2b46:	4501                	li	a0,0
    2b48:	00003097          	auipc	ra,0x3
    2b4c:	c7c080e7          	jalr	-900(ra) # 57c4 <exit>
    printf("fork failed\n");
    2b50:	00004517          	auipc	a0,0x4
    2b54:	17050513          	addi	a0,a0,368 # 6cc0 <malloc+0x10c6>
    2b58:	00003097          	auipc	ra,0x3
    2b5c:	fe4080e7          	jalr	-28(ra) # 5b3c <printf>
    exit(1);
    2b60:	4505                	li	a0,1
    2b62:	00003097          	auipc	ra,0x3
    2b66:	c62080e7          	jalr	-926(ra) # 57c4 <exit>
  wait(0);
    2b6a:	4501                	li	a0,0
    2b6c:	00003097          	auipc	ra,0x3
    2b70:	c60080e7          	jalr	-928(ra) # 57cc <wait>
  exit(0);
    2b74:	4501                	li	a0,0
    2b76:	00003097          	auipc	ra,0x3
    2b7a:	c4e080e7          	jalr	-946(ra) # 57c4 <exit>

0000000000002b7e <sbrklast>:
{
    2b7e:	7179                	addi	sp,sp,-48
    2b80:	f406                	sd	ra,40(sp)
    2b82:	f022                	sd	s0,32(sp)
    2b84:	ec26                	sd	s1,24(sp)
    2b86:	e84a                	sd	s2,16(sp)
    2b88:	e44e                	sd	s3,8(sp)
    2b8a:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2b8c:	4501                	li	a0,0
    2b8e:	00003097          	auipc	ra,0x3
    2b92:	cbe080e7          	jalr	-834(ra) # 584c <sbrk>
  if((top % 4096) != 0)
    2b96:	03451793          	slli	a5,a0,0x34
    2b9a:	efc1                	bnez	a5,2c32 <sbrklast+0xb4>
  sbrk(4096);
    2b9c:	6505                	lui	a0,0x1
    2b9e:	00003097          	auipc	ra,0x3
    2ba2:	cae080e7          	jalr	-850(ra) # 584c <sbrk>
  sbrk(10);
    2ba6:	4529                	li	a0,10
    2ba8:	00003097          	auipc	ra,0x3
    2bac:	ca4080e7          	jalr	-860(ra) # 584c <sbrk>
  sbrk(-20);
    2bb0:	5531                	li	a0,-20
    2bb2:	00003097          	auipc	ra,0x3
    2bb6:	c9a080e7          	jalr	-870(ra) # 584c <sbrk>
  top = (uint64) sbrk(0);
    2bba:	4501                	li	a0,0
    2bbc:	00003097          	auipc	ra,0x3
    2bc0:	c90080e7          	jalr	-880(ra) # 584c <sbrk>
    2bc4:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2bc6:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0x3e>
  p[0] = 'x';
    2bca:	07800793          	li	a5,120
    2bce:	fcf50023          	sb	a5,-64(a0)
  p[1] = '\0';
    2bd2:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2bd6:	20200593          	li	a1,514
    2bda:	854a                	mv	a0,s2
    2bdc:	00003097          	auipc	ra,0x3
    2be0:	c28080e7          	jalr	-984(ra) # 5804 <open>
    2be4:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2be6:	4605                	li	a2,1
    2be8:	85ca                	mv	a1,s2
    2bea:	00003097          	auipc	ra,0x3
    2bee:	bfa080e7          	jalr	-1030(ra) # 57e4 <write>
  close(fd);
    2bf2:	854e                	mv	a0,s3
    2bf4:	00003097          	auipc	ra,0x3
    2bf8:	bf8080e7          	jalr	-1032(ra) # 57ec <close>
  fd = open(p, O_RDWR);
    2bfc:	4589                	li	a1,2
    2bfe:	854a                	mv	a0,s2
    2c00:	00003097          	auipc	ra,0x3
    2c04:	c04080e7          	jalr	-1020(ra) # 5804 <open>
  p[0] = '\0';
    2c08:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2c0c:	4605                	li	a2,1
    2c0e:	85ca                	mv	a1,s2
    2c10:	00003097          	auipc	ra,0x3
    2c14:	bcc080e7          	jalr	-1076(ra) # 57dc <read>
  if(p[0] != 'x')
    2c18:	fc04c703          	lbu	a4,-64(s1)
    2c1c:	07800793          	li	a5,120
    2c20:	02f71363          	bne	a4,a5,2c46 <sbrklast+0xc8>
}
    2c24:	70a2                	ld	ra,40(sp)
    2c26:	7402                	ld	s0,32(sp)
    2c28:	64e2                	ld	s1,24(sp)
    2c2a:	6942                	ld	s2,16(sp)
    2c2c:	69a2                	ld	s3,8(sp)
    2c2e:	6145                	addi	sp,sp,48
    2c30:	8082                	ret
    sbrk(4096 - (top % 4096));
    2c32:	0347d513          	srli	a0,a5,0x34
    2c36:	6785                	lui	a5,0x1
    2c38:	40a7853b          	subw	a0,a5,a0
    2c3c:	00003097          	auipc	ra,0x3
    2c40:	c10080e7          	jalr	-1008(ra) # 584c <sbrk>
    2c44:	bfa1                	j	2b9c <sbrklast+0x1e>
    exit(1);
    2c46:	4505                	li	a0,1
    2c48:	00003097          	auipc	ra,0x3
    2c4c:	b7c080e7          	jalr	-1156(ra) # 57c4 <exit>

0000000000002c50 <sbrk8000>:
{
    2c50:	1141                	addi	sp,sp,-16
    2c52:	e406                	sd	ra,8(sp)
    2c54:	e022                	sd	s0,0(sp)
    2c56:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2c58:	80000537          	lui	a0,0x80000
    2c5c:	0511                	addi	a0,a0,4
    2c5e:	00003097          	auipc	ra,0x3
    2c62:	bee080e7          	jalr	-1042(ra) # 584c <sbrk>
  volatile char *top = sbrk(0);
    2c66:	4501                	li	a0,0
    2c68:	00003097          	auipc	ra,0x3
    2c6c:	be4080e7          	jalr	-1052(ra) # 584c <sbrk>
  *(top-1) = *(top-1) + 1;
    2c70:	fff54783          	lbu	a5,-1(a0) # ffffffff7fffffff <__BSS_END__+0xffffffff7fff12ff>
    2c74:	0785                	addi	a5,a5,1
    2c76:	0ff7f793          	andi	a5,a5,255
    2c7a:	fef50fa3          	sb	a5,-1(a0)
}
    2c7e:	60a2                	ld	ra,8(sp)
    2c80:	6402                	ld	s0,0(sp)
    2c82:	0141                	addi	sp,sp,16
    2c84:	8082                	ret

0000000000002c86 <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    2c86:	715d                	addi	sp,sp,-80
    2c88:	e486                	sd	ra,72(sp)
    2c8a:	e0a2                	sd	s0,64(sp)
    2c8c:	fc26                	sd	s1,56(sp)
    2c8e:	f84a                	sd	s2,48(sp)
    2c90:	f44e                	sd	s3,40(sp)
    2c92:	f052                	sd	s4,32(sp)
    2c94:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2c96:	4901                	li	s2,0
    2c98:	49bd                	li	s3,15
    int pid = fork();
    2c9a:	00003097          	auipc	ra,0x3
    2c9e:	b22080e7          	jalr	-1246(ra) # 57bc <fork>
    2ca2:	84aa                	mv	s1,a0
    if(pid < 0){
    2ca4:	02054063          	bltz	a0,2cc4 <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    2ca8:	c91d                	beqz	a0,2cde <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    2caa:	4501                	li	a0,0
    2cac:	00003097          	auipc	ra,0x3
    2cb0:	b20080e7          	jalr	-1248(ra) # 57cc <wait>
  for(int avail = 0; avail < 15; avail++){
    2cb4:	2905                	addiw	s2,s2,1
    2cb6:	ff3912e3          	bne	s2,s3,2c9a <execout+0x14>
    }
  }

  exit(0);
    2cba:	4501                	li	a0,0
    2cbc:	00003097          	auipc	ra,0x3
    2cc0:	b08080e7          	jalr	-1272(ra) # 57c4 <exit>
      printf("fork failed\n");
    2cc4:	00004517          	auipc	a0,0x4
    2cc8:	ffc50513          	addi	a0,a0,-4 # 6cc0 <malloc+0x10c6>
    2ccc:	00003097          	auipc	ra,0x3
    2cd0:	e70080e7          	jalr	-400(ra) # 5b3c <printf>
      exit(1);
    2cd4:	4505                	li	a0,1
    2cd6:	00003097          	auipc	ra,0x3
    2cda:	aee080e7          	jalr	-1298(ra) # 57c4 <exit>
        if(a == 0xffffffffffffffffLL)
    2cde:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2ce0:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2ce2:	6505                	lui	a0,0x1
    2ce4:	00003097          	auipc	ra,0x3
    2ce8:	b68080e7          	jalr	-1176(ra) # 584c <sbrk>
        if(a == 0xffffffffffffffffLL)
    2cec:	01350763          	beq	a0,s3,2cfa <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2cf0:	6785                	lui	a5,0x1
    2cf2:	953e                	add	a0,a0,a5
    2cf4:	ff450fa3          	sb	s4,-1(a0) # fff <bigdir+0x7d>
      while(1){
    2cf8:	b7ed                	j	2ce2 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2cfa:	01205a63          	blez	s2,2d0e <execout+0x88>
        sbrk(-4096);
    2cfe:	757d                	lui	a0,0xfffff
    2d00:	00003097          	auipc	ra,0x3
    2d04:	b4c080e7          	jalr	-1204(ra) # 584c <sbrk>
      for(int i = 0; i < avail; i++)
    2d08:	2485                	addiw	s1,s1,1
    2d0a:	ff249ae3          	bne	s1,s2,2cfe <execout+0x78>
      close(1);
    2d0e:	4505                	li	a0,1
    2d10:	00003097          	auipc	ra,0x3
    2d14:	adc080e7          	jalr	-1316(ra) # 57ec <close>
      char *args[] = { "echo", "x", 0 };
    2d18:	00003517          	auipc	a0,0x3
    2d1c:	36850513          	addi	a0,a0,872 # 6080 <malloc+0x486>
    2d20:	faa43c23          	sd	a0,-72(s0)
    2d24:	00003797          	auipc	a5,0x3
    2d28:	3cc78793          	addi	a5,a5,972 # 60f0 <malloc+0x4f6>
    2d2c:	fcf43023          	sd	a5,-64(s0)
    2d30:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2d34:	fb840593          	addi	a1,s0,-72
    2d38:	00003097          	auipc	ra,0x3
    2d3c:	ac4080e7          	jalr	-1340(ra) # 57fc <exec>
      exit(0);
    2d40:	4501                	li	a0,0
    2d42:	00003097          	auipc	ra,0x3
    2d46:	a82080e7          	jalr	-1406(ra) # 57c4 <exit>

0000000000002d4a <fourteen>:
{
    2d4a:	1101                	addi	sp,sp,-32
    2d4c:	ec06                	sd	ra,24(sp)
    2d4e:	e822                	sd	s0,16(sp)
    2d50:	e426                	sd	s1,8(sp)
    2d52:	1000                	addi	s0,sp,32
    2d54:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2d56:	00004517          	auipc	a0,0x4
    2d5a:	45a50513          	addi	a0,a0,1114 # 71b0 <malloc+0x15b6>
    2d5e:	00003097          	auipc	ra,0x3
    2d62:	ace080e7          	jalr	-1330(ra) # 582c <mkdir>
    2d66:	e165                	bnez	a0,2e46 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2d68:	00004517          	auipc	a0,0x4
    2d6c:	2a050513          	addi	a0,a0,672 # 7008 <malloc+0x140e>
    2d70:	00003097          	auipc	ra,0x3
    2d74:	abc080e7          	jalr	-1348(ra) # 582c <mkdir>
    2d78:	e56d                	bnez	a0,2e62 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2d7a:	20000593          	li	a1,512
    2d7e:	00004517          	auipc	a0,0x4
    2d82:	2e250513          	addi	a0,a0,738 # 7060 <malloc+0x1466>
    2d86:	00003097          	auipc	ra,0x3
    2d8a:	a7e080e7          	jalr	-1410(ra) # 5804 <open>
  if(fd < 0){
    2d8e:	0e054863          	bltz	a0,2e7e <fourteen+0x134>
  close(fd);
    2d92:	00003097          	auipc	ra,0x3
    2d96:	a5a080e7          	jalr	-1446(ra) # 57ec <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2d9a:	4581                	li	a1,0
    2d9c:	00004517          	auipc	a0,0x4
    2da0:	33c50513          	addi	a0,a0,828 # 70d8 <malloc+0x14de>
    2da4:	00003097          	auipc	ra,0x3
    2da8:	a60080e7          	jalr	-1440(ra) # 5804 <open>
  if(fd < 0){
    2dac:	0e054763          	bltz	a0,2e9a <fourteen+0x150>
  close(fd);
    2db0:	00003097          	auipc	ra,0x3
    2db4:	a3c080e7          	jalr	-1476(ra) # 57ec <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2db8:	00004517          	auipc	a0,0x4
    2dbc:	39050513          	addi	a0,a0,912 # 7148 <malloc+0x154e>
    2dc0:	00003097          	auipc	ra,0x3
    2dc4:	a6c080e7          	jalr	-1428(ra) # 582c <mkdir>
    2dc8:	c57d                	beqz	a0,2eb6 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2dca:	00004517          	auipc	a0,0x4
    2dce:	3d650513          	addi	a0,a0,982 # 71a0 <malloc+0x15a6>
    2dd2:	00003097          	auipc	ra,0x3
    2dd6:	a5a080e7          	jalr	-1446(ra) # 582c <mkdir>
    2dda:	cd65                	beqz	a0,2ed2 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2ddc:	00004517          	auipc	a0,0x4
    2de0:	3c450513          	addi	a0,a0,964 # 71a0 <malloc+0x15a6>
    2de4:	00003097          	auipc	ra,0x3
    2de8:	a30080e7          	jalr	-1488(ra) # 5814 <unlink>
  unlink("12345678901234/12345678901234");
    2dec:	00004517          	auipc	a0,0x4
    2df0:	35c50513          	addi	a0,a0,860 # 7148 <malloc+0x154e>
    2df4:	00003097          	auipc	ra,0x3
    2df8:	a20080e7          	jalr	-1504(ra) # 5814 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2dfc:	00004517          	auipc	a0,0x4
    2e00:	2dc50513          	addi	a0,a0,732 # 70d8 <malloc+0x14de>
    2e04:	00003097          	auipc	ra,0x3
    2e08:	a10080e7          	jalr	-1520(ra) # 5814 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2e0c:	00004517          	auipc	a0,0x4
    2e10:	25450513          	addi	a0,a0,596 # 7060 <malloc+0x1466>
    2e14:	00003097          	auipc	ra,0x3
    2e18:	a00080e7          	jalr	-1536(ra) # 5814 <unlink>
  unlink("12345678901234/123456789012345");
    2e1c:	00004517          	auipc	a0,0x4
    2e20:	1ec50513          	addi	a0,a0,492 # 7008 <malloc+0x140e>
    2e24:	00003097          	auipc	ra,0x3
    2e28:	9f0080e7          	jalr	-1552(ra) # 5814 <unlink>
  unlink("12345678901234");
    2e2c:	00004517          	auipc	a0,0x4
    2e30:	38450513          	addi	a0,a0,900 # 71b0 <malloc+0x15b6>
    2e34:	00003097          	auipc	ra,0x3
    2e38:	9e0080e7          	jalr	-1568(ra) # 5814 <unlink>
}
    2e3c:	60e2                	ld	ra,24(sp)
    2e3e:	6442                	ld	s0,16(sp)
    2e40:	64a2                	ld	s1,8(sp)
    2e42:	6105                	addi	sp,sp,32
    2e44:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2e46:	85a6                	mv	a1,s1
    2e48:	00004517          	auipc	a0,0x4
    2e4c:	19850513          	addi	a0,a0,408 # 6fe0 <malloc+0x13e6>
    2e50:	00003097          	auipc	ra,0x3
    2e54:	cec080e7          	jalr	-788(ra) # 5b3c <printf>
    exit(1);
    2e58:	4505                	li	a0,1
    2e5a:	00003097          	auipc	ra,0x3
    2e5e:	96a080e7          	jalr	-1686(ra) # 57c4 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2e62:	85a6                	mv	a1,s1
    2e64:	00004517          	auipc	a0,0x4
    2e68:	1c450513          	addi	a0,a0,452 # 7028 <malloc+0x142e>
    2e6c:	00003097          	auipc	ra,0x3
    2e70:	cd0080e7          	jalr	-816(ra) # 5b3c <printf>
    exit(1);
    2e74:	4505                	li	a0,1
    2e76:	00003097          	auipc	ra,0x3
    2e7a:	94e080e7          	jalr	-1714(ra) # 57c4 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2e7e:	85a6                	mv	a1,s1
    2e80:	00004517          	auipc	a0,0x4
    2e84:	21050513          	addi	a0,a0,528 # 7090 <malloc+0x1496>
    2e88:	00003097          	auipc	ra,0x3
    2e8c:	cb4080e7          	jalr	-844(ra) # 5b3c <printf>
    exit(1);
    2e90:	4505                	li	a0,1
    2e92:	00003097          	auipc	ra,0x3
    2e96:	932080e7          	jalr	-1742(ra) # 57c4 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2e9a:	85a6                	mv	a1,s1
    2e9c:	00004517          	auipc	a0,0x4
    2ea0:	26c50513          	addi	a0,a0,620 # 7108 <malloc+0x150e>
    2ea4:	00003097          	auipc	ra,0x3
    2ea8:	c98080e7          	jalr	-872(ra) # 5b3c <printf>
    exit(1);
    2eac:	4505                	li	a0,1
    2eae:	00003097          	auipc	ra,0x3
    2eb2:	916080e7          	jalr	-1770(ra) # 57c4 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2eb6:	85a6                	mv	a1,s1
    2eb8:	00004517          	auipc	a0,0x4
    2ebc:	2b050513          	addi	a0,a0,688 # 7168 <malloc+0x156e>
    2ec0:	00003097          	auipc	ra,0x3
    2ec4:	c7c080e7          	jalr	-900(ra) # 5b3c <printf>
    exit(1);
    2ec8:	4505                	li	a0,1
    2eca:	00003097          	auipc	ra,0x3
    2ece:	8fa080e7          	jalr	-1798(ra) # 57c4 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2ed2:	85a6                	mv	a1,s1
    2ed4:	00004517          	auipc	a0,0x4
    2ed8:	2ec50513          	addi	a0,a0,748 # 71c0 <malloc+0x15c6>
    2edc:	00003097          	auipc	ra,0x3
    2ee0:	c60080e7          	jalr	-928(ra) # 5b3c <printf>
    exit(1);
    2ee4:	4505                	li	a0,1
    2ee6:	00003097          	auipc	ra,0x3
    2eea:	8de080e7          	jalr	-1826(ra) # 57c4 <exit>

0000000000002eee <iputtest>:
{
    2eee:	1101                	addi	sp,sp,-32
    2ef0:	ec06                	sd	ra,24(sp)
    2ef2:	e822                	sd	s0,16(sp)
    2ef4:	e426                	sd	s1,8(sp)
    2ef6:	1000                	addi	s0,sp,32
    2ef8:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2efa:	00004517          	auipc	a0,0x4
    2efe:	2fe50513          	addi	a0,a0,766 # 71f8 <malloc+0x15fe>
    2f02:	00003097          	auipc	ra,0x3
    2f06:	92a080e7          	jalr	-1750(ra) # 582c <mkdir>
    2f0a:	04054563          	bltz	a0,2f54 <iputtest+0x66>
  if(chdir("iputdir") < 0){
    2f0e:	00004517          	auipc	a0,0x4
    2f12:	2ea50513          	addi	a0,a0,746 # 71f8 <malloc+0x15fe>
    2f16:	00003097          	auipc	ra,0x3
    2f1a:	91e080e7          	jalr	-1762(ra) # 5834 <chdir>
    2f1e:	04054963          	bltz	a0,2f70 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    2f22:	00004517          	auipc	a0,0x4
    2f26:	31650513          	addi	a0,a0,790 # 7238 <malloc+0x163e>
    2f2a:	00003097          	auipc	ra,0x3
    2f2e:	8ea080e7          	jalr	-1814(ra) # 5814 <unlink>
    2f32:	04054d63          	bltz	a0,2f8c <iputtest+0x9e>
  if(chdir("/") < 0){
    2f36:	00004517          	auipc	a0,0x4
    2f3a:	33250513          	addi	a0,a0,818 # 7268 <malloc+0x166e>
    2f3e:	00003097          	auipc	ra,0x3
    2f42:	8f6080e7          	jalr	-1802(ra) # 5834 <chdir>
    2f46:	06054163          	bltz	a0,2fa8 <iputtest+0xba>
}
    2f4a:	60e2                	ld	ra,24(sp)
    2f4c:	6442                	ld	s0,16(sp)
    2f4e:	64a2                	ld	s1,8(sp)
    2f50:	6105                	addi	sp,sp,32
    2f52:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2f54:	85a6                	mv	a1,s1
    2f56:	00004517          	auipc	a0,0x4
    2f5a:	2aa50513          	addi	a0,a0,682 # 7200 <malloc+0x1606>
    2f5e:	00003097          	auipc	ra,0x3
    2f62:	bde080e7          	jalr	-1058(ra) # 5b3c <printf>
    exit(1);
    2f66:	4505                	li	a0,1
    2f68:	00003097          	auipc	ra,0x3
    2f6c:	85c080e7          	jalr	-1956(ra) # 57c4 <exit>
    printf("%s: chdir iputdir failed\n", s);
    2f70:	85a6                	mv	a1,s1
    2f72:	00004517          	auipc	a0,0x4
    2f76:	2a650513          	addi	a0,a0,678 # 7218 <malloc+0x161e>
    2f7a:	00003097          	auipc	ra,0x3
    2f7e:	bc2080e7          	jalr	-1086(ra) # 5b3c <printf>
    exit(1);
    2f82:	4505                	li	a0,1
    2f84:	00003097          	auipc	ra,0x3
    2f88:	840080e7          	jalr	-1984(ra) # 57c4 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2f8c:	85a6                	mv	a1,s1
    2f8e:	00004517          	auipc	a0,0x4
    2f92:	2ba50513          	addi	a0,a0,698 # 7248 <malloc+0x164e>
    2f96:	00003097          	auipc	ra,0x3
    2f9a:	ba6080e7          	jalr	-1114(ra) # 5b3c <printf>
    exit(1);
    2f9e:	4505                	li	a0,1
    2fa0:	00003097          	auipc	ra,0x3
    2fa4:	824080e7          	jalr	-2012(ra) # 57c4 <exit>
    printf("%s: chdir / failed\n", s);
    2fa8:	85a6                	mv	a1,s1
    2faa:	00004517          	auipc	a0,0x4
    2fae:	2c650513          	addi	a0,a0,710 # 7270 <malloc+0x1676>
    2fb2:	00003097          	auipc	ra,0x3
    2fb6:	b8a080e7          	jalr	-1142(ra) # 5b3c <printf>
    exit(1);
    2fba:	4505                	li	a0,1
    2fbc:	00003097          	auipc	ra,0x3
    2fc0:	808080e7          	jalr	-2040(ra) # 57c4 <exit>

0000000000002fc4 <exitiputtest>:
{
    2fc4:	7179                	addi	sp,sp,-48
    2fc6:	f406                	sd	ra,40(sp)
    2fc8:	f022                	sd	s0,32(sp)
    2fca:	ec26                	sd	s1,24(sp)
    2fcc:	1800                	addi	s0,sp,48
    2fce:	84aa                	mv	s1,a0
  pid = fork();
    2fd0:	00002097          	auipc	ra,0x2
    2fd4:	7ec080e7          	jalr	2028(ra) # 57bc <fork>
  if(pid < 0){
    2fd8:	04054663          	bltz	a0,3024 <exitiputtest+0x60>
  if(pid == 0){
    2fdc:	ed45                	bnez	a0,3094 <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    2fde:	00004517          	auipc	a0,0x4
    2fe2:	21a50513          	addi	a0,a0,538 # 71f8 <malloc+0x15fe>
    2fe6:	00003097          	auipc	ra,0x3
    2fea:	846080e7          	jalr	-1978(ra) # 582c <mkdir>
    2fee:	04054963          	bltz	a0,3040 <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    2ff2:	00004517          	auipc	a0,0x4
    2ff6:	20650513          	addi	a0,a0,518 # 71f8 <malloc+0x15fe>
    2ffa:	00003097          	auipc	ra,0x3
    2ffe:	83a080e7          	jalr	-1990(ra) # 5834 <chdir>
    3002:	04054d63          	bltz	a0,305c <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    3006:	00004517          	auipc	a0,0x4
    300a:	23250513          	addi	a0,a0,562 # 7238 <malloc+0x163e>
    300e:	00003097          	auipc	ra,0x3
    3012:	806080e7          	jalr	-2042(ra) # 5814 <unlink>
    3016:	06054163          	bltz	a0,3078 <exitiputtest+0xb4>
    exit(0);
    301a:	4501                	li	a0,0
    301c:	00002097          	auipc	ra,0x2
    3020:	7a8080e7          	jalr	1960(ra) # 57c4 <exit>
    printf("%s: fork failed\n", s);
    3024:	85a6                	mv	a1,s1
    3026:	00004517          	auipc	a0,0x4
    302a:	89250513          	addi	a0,a0,-1902 # 68b8 <malloc+0xcbe>
    302e:	00003097          	auipc	ra,0x3
    3032:	b0e080e7          	jalr	-1266(ra) # 5b3c <printf>
    exit(1);
    3036:	4505                	li	a0,1
    3038:	00002097          	auipc	ra,0x2
    303c:	78c080e7          	jalr	1932(ra) # 57c4 <exit>
      printf("%s: mkdir failed\n", s);
    3040:	85a6                	mv	a1,s1
    3042:	00004517          	auipc	a0,0x4
    3046:	1be50513          	addi	a0,a0,446 # 7200 <malloc+0x1606>
    304a:	00003097          	auipc	ra,0x3
    304e:	af2080e7          	jalr	-1294(ra) # 5b3c <printf>
      exit(1);
    3052:	4505                	li	a0,1
    3054:	00002097          	auipc	ra,0x2
    3058:	770080e7          	jalr	1904(ra) # 57c4 <exit>
      printf("%s: child chdir failed\n", s);
    305c:	85a6                	mv	a1,s1
    305e:	00004517          	auipc	a0,0x4
    3062:	22a50513          	addi	a0,a0,554 # 7288 <malloc+0x168e>
    3066:	00003097          	auipc	ra,0x3
    306a:	ad6080e7          	jalr	-1322(ra) # 5b3c <printf>
      exit(1);
    306e:	4505                	li	a0,1
    3070:	00002097          	auipc	ra,0x2
    3074:	754080e7          	jalr	1876(ra) # 57c4 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    3078:	85a6                	mv	a1,s1
    307a:	00004517          	auipc	a0,0x4
    307e:	1ce50513          	addi	a0,a0,462 # 7248 <malloc+0x164e>
    3082:	00003097          	auipc	ra,0x3
    3086:	aba080e7          	jalr	-1350(ra) # 5b3c <printf>
      exit(1);
    308a:	4505                	li	a0,1
    308c:	00002097          	auipc	ra,0x2
    3090:	738080e7          	jalr	1848(ra) # 57c4 <exit>
  wait(&xstatus);
    3094:	fdc40513          	addi	a0,s0,-36
    3098:	00002097          	auipc	ra,0x2
    309c:	734080e7          	jalr	1844(ra) # 57cc <wait>
  exit(xstatus);
    30a0:	fdc42503          	lw	a0,-36(s0)
    30a4:	00002097          	auipc	ra,0x2
    30a8:	720080e7          	jalr	1824(ra) # 57c4 <exit>

00000000000030ac <dirtest>:
{
    30ac:	1101                	addi	sp,sp,-32
    30ae:	ec06                	sd	ra,24(sp)
    30b0:	e822                	sd	s0,16(sp)
    30b2:	e426                	sd	s1,8(sp)
    30b4:	1000                	addi	s0,sp,32
    30b6:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    30b8:	00004517          	auipc	a0,0x4
    30bc:	1e850513          	addi	a0,a0,488 # 72a0 <malloc+0x16a6>
    30c0:	00002097          	auipc	ra,0x2
    30c4:	76c080e7          	jalr	1900(ra) # 582c <mkdir>
    30c8:	04054563          	bltz	a0,3112 <dirtest+0x66>
  if(chdir("dir0") < 0){
    30cc:	00004517          	auipc	a0,0x4
    30d0:	1d450513          	addi	a0,a0,468 # 72a0 <malloc+0x16a6>
    30d4:	00002097          	auipc	ra,0x2
    30d8:	760080e7          	jalr	1888(ra) # 5834 <chdir>
    30dc:	04054963          	bltz	a0,312e <dirtest+0x82>
  if(chdir("..") < 0){
    30e0:	00004517          	auipc	a0,0x4
    30e4:	1e050513          	addi	a0,a0,480 # 72c0 <malloc+0x16c6>
    30e8:	00002097          	auipc	ra,0x2
    30ec:	74c080e7          	jalr	1868(ra) # 5834 <chdir>
    30f0:	04054d63          	bltz	a0,314a <dirtest+0x9e>
  if(unlink("dir0") < 0){
    30f4:	00004517          	auipc	a0,0x4
    30f8:	1ac50513          	addi	a0,a0,428 # 72a0 <malloc+0x16a6>
    30fc:	00002097          	auipc	ra,0x2
    3100:	718080e7          	jalr	1816(ra) # 5814 <unlink>
    3104:	06054163          	bltz	a0,3166 <dirtest+0xba>
}
    3108:	60e2                	ld	ra,24(sp)
    310a:	6442                	ld	s0,16(sp)
    310c:	64a2                	ld	s1,8(sp)
    310e:	6105                	addi	sp,sp,32
    3110:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3112:	85a6                	mv	a1,s1
    3114:	00004517          	auipc	a0,0x4
    3118:	0ec50513          	addi	a0,a0,236 # 7200 <malloc+0x1606>
    311c:	00003097          	auipc	ra,0x3
    3120:	a20080e7          	jalr	-1504(ra) # 5b3c <printf>
    exit(1);
    3124:	4505                	li	a0,1
    3126:	00002097          	auipc	ra,0x2
    312a:	69e080e7          	jalr	1694(ra) # 57c4 <exit>
    printf("%s: chdir dir0 failed\n", s);
    312e:	85a6                	mv	a1,s1
    3130:	00004517          	auipc	a0,0x4
    3134:	17850513          	addi	a0,a0,376 # 72a8 <malloc+0x16ae>
    3138:	00003097          	auipc	ra,0x3
    313c:	a04080e7          	jalr	-1532(ra) # 5b3c <printf>
    exit(1);
    3140:	4505                	li	a0,1
    3142:	00002097          	auipc	ra,0x2
    3146:	682080e7          	jalr	1666(ra) # 57c4 <exit>
    printf("%s: chdir .. failed\n", s);
    314a:	85a6                	mv	a1,s1
    314c:	00004517          	auipc	a0,0x4
    3150:	17c50513          	addi	a0,a0,380 # 72c8 <malloc+0x16ce>
    3154:	00003097          	auipc	ra,0x3
    3158:	9e8080e7          	jalr	-1560(ra) # 5b3c <printf>
    exit(1);
    315c:	4505                	li	a0,1
    315e:	00002097          	auipc	ra,0x2
    3162:	666080e7          	jalr	1638(ra) # 57c4 <exit>
    printf("%s: unlink dir0 failed\n", s);
    3166:	85a6                	mv	a1,s1
    3168:	00004517          	auipc	a0,0x4
    316c:	17850513          	addi	a0,a0,376 # 72e0 <malloc+0x16e6>
    3170:	00003097          	auipc	ra,0x3
    3174:	9cc080e7          	jalr	-1588(ra) # 5b3c <printf>
    exit(1);
    3178:	4505                	li	a0,1
    317a:	00002097          	auipc	ra,0x2
    317e:	64a080e7          	jalr	1610(ra) # 57c4 <exit>

0000000000003182 <subdir>:
{
    3182:	1101                	addi	sp,sp,-32
    3184:	ec06                	sd	ra,24(sp)
    3186:	e822                	sd	s0,16(sp)
    3188:	e426                	sd	s1,8(sp)
    318a:	e04a                	sd	s2,0(sp)
    318c:	1000                	addi	s0,sp,32
    318e:	892a                	mv	s2,a0
  unlink("ff");
    3190:	00004517          	auipc	a0,0x4
    3194:	29850513          	addi	a0,a0,664 # 7428 <malloc+0x182e>
    3198:	00002097          	auipc	ra,0x2
    319c:	67c080e7          	jalr	1660(ra) # 5814 <unlink>
  if(mkdir("dd") != 0){
    31a0:	00004517          	auipc	a0,0x4
    31a4:	15850513          	addi	a0,a0,344 # 72f8 <malloc+0x16fe>
    31a8:	00002097          	auipc	ra,0x2
    31ac:	684080e7          	jalr	1668(ra) # 582c <mkdir>
    31b0:	38051663          	bnez	a0,353c <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    31b4:	20200593          	li	a1,514
    31b8:	00004517          	auipc	a0,0x4
    31bc:	16050513          	addi	a0,a0,352 # 7318 <malloc+0x171e>
    31c0:	00002097          	auipc	ra,0x2
    31c4:	644080e7          	jalr	1604(ra) # 5804 <open>
    31c8:	84aa                	mv	s1,a0
  if(fd < 0){
    31ca:	38054763          	bltz	a0,3558 <subdir+0x3d6>
  write(fd, "ff", 2);
    31ce:	4609                	li	a2,2
    31d0:	00004597          	auipc	a1,0x4
    31d4:	25858593          	addi	a1,a1,600 # 7428 <malloc+0x182e>
    31d8:	00002097          	auipc	ra,0x2
    31dc:	60c080e7          	jalr	1548(ra) # 57e4 <write>
  close(fd);
    31e0:	8526                	mv	a0,s1
    31e2:	00002097          	auipc	ra,0x2
    31e6:	60a080e7          	jalr	1546(ra) # 57ec <close>
  if(unlink("dd") >= 0){
    31ea:	00004517          	auipc	a0,0x4
    31ee:	10e50513          	addi	a0,a0,270 # 72f8 <malloc+0x16fe>
    31f2:	00002097          	auipc	ra,0x2
    31f6:	622080e7          	jalr	1570(ra) # 5814 <unlink>
    31fa:	36055d63          	bgez	a0,3574 <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    31fe:	00004517          	auipc	a0,0x4
    3202:	17250513          	addi	a0,a0,370 # 7370 <malloc+0x1776>
    3206:	00002097          	auipc	ra,0x2
    320a:	626080e7          	jalr	1574(ra) # 582c <mkdir>
    320e:	38051163          	bnez	a0,3590 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    3212:	20200593          	li	a1,514
    3216:	00004517          	auipc	a0,0x4
    321a:	18250513          	addi	a0,a0,386 # 7398 <malloc+0x179e>
    321e:	00002097          	auipc	ra,0x2
    3222:	5e6080e7          	jalr	1510(ra) # 5804 <open>
    3226:	84aa                	mv	s1,a0
  if(fd < 0){
    3228:	38054263          	bltz	a0,35ac <subdir+0x42a>
  write(fd, "FF", 2);
    322c:	4609                	li	a2,2
    322e:	00004597          	auipc	a1,0x4
    3232:	19a58593          	addi	a1,a1,410 # 73c8 <malloc+0x17ce>
    3236:	00002097          	auipc	ra,0x2
    323a:	5ae080e7          	jalr	1454(ra) # 57e4 <write>
  close(fd);
    323e:	8526                	mv	a0,s1
    3240:	00002097          	auipc	ra,0x2
    3244:	5ac080e7          	jalr	1452(ra) # 57ec <close>
  fd = open("dd/dd/../ff", 0);
    3248:	4581                	li	a1,0
    324a:	00004517          	auipc	a0,0x4
    324e:	18650513          	addi	a0,a0,390 # 73d0 <malloc+0x17d6>
    3252:	00002097          	auipc	ra,0x2
    3256:	5b2080e7          	jalr	1458(ra) # 5804 <open>
    325a:	84aa                	mv	s1,a0
  if(fd < 0){
    325c:	36054663          	bltz	a0,35c8 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    3260:	660d                	lui	a2,0x3
    3262:	00009597          	auipc	a1,0x9
    3266:	a8e58593          	addi	a1,a1,-1394 # bcf0 <buf>
    326a:	00002097          	auipc	ra,0x2
    326e:	572080e7          	jalr	1394(ra) # 57dc <read>
  if(cc != 2 || buf[0] != 'f'){
    3272:	4789                	li	a5,2
    3274:	36f51863          	bne	a0,a5,35e4 <subdir+0x462>
    3278:	00009717          	auipc	a4,0x9
    327c:	a7874703          	lbu	a4,-1416(a4) # bcf0 <buf>
    3280:	06600793          	li	a5,102
    3284:	36f71063          	bne	a4,a5,35e4 <subdir+0x462>
  close(fd);
    3288:	8526                	mv	a0,s1
    328a:	00002097          	auipc	ra,0x2
    328e:	562080e7          	jalr	1378(ra) # 57ec <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3292:	00004597          	auipc	a1,0x4
    3296:	18e58593          	addi	a1,a1,398 # 7420 <malloc+0x1826>
    329a:	00004517          	auipc	a0,0x4
    329e:	0fe50513          	addi	a0,a0,254 # 7398 <malloc+0x179e>
    32a2:	00002097          	auipc	ra,0x2
    32a6:	582080e7          	jalr	1410(ra) # 5824 <link>
    32aa:	34051b63          	bnez	a0,3600 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    32ae:	00004517          	auipc	a0,0x4
    32b2:	0ea50513          	addi	a0,a0,234 # 7398 <malloc+0x179e>
    32b6:	00002097          	auipc	ra,0x2
    32ba:	55e080e7          	jalr	1374(ra) # 5814 <unlink>
    32be:	34051f63          	bnez	a0,361c <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    32c2:	4581                	li	a1,0
    32c4:	00004517          	auipc	a0,0x4
    32c8:	0d450513          	addi	a0,a0,212 # 7398 <malloc+0x179e>
    32cc:	00002097          	auipc	ra,0x2
    32d0:	538080e7          	jalr	1336(ra) # 5804 <open>
    32d4:	36055263          	bgez	a0,3638 <subdir+0x4b6>
  if(chdir("dd") != 0){
    32d8:	00004517          	auipc	a0,0x4
    32dc:	02050513          	addi	a0,a0,32 # 72f8 <malloc+0x16fe>
    32e0:	00002097          	auipc	ra,0x2
    32e4:	554080e7          	jalr	1364(ra) # 5834 <chdir>
    32e8:	36051663          	bnez	a0,3654 <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    32ec:	00004517          	auipc	a0,0x4
    32f0:	1cc50513          	addi	a0,a0,460 # 74b8 <malloc+0x18be>
    32f4:	00002097          	auipc	ra,0x2
    32f8:	540080e7          	jalr	1344(ra) # 5834 <chdir>
    32fc:	36051a63          	bnez	a0,3670 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    3300:	00004517          	auipc	a0,0x4
    3304:	1e850513          	addi	a0,a0,488 # 74e8 <malloc+0x18ee>
    3308:	00002097          	auipc	ra,0x2
    330c:	52c080e7          	jalr	1324(ra) # 5834 <chdir>
    3310:	36051e63          	bnez	a0,368c <subdir+0x50a>
  if(chdir("./..") != 0){
    3314:	00004517          	auipc	a0,0x4
    3318:	20450513          	addi	a0,a0,516 # 7518 <malloc+0x191e>
    331c:	00002097          	auipc	ra,0x2
    3320:	518080e7          	jalr	1304(ra) # 5834 <chdir>
    3324:	38051263          	bnez	a0,36a8 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    3328:	4581                	li	a1,0
    332a:	00004517          	auipc	a0,0x4
    332e:	0f650513          	addi	a0,a0,246 # 7420 <malloc+0x1826>
    3332:	00002097          	auipc	ra,0x2
    3336:	4d2080e7          	jalr	1234(ra) # 5804 <open>
    333a:	84aa                	mv	s1,a0
  if(fd < 0){
    333c:	38054463          	bltz	a0,36c4 <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    3340:	660d                	lui	a2,0x3
    3342:	00009597          	auipc	a1,0x9
    3346:	9ae58593          	addi	a1,a1,-1618 # bcf0 <buf>
    334a:	00002097          	auipc	ra,0x2
    334e:	492080e7          	jalr	1170(ra) # 57dc <read>
    3352:	4789                	li	a5,2
    3354:	38f51663          	bne	a0,a5,36e0 <subdir+0x55e>
  close(fd);
    3358:	8526                	mv	a0,s1
    335a:	00002097          	auipc	ra,0x2
    335e:	492080e7          	jalr	1170(ra) # 57ec <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3362:	4581                	li	a1,0
    3364:	00004517          	auipc	a0,0x4
    3368:	03450513          	addi	a0,a0,52 # 7398 <malloc+0x179e>
    336c:	00002097          	auipc	ra,0x2
    3370:	498080e7          	jalr	1176(ra) # 5804 <open>
    3374:	38055463          	bgez	a0,36fc <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3378:	20200593          	li	a1,514
    337c:	00004517          	auipc	a0,0x4
    3380:	22c50513          	addi	a0,a0,556 # 75a8 <malloc+0x19ae>
    3384:	00002097          	auipc	ra,0x2
    3388:	480080e7          	jalr	1152(ra) # 5804 <open>
    338c:	38055663          	bgez	a0,3718 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3390:	20200593          	li	a1,514
    3394:	00004517          	auipc	a0,0x4
    3398:	24450513          	addi	a0,a0,580 # 75d8 <malloc+0x19de>
    339c:	00002097          	auipc	ra,0x2
    33a0:	468080e7          	jalr	1128(ra) # 5804 <open>
    33a4:	38055863          	bgez	a0,3734 <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    33a8:	20000593          	li	a1,512
    33ac:	00004517          	auipc	a0,0x4
    33b0:	f4c50513          	addi	a0,a0,-180 # 72f8 <malloc+0x16fe>
    33b4:	00002097          	auipc	ra,0x2
    33b8:	450080e7          	jalr	1104(ra) # 5804 <open>
    33bc:	38055a63          	bgez	a0,3750 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    33c0:	4589                	li	a1,2
    33c2:	00004517          	auipc	a0,0x4
    33c6:	f3650513          	addi	a0,a0,-202 # 72f8 <malloc+0x16fe>
    33ca:	00002097          	auipc	ra,0x2
    33ce:	43a080e7          	jalr	1082(ra) # 5804 <open>
    33d2:	38055d63          	bgez	a0,376c <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    33d6:	4585                	li	a1,1
    33d8:	00004517          	auipc	a0,0x4
    33dc:	f2050513          	addi	a0,a0,-224 # 72f8 <malloc+0x16fe>
    33e0:	00002097          	auipc	ra,0x2
    33e4:	424080e7          	jalr	1060(ra) # 5804 <open>
    33e8:	3a055063          	bgez	a0,3788 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    33ec:	00004597          	auipc	a1,0x4
    33f0:	27c58593          	addi	a1,a1,636 # 7668 <malloc+0x1a6e>
    33f4:	00004517          	auipc	a0,0x4
    33f8:	1b450513          	addi	a0,a0,436 # 75a8 <malloc+0x19ae>
    33fc:	00002097          	auipc	ra,0x2
    3400:	428080e7          	jalr	1064(ra) # 5824 <link>
    3404:	3a050063          	beqz	a0,37a4 <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    3408:	00004597          	auipc	a1,0x4
    340c:	26058593          	addi	a1,a1,608 # 7668 <malloc+0x1a6e>
    3410:	00004517          	auipc	a0,0x4
    3414:	1c850513          	addi	a0,a0,456 # 75d8 <malloc+0x19de>
    3418:	00002097          	auipc	ra,0x2
    341c:	40c080e7          	jalr	1036(ra) # 5824 <link>
    3420:	3a050063          	beqz	a0,37c0 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    3424:	00004597          	auipc	a1,0x4
    3428:	ffc58593          	addi	a1,a1,-4 # 7420 <malloc+0x1826>
    342c:	00004517          	auipc	a0,0x4
    3430:	eec50513          	addi	a0,a0,-276 # 7318 <malloc+0x171e>
    3434:	00002097          	auipc	ra,0x2
    3438:	3f0080e7          	jalr	1008(ra) # 5824 <link>
    343c:	3a050063          	beqz	a0,37dc <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    3440:	00004517          	auipc	a0,0x4
    3444:	16850513          	addi	a0,a0,360 # 75a8 <malloc+0x19ae>
    3448:	00002097          	auipc	ra,0x2
    344c:	3e4080e7          	jalr	996(ra) # 582c <mkdir>
    3450:	3a050463          	beqz	a0,37f8 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    3454:	00004517          	auipc	a0,0x4
    3458:	18450513          	addi	a0,a0,388 # 75d8 <malloc+0x19de>
    345c:	00002097          	auipc	ra,0x2
    3460:	3d0080e7          	jalr	976(ra) # 582c <mkdir>
    3464:	3a050863          	beqz	a0,3814 <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    3468:	00004517          	auipc	a0,0x4
    346c:	fb850513          	addi	a0,a0,-72 # 7420 <malloc+0x1826>
    3470:	00002097          	auipc	ra,0x2
    3474:	3bc080e7          	jalr	956(ra) # 582c <mkdir>
    3478:	3a050c63          	beqz	a0,3830 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    347c:	00004517          	auipc	a0,0x4
    3480:	15c50513          	addi	a0,a0,348 # 75d8 <malloc+0x19de>
    3484:	00002097          	auipc	ra,0x2
    3488:	390080e7          	jalr	912(ra) # 5814 <unlink>
    348c:	3c050063          	beqz	a0,384c <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    3490:	00004517          	auipc	a0,0x4
    3494:	11850513          	addi	a0,a0,280 # 75a8 <malloc+0x19ae>
    3498:	00002097          	auipc	ra,0x2
    349c:	37c080e7          	jalr	892(ra) # 5814 <unlink>
    34a0:	3c050463          	beqz	a0,3868 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    34a4:	00004517          	auipc	a0,0x4
    34a8:	e7450513          	addi	a0,a0,-396 # 7318 <malloc+0x171e>
    34ac:	00002097          	auipc	ra,0x2
    34b0:	388080e7          	jalr	904(ra) # 5834 <chdir>
    34b4:	3c050863          	beqz	a0,3884 <subdir+0x702>
  if(chdir("dd/xx") == 0){
    34b8:	00004517          	auipc	a0,0x4
    34bc:	30050513          	addi	a0,a0,768 # 77b8 <malloc+0x1bbe>
    34c0:	00002097          	auipc	ra,0x2
    34c4:	374080e7          	jalr	884(ra) # 5834 <chdir>
    34c8:	3c050c63          	beqz	a0,38a0 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    34cc:	00004517          	auipc	a0,0x4
    34d0:	f5450513          	addi	a0,a0,-172 # 7420 <malloc+0x1826>
    34d4:	00002097          	auipc	ra,0x2
    34d8:	340080e7          	jalr	832(ra) # 5814 <unlink>
    34dc:	3e051063          	bnez	a0,38bc <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    34e0:	00004517          	auipc	a0,0x4
    34e4:	e3850513          	addi	a0,a0,-456 # 7318 <malloc+0x171e>
    34e8:	00002097          	auipc	ra,0x2
    34ec:	32c080e7          	jalr	812(ra) # 5814 <unlink>
    34f0:	3e051463          	bnez	a0,38d8 <subdir+0x756>
  if(unlink("dd") == 0){
    34f4:	00004517          	auipc	a0,0x4
    34f8:	e0450513          	addi	a0,a0,-508 # 72f8 <malloc+0x16fe>
    34fc:	00002097          	auipc	ra,0x2
    3500:	318080e7          	jalr	792(ra) # 5814 <unlink>
    3504:	3e050863          	beqz	a0,38f4 <subdir+0x772>
  if(unlink("dd/dd") < 0){
    3508:	00004517          	auipc	a0,0x4
    350c:	32050513          	addi	a0,a0,800 # 7828 <malloc+0x1c2e>
    3510:	00002097          	auipc	ra,0x2
    3514:	304080e7          	jalr	772(ra) # 5814 <unlink>
    3518:	3e054c63          	bltz	a0,3910 <subdir+0x78e>
  if(unlink("dd") < 0){
    351c:	00004517          	auipc	a0,0x4
    3520:	ddc50513          	addi	a0,a0,-548 # 72f8 <malloc+0x16fe>
    3524:	00002097          	auipc	ra,0x2
    3528:	2f0080e7          	jalr	752(ra) # 5814 <unlink>
    352c:	40054063          	bltz	a0,392c <subdir+0x7aa>
}
    3530:	60e2                	ld	ra,24(sp)
    3532:	6442                	ld	s0,16(sp)
    3534:	64a2                	ld	s1,8(sp)
    3536:	6902                	ld	s2,0(sp)
    3538:	6105                	addi	sp,sp,32
    353a:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    353c:	85ca                	mv	a1,s2
    353e:	00004517          	auipc	a0,0x4
    3542:	dc250513          	addi	a0,a0,-574 # 7300 <malloc+0x1706>
    3546:	00002097          	auipc	ra,0x2
    354a:	5f6080e7          	jalr	1526(ra) # 5b3c <printf>
    exit(1);
    354e:	4505                	li	a0,1
    3550:	00002097          	auipc	ra,0x2
    3554:	274080e7          	jalr	628(ra) # 57c4 <exit>
    printf("%s: create dd/ff failed\n", s);
    3558:	85ca                	mv	a1,s2
    355a:	00004517          	auipc	a0,0x4
    355e:	dc650513          	addi	a0,a0,-570 # 7320 <malloc+0x1726>
    3562:	00002097          	auipc	ra,0x2
    3566:	5da080e7          	jalr	1498(ra) # 5b3c <printf>
    exit(1);
    356a:	4505                	li	a0,1
    356c:	00002097          	auipc	ra,0x2
    3570:	258080e7          	jalr	600(ra) # 57c4 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3574:	85ca                	mv	a1,s2
    3576:	00004517          	auipc	a0,0x4
    357a:	dca50513          	addi	a0,a0,-566 # 7340 <malloc+0x1746>
    357e:	00002097          	auipc	ra,0x2
    3582:	5be080e7          	jalr	1470(ra) # 5b3c <printf>
    exit(1);
    3586:	4505                	li	a0,1
    3588:	00002097          	auipc	ra,0x2
    358c:	23c080e7          	jalr	572(ra) # 57c4 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3590:	85ca                	mv	a1,s2
    3592:	00004517          	auipc	a0,0x4
    3596:	de650513          	addi	a0,a0,-538 # 7378 <malloc+0x177e>
    359a:	00002097          	auipc	ra,0x2
    359e:	5a2080e7          	jalr	1442(ra) # 5b3c <printf>
    exit(1);
    35a2:	4505                	li	a0,1
    35a4:	00002097          	auipc	ra,0x2
    35a8:	220080e7          	jalr	544(ra) # 57c4 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    35ac:	85ca                	mv	a1,s2
    35ae:	00004517          	auipc	a0,0x4
    35b2:	dfa50513          	addi	a0,a0,-518 # 73a8 <malloc+0x17ae>
    35b6:	00002097          	auipc	ra,0x2
    35ba:	586080e7          	jalr	1414(ra) # 5b3c <printf>
    exit(1);
    35be:	4505                	li	a0,1
    35c0:	00002097          	auipc	ra,0x2
    35c4:	204080e7          	jalr	516(ra) # 57c4 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    35c8:	85ca                	mv	a1,s2
    35ca:	00004517          	auipc	a0,0x4
    35ce:	e1650513          	addi	a0,a0,-490 # 73e0 <malloc+0x17e6>
    35d2:	00002097          	auipc	ra,0x2
    35d6:	56a080e7          	jalr	1386(ra) # 5b3c <printf>
    exit(1);
    35da:	4505                	li	a0,1
    35dc:	00002097          	auipc	ra,0x2
    35e0:	1e8080e7          	jalr	488(ra) # 57c4 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    35e4:	85ca                	mv	a1,s2
    35e6:	00004517          	auipc	a0,0x4
    35ea:	e1a50513          	addi	a0,a0,-486 # 7400 <malloc+0x1806>
    35ee:	00002097          	auipc	ra,0x2
    35f2:	54e080e7          	jalr	1358(ra) # 5b3c <printf>
    exit(1);
    35f6:	4505                	li	a0,1
    35f8:	00002097          	auipc	ra,0x2
    35fc:	1cc080e7          	jalr	460(ra) # 57c4 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3600:	85ca                	mv	a1,s2
    3602:	00004517          	auipc	a0,0x4
    3606:	e2e50513          	addi	a0,a0,-466 # 7430 <malloc+0x1836>
    360a:	00002097          	auipc	ra,0x2
    360e:	532080e7          	jalr	1330(ra) # 5b3c <printf>
    exit(1);
    3612:	4505                	li	a0,1
    3614:	00002097          	auipc	ra,0x2
    3618:	1b0080e7          	jalr	432(ra) # 57c4 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    361c:	85ca                	mv	a1,s2
    361e:	00004517          	auipc	a0,0x4
    3622:	e3a50513          	addi	a0,a0,-454 # 7458 <malloc+0x185e>
    3626:	00002097          	auipc	ra,0x2
    362a:	516080e7          	jalr	1302(ra) # 5b3c <printf>
    exit(1);
    362e:	4505                	li	a0,1
    3630:	00002097          	auipc	ra,0x2
    3634:	194080e7          	jalr	404(ra) # 57c4 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3638:	85ca                	mv	a1,s2
    363a:	00004517          	auipc	a0,0x4
    363e:	e3e50513          	addi	a0,a0,-450 # 7478 <malloc+0x187e>
    3642:	00002097          	auipc	ra,0x2
    3646:	4fa080e7          	jalr	1274(ra) # 5b3c <printf>
    exit(1);
    364a:	4505                	li	a0,1
    364c:	00002097          	auipc	ra,0x2
    3650:	178080e7          	jalr	376(ra) # 57c4 <exit>
    printf("%s: chdir dd failed\n", s);
    3654:	85ca                	mv	a1,s2
    3656:	00004517          	auipc	a0,0x4
    365a:	e4a50513          	addi	a0,a0,-438 # 74a0 <malloc+0x18a6>
    365e:	00002097          	auipc	ra,0x2
    3662:	4de080e7          	jalr	1246(ra) # 5b3c <printf>
    exit(1);
    3666:	4505                	li	a0,1
    3668:	00002097          	auipc	ra,0x2
    366c:	15c080e7          	jalr	348(ra) # 57c4 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3670:	85ca                	mv	a1,s2
    3672:	00004517          	auipc	a0,0x4
    3676:	e5650513          	addi	a0,a0,-426 # 74c8 <malloc+0x18ce>
    367a:	00002097          	auipc	ra,0x2
    367e:	4c2080e7          	jalr	1218(ra) # 5b3c <printf>
    exit(1);
    3682:	4505                	li	a0,1
    3684:	00002097          	auipc	ra,0x2
    3688:	140080e7          	jalr	320(ra) # 57c4 <exit>
    printf("chdir dd/../../dd failed\n", s);
    368c:	85ca                	mv	a1,s2
    368e:	00004517          	auipc	a0,0x4
    3692:	e6a50513          	addi	a0,a0,-406 # 74f8 <malloc+0x18fe>
    3696:	00002097          	auipc	ra,0x2
    369a:	4a6080e7          	jalr	1190(ra) # 5b3c <printf>
    exit(1);
    369e:	4505                	li	a0,1
    36a0:	00002097          	auipc	ra,0x2
    36a4:	124080e7          	jalr	292(ra) # 57c4 <exit>
    printf("%s: chdir ./.. failed\n", s);
    36a8:	85ca                	mv	a1,s2
    36aa:	00004517          	auipc	a0,0x4
    36ae:	e7650513          	addi	a0,a0,-394 # 7520 <malloc+0x1926>
    36b2:	00002097          	auipc	ra,0x2
    36b6:	48a080e7          	jalr	1162(ra) # 5b3c <printf>
    exit(1);
    36ba:	4505                	li	a0,1
    36bc:	00002097          	auipc	ra,0x2
    36c0:	108080e7          	jalr	264(ra) # 57c4 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    36c4:	85ca                	mv	a1,s2
    36c6:	00004517          	auipc	a0,0x4
    36ca:	e7250513          	addi	a0,a0,-398 # 7538 <malloc+0x193e>
    36ce:	00002097          	auipc	ra,0x2
    36d2:	46e080e7          	jalr	1134(ra) # 5b3c <printf>
    exit(1);
    36d6:	4505                	li	a0,1
    36d8:	00002097          	auipc	ra,0x2
    36dc:	0ec080e7          	jalr	236(ra) # 57c4 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    36e0:	85ca                	mv	a1,s2
    36e2:	00004517          	auipc	a0,0x4
    36e6:	e7650513          	addi	a0,a0,-394 # 7558 <malloc+0x195e>
    36ea:	00002097          	auipc	ra,0x2
    36ee:	452080e7          	jalr	1106(ra) # 5b3c <printf>
    exit(1);
    36f2:	4505                	li	a0,1
    36f4:	00002097          	auipc	ra,0x2
    36f8:	0d0080e7          	jalr	208(ra) # 57c4 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    36fc:	85ca                	mv	a1,s2
    36fe:	00004517          	auipc	a0,0x4
    3702:	e7a50513          	addi	a0,a0,-390 # 7578 <malloc+0x197e>
    3706:	00002097          	auipc	ra,0x2
    370a:	436080e7          	jalr	1078(ra) # 5b3c <printf>
    exit(1);
    370e:	4505                	li	a0,1
    3710:	00002097          	auipc	ra,0x2
    3714:	0b4080e7          	jalr	180(ra) # 57c4 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3718:	85ca                	mv	a1,s2
    371a:	00004517          	auipc	a0,0x4
    371e:	e9e50513          	addi	a0,a0,-354 # 75b8 <malloc+0x19be>
    3722:	00002097          	auipc	ra,0x2
    3726:	41a080e7          	jalr	1050(ra) # 5b3c <printf>
    exit(1);
    372a:	4505                	li	a0,1
    372c:	00002097          	auipc	ra,0x2
    3730:	098080e7          	jalr	152(ra) # 57c4 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3734:	85ca                	mv	a1,s2
    3736:	00004517          	auipc	a0,0x4
    373a:	eb250513          	addi	a0,a0,-334 # 75e8 <malloc+0x19ee>
    373e:	00002097          	auipc	ra,0x2
    3742:	3fe080e7          	jalr	1022(ra) # 5b3c <printf>
    exit(1);
    3746:	4505                	li	a0,1
    3748:	00002097          	auipc	ra,0x2
    374c:	07c080e7          	jalr	124(ra) # 57c4 <exit>
    printf("%s: create dd succeeded!\n", s);
    3750:	85ca                	mv	a1,s2
    3752:	00004517          	auipc	a0,0x4
    3756:	eb650513          	addi	a0,a0,-330 # 7608 <malloc+0x1a0e>
    375a:	00002097          	auipc	ra,0x2
    375e:	3e2080e7          	jalr	994(ra) # 5b3c <printf>
    exit(1);
    3762:	4505                	li	a0,1
    3764:	00002097          	auipc	ra,0x2
    3768:	060080e7          	jalr	96(ra) # 57c4 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    376c:	85ca                	mv	a1,s2
    376e:	00004517          	auipc	a0,0x4
    3772:	eba50513          	addi	a0,a0,-326 # 7628 <malloc+0x1a2e>
    3776:	00002097          	auipc	ra,0x2
    377a:	3c6080e7          	jalr	966(ra) # 5b3c <printf>
    exit(1);
    377e:	4505                	li	a0,1
    3780:	00002097          	auipc	ra,0x2
    3784:	044080e7          	jalr	68(ra) # 57c4 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3788:	85ca                	mv	a1,s2
    378a:	00004517          	auipc	a0,0x4
    378e:	ebe50513          	addi	a0,a0,-322 # 7648 <malloc+0x1a4e>
    3792:	00002097          	auipc	ra,0x2
    3796:	3aa080e7          	jalr	938(ra) # 5b3c <printf>
    exit(1);
    379a:	4505                	li	a0,1
    379c:	00002097          	auipc	ra,0x2
    37a0:	028080e7          	jalr	40(ra) # 57c4 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    37a4:	85ca                	mv	a1,s2
    37a6:	00004517          	auipc	a0,0x4
    37aa:	ed250513          	addi	a0,a0,-302 # 7678 <malloc+0x1a7e>
    37ae:	00002097          	auipc	ra,0x2
    37b2:	38e080e7          	jalr	910(ra) # 5b3c <printf>
    exit(1);
    37b6:	4505                	li	a0,1
    37b8:	00002097          	auipc	ra,0x2
    37bc:	00c080e7          	jalr	12(ra) # 57c4 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    37c0:	85ca                	mv	a1,s2
    37c2:	00004517          	auipc	a0,0x4
    37c6:	ede50513          	addi	a0,a0,-290 # 76a0 <malloc+0x1aa6>
    37ca:	00002097          	auipc	ra,0x2
    37ce:	372080e7          	jalr	882(ra) # 5b3c <printf>
    exit(1);
    37d2:	4505                	li	a0,1
    37d4:	00002097          	auipc	ra,0x2
    37d8:	ff0080e7          	jalr	-16(ra) # 57c4 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    37dc:	85ca                	mv	a1,s2
    37de:	00004517          	auipc	a0,0x4
    37e2:	eea50513          	addi	a0,a0,-278 # 76c8 <malloc+0x1ace>
    37e6:	00002097          	auipc	ra,0x2
    37ea:	356080e7          	jalr	854(ra) # 5b3c <printf>
    exit(1);
    37ee:	4505                	li	a0,1
    37f0:	00002097          	auipc	ra,0x2
    37f4:	fd4080e7          	jalr	-44(ra) # 57c4 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    37f8:	85ca                	mv	a1,s2
    37fa:	00004517          	auipc	a0,0x4
    37fe:	ef650513          	addi	a0,a0,-266 # 76f0 <malloc+0x1af6>
    3802:	00002097          	auipc	ra,0x2
    3806:	33a080e7          	jalr	826(ra) # 5b3c <printf>
    exit(1);
    380a:	4505                	li	a0,1
    380c:	00002097          	auipc	ra,0x2
    3810:	fb8080e7          	jalr	-72(ra) # 57c4 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3814:	85ca                	mv	a1,s2
    3816:	00004517          	auipc	a0,0x4
    381a:	efa50513          	addi	a0,a0,-262 # 7710 <malloc+0x1b16>
    381e:	00002097          	auipc	ra,0x2
    3822:	31e080e7          	jalr	798(ra) # 5b3c <printf>
    exit(1);
    3826:	4505                	li	a0,1
    3828:	00002097          	auipc	ra,0x2
    382c:	f9c080e7          	jalr	-100(ra) # 57c4 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3830:	85ca                	mv	a1,s2
    3832:	00004517          	auipc	a0,0x4
    3836:	efe50513          	addi	a0,a0,-258 # 7730 <malloc+0x1b36>
    383a:	00002097          	auipc	ra,0x2
    383e:	302080e7          	jalr	770(ra) # 5b3c <printf>
    exit(1);
    3842:	4505                	li	a0,1
    3844:	00002097          	auipc	ra,0x2
    3848:	f80080e7          	jalr	-128(ra) # 57c4 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    384c:	85ca                	mv	a1,s2
    384e:	00004517          	auipc	a0,0x4
    3852:	f0a50513          	addi	a0,a0,-246 # 7758 <malloc+0x1b5e>
    3856:	00002097          	auipc	ra,0x2
    385a:	2e6080e7          	jalr	742(ra) # 5b3c <printf>
    exit(1);
    385e:	4505                	li	a0,1
    3860:	00002097          	auipc	ra,0x2
    3864:	f64080e7          	jalr	-156(ra) # 57c4 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3868:	85ca                	mv	a1,s2
    386a:	00004517          	auipc	a0,0x4
    386e:	f0e50513          	addi	a0,a0,-242 # 7778 <malloc+0x1b7e>
    3872:	00002097          	auipc	ra,0x2
    3876:	2ca080e7          	jalr	714(ra) # 5b3c <printf>
    exit(1);
    387a:	4505                	li	a0,1
    387c:	00002097          	auipc	ra,0x2
    3880:	f48080e7          	jalr	-184(ra) # 57c4 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3884:	85ca                	mv	a1,s2
    3886:	00004517          	auipc	a0,0x4
    388a:	f1250513          	addi	a0,a0,-238 # 7798 <malloc+0x1b9e>
    388e:	00002097          	auipc	ra,0x2
    3892:	2ae080e7          	jalr	686(ra) # 5b3c <printf>
    exit(1);
    3896:	4505                	li	a0,1
    3898:	00002097          	auipc	ra,0x2
    389c:	f2c080e7          	jalr	-212(ra) # 57c4 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    38a0:	85ca                	mv	a1,s2
    38a2:	00004517          	auipc	a0,0x4
    38a6:	f1e50513          	addi	a0,a0,-226 # 77c0 <malloc+0x1bc6>
    38aa:	00002097          	auipc	ra,0x2
    38ae:	292080e7          	jalr	658(ra) # 5b3c <printf>
    exit(1);
    38b2:	4505                	li	a0,1
    38b4:	00002097          	auipc	ra,0x2
    38b8:	f10080e7          	jalr	-240(ra) # 57c4 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    38bc:	85ca                	mv	a1,s2
    38be:	00004517          	auipc	a0,0x4
    38c2:	b9a50513          	addi	a0,a0,-1126 # 7458 <malloc+0x185e>
    38c6:	00002097          	auipc	ra,0x2
    38ca:	276080e7          	jalr	630(ra) # 5b3c <printf>
    exit(1);
    38ce:	4505                	li	a0,1
    38d0:	00002097          	auipc	ra,0x2
    38d4:	ef4080e7          	jalr	-268(ra) # 57c4 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    38d8:	85ca                	mv	a1,s2
    38da:	00004517          	auipc	a0,0x4
    38de:	f0650513          	addi	a0,a0,-250 # 77e0 <malloc+0x1be6>
    38e2:	00002097          	auipc	ra,0x2
    38e6:	25a080e7          	jalr	602(ra) # 5b3c <printf>
    exit(1);
    38ea:	4505                	li	a0,1
    38ec:	00002097          	auipc	ra,0x2
    38f0:	ed8080e7          	jalr	-296(ra) # 57c4 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    38f4:	85ca                	mv	a1,s2
    38f6:	00004517          	auipc	a0,0x4
    38fa:	f0a50513          	addi	a0,a0,-246 # 7800 <malloc+0x1c06>
    38fe:	00002097          	auipc	ra,0x2
    3902:	23e080e7          	jalr	574(ra) # 5b3c <printf>
    exit(1);
    3906:	4505                	li	a0,1
    3908:	00002097          	auipc	ra,0x2
    390c:	ebc080e7          	jalr	-324(ra) # 57c4 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3910:	85ca                	mv	a1,s2
    3912:	00004517          	auipc	a0,0x4
    3916:	f1e50513          	addi	a0,a0,-226 # 7830 <malloc+0x1c36>
    391a:	00002097          	auipc	ra,0x2
    391e:	222080e7          	jalr	546(ra) # 5b3c <printf>
    exit(1);
    3922:	4505                	li	a0,1
    3924:	00002097          	auipc	ra,0x2
    3928:	ea0080e7          	jalr	-352(ra) # 57c4 <exit>
    printf("%s: unlink dd failed\n", s);
    392c:	85ca                	mv	a1,s2
    392e:	00004517          	auipc	a0,0x4
    3932:	f2250513          	addi	a0,a0,-222 # 7850 <malloc+0x1c56>
    3936:	00002097          	auipc	ra,0x2
    393a:	206080e7          	jalr	518(ra) # 5b3c <printf>
    exit(1);
    393e:	4505                	li	a0,1
    3940:	00002097          	auipc	ra,0x2
    3944:	e84080e7          	jalr	-380(ra) # 57c4 <exit>

0000000000003948 <rmdot>:
{
    3948:	1101                	addi	sp,sp,-32
    394a:	ec06                	sd	ra,24(sp)
    394c:	e822                	sd	s0,16(sp)
    394e:	e426                	sd	s1,8(sp)
    3950:	1000                	addi	s0,sp,32
    3952:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3954:	00004517          	auipc	a0,0x4
    3958:	f1450513          	addi	a0,a0,-236 # 7868 <malloc+0x1c6e>
    395c:	00002097          	auipc	ra,0x2
    3960:	ed0080e7          	jalr	-304(ra) # 582c <mkdir>
    3964:	e549                	bnez	a0,39ee <rmdot+0xa6>
  if(chdir("dots") != 0){
    3966:	00004517          	auipc	a0,0x4
    396a:	f0250513          	addi	a0,a0,-254 # 7868 <malloc+0x1c6e>
    396e:	00002097          	auipc	ra,0x2
    3972:	ec6080e7          	jalr	-314(ra) # 5834 <chdir>
    3976:	e951                	bnez	a0,3a0a <rmdot+0xc2>
  if(unlink(".") == 0){
    3978:	00003517          	auipc	a0,0x3
    397c:	da050513          	addi	a0,a0,-608 # 6718 <malloc+0xb1e>
    3980:	00002097          	auipc	ra,0x2
    3984:	e94080e7          	jalr	-364(ra) # 5814 <unlink>
    3988:	cd59                	beqz	a0,3a26 <rmdot+0xde>
  if(unlink("..") == 0){
    398a:	00004517          	auipc	a0,0x4
    398e:	93650513          	addi	a0,a0,-1738 # 72c0 <malloc+0x16c6>
    3992:	00002097          	auipc	ra,0x2
    3996:	e82080e7          	jalr	-382(ra) # 5814 <unlink>
    399a:	c545                	beqz	a0,3a42 <rmdot+0xfa>
  if(chdir("/") != 0){
    399c:	00004517          	auipc	a0,0x4
    39a0:	8cc50513          	addi	a0,a0,-1844 # 7268 <malloc+0x166e>
    39a4:	00002097          	auipc	ra,0x2
    39a8:	e90080e7          	jalr	-368(ra) # 5834 <chdir>
    39ac:	e94d                	bnez	a0,3a5e <rmdot+0x116>
  if(unlink("dots/.") == 0){
    39ae:	00004517          	auipc	a0,0x4
    39b2:	f2250513          	addi	a0,a0,-222 # 78d0 <malloc+0x1cd6>
    39b6:	00002097          	auipc	ra,0x2
    39ba:	e5e080e7          	jalr	-418(ra) # 5814 <unlink>
    39be:	cd55                	beqz	a0,3a7a <rmdot+0x132>
  if(unlink("dots/..") == 0){
    39c0:	00004517          	auipc	a0,0x4
    39c4:	f3850513          	addi	a0,a0,-200 # 78f8 <malloc+0x1cfe>
    39c8:	00002097          	auipc	ra,0x2
    39cc:	e4c080e7          	jalr	-436(ra) # 5814 <unlink>
    39d0:	c179                	beqz	a0,3a96 <rmdot+0x14e>
  if(unlink("dots") != 0){
    39d2:	00004517          	auipc	a0,0x4
    39d6:	e9650513          	addi	a0,a0,-362 # 7868 <malloc+0x1c6e>
    39da:	00002097          	auipc	ra,0x2
    39de:	e3a080e7          	jalr	-454(ra) # 5814 <unlink>
    39e2:	e961                	bnez	a0,3ab2 <rmdot+0x16a>
}
    39e4:	60e2                	ld	ra,24(sp)
    39e6:	6442                	ld	s0,16(sp)
    39e8:	64a2                	ld	s1,8(sp)
    39ea:	6105                	addi	sp,sp,32
    39ec:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    39ee:	85a6                	mv	a1,s1
    39f0:	00004517          	auipc	a0,0x4
    39f4:	e8050513          	addi	a0,a0,-384 # 7870 <malloc+0x1c76>
    39f8:	00002097          	auipc	ra,0x2
    39fc:	144080e7          	jalr	324(ra) # 5b3c <printf>
    exit(1);
    3a00:	4505                	li	a0,1
    3a02:	00002097          	auipc	ra,0x2
    3a06:	dc2080e7          	jalr	-574(ra) # 57c4 <exit>
    printf("%s: chdir dots failed\n", s);
    3a0a:	85a6                	mv	a1,s1
    3a0c:	00004517          	auipc	a0,0x4
    3a10:	e7c50513          	addi	a0,a0,-388 # 7888 <malloc+0x1c8e>
    3a14:	00002097          	auipc	ra,0x2
    3a18:	128080e7          	jalr	296(ra) # 5b3c <printf>
    exit(1);
    3a1c:	4505                	li	a0,1
    3a1e:	00002097          	auipc	ra,0x2
    3a22:	da6080e7          	jalr	-602(ra) # 57c4 <exit>
    printf("%s: rm . worked!\n", s);
    3a26:	85a6                	mv	a1,s1
    3a28:	00004517          	auipc	a0,0x4
    3a2c:	e7850513          	addi	a0,a0,-392 # 78a0 <malloc+0x1ca6>
    3a30:	00002097          	auipc	ra,0x2
    3a34:	10c080e7          	jalr	268(ra) # 5b3c <printf>
    exit(1);
    3a38:	4505                	li	a0,1
    3a3a:	00002097          	auipc	ra,0x2
    3a3e:	d8a080e7          	jalr	-630(ra) # 57c4 <exit>
    printf("%s: rm .. worked!\n", s);
    3a42:	85a6                	mv	a1,s1
    3a44:	00004517          	auipc	a0,0x4
    3a48:	e7450513          	addi	a0,a0,-396 # 78b8 <malloc+0x1cbe>
    3a4c:	00002097          	auipc	ra,0x2
    3a50:	0f0080e7          	jalr	240(ra) # 5b3c <printf>
    exit(1);
    3a54:	4505                	li	a0,1
    3a56:	00002097          	auipc	ra,0x2
    3a5a:	d6e080e7          	jalr	-658(ra) # 57c4 <exit>
    printf("%s: chdir / failed\n", s);
    3a5e:	85a6                	mv	a1,s1
    3a60:	00004517          	auipc	a0,0x4
    3a64:	81050513          	addi	a0,a0,-2032 # 7270 <malloc+0x1676>
    3a68:	00002097          	auipc	ra,0x2
    3a6c:	0d4080e7          	jalr	212(ra) # 5b3c <printf>
    exit(1);
    3a70:	4505                	li	a0,1
    3a72:	00002097          	auipc	ra,0x2
    3a76:	d52080e7          	jalr	-686(ra) # 57c4 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3a7a:	85a6                	mv	a1,s1
    3a7c:	00004517          	auipc	a0,0x4
    3a80:	e5c50513          	addi	a0,a0,-420 # 78d8 <malloc+0x1cde>
    3a84:	00002097          	auipc	ra,0x2
    3a88:	0b8080e7          	jalr	184(ra) # 5b3c <printf>
    exit(1);
    3a8c:	4505                	li	a0,1
    3a8e:	00002097          	auipc	ra,0x2
    3a92:	d36080e7          	jalr	-714(ra) # 57c4 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3a96:	85a6                	mv	a1,s1
    3a98:	00004517          	auipc	a0,0x4
    3a9c:	e6850513          	addi	a0,a0,-408 # 7900 <malloc+0x1d06>
    3aa0:	00002097          	auipc	ra,0x2
    3aa4:	09c080e7          	jalr	156(ra) # 5b3c <printf>
    exit(1);
    3aa8:	4505                	li	a0,1
    3aaa:	00002097          	auipc	ra,0x2
    3aae:	d1a080e7          	jalr	-742(ra) # 57c4 <exit>
    printf("%s: unlink dots failed!\n", s);
    3ab2:	85a6                	mv	a1,s1
    3ab4:	00004517          	auipc	a0,0x4
    3ab8:	e6c50513          	addi	a0,a0,-404 # 7920 <malloc+0x1d26>
    3abc:	00002097          	auipc	ra,0x2
    3ac0:	080080e7          	jalr	128(ra) # 5b3c <printf>
    exit(1);
    3ac4:	4505                	li	a0,1
    3ac6:	00002097          	auipc	ra,0x2
    3aca:	cfe080e7          	jalr	-770(ra) # 57c4 <exit>

0000000000003ace <dirfile>:
{
    3ace:	1101                	addi	sp,sp,-32
    3ad0:	ec06                	sd	ra,24(sp)
    3ad2:	e822                	sd	s0,16(sp)
    3ad4:	e426                	sd	s1,8(sp)
    3ad6:	e04a                	sd	s2,0(sp)
    3ad8:	1000                	addi	s0,sp,32
    3ada:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3adc:	20000593          	li	a1,512
    3ae0:	00002517          	auipc	a0,0x2
    3ae4:	53850513          	addi	a0,a0,1336 # 6018 <malloc+0x41e>
    3ae8:	00002097          	auipc	ra,0x2
    3aec:	d1c080e7          	jalr	-740(ra) # 5804 <open>
  if(fd < 0){
    3af0:	0e054d63          	bltz	a0,3bea <dirfile+0x11c>
  close(fd);
    3af4:	00002097          	auipc	ra,0x2
    3af8:	cf8080e7          	jalr	-776(ra) # 57ec <close>
  if(chdir("dirfile") == 0){
    3afc:	00002517          	auipc	a0,0x2
    3b00:	51c50513          	addi	a0,a0,1308 # 6018 <malloc+0x41e>
    3b04:	00002097          	auipc	ra,0x2
    3b08:	d30080e7          	jalr	-720(ra) # 5834 <chdir>
    3b0c:	cd6d                	beqz	a0,3c06 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    3b0e:	4581                	li	a1,0
    3b10:	00004517          	auipc	a0,0x4
    3b14:	e7050513          	addi	a0,a0,-400 # 7980 <malloc+0x1d86>
    3b18:	00002097          	auipc	ra,0x2
    3b1c:	cec080e7          	jalr	-788(ra) # 5804 <open>
  if(fd >= 0){
    3b20:	10055163          	bgez	a0,3c22 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    3b24:	20000593          	li	a1,512
    3b28:	00004517          	auipc	a0,0x4
    3b2c:	e5850513          	addi	a0,a0,-424 # 7980 <malloc+0x1d86>
    3b30:	00002097          	auipc	ra,0x2
    3b34:	cd4080e7          	jalr	-812(ra) # 5804 <open>
  if(fd >= 0){
    3b38:	10055363          	bgez	a0,3c3e <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    3b3c:	00004517          	auipc	a0,0x4
    3b40:	e4450513          	addi	a0,a0,-444 # 7980 <malloc+0x1d86>
    3b44:	00002097          	auipc	ra,0x2
    3b48:	ce8080e7          	jalr	-792(ra) # 582c <mkdir>
    3b4c:	10050763          	beqz	a0,3c5a <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    3b50:	00004517          	auipc	a0,0x4
    3b54:	e3050513          	addi	a0,a0,-464 # 7980 <malloc+0x1d86>
    3b58:	00002097          	auipc	ra,0x2
    3b5c:	cbc080e7          	jalr	-836(ra) # 5814 <unlink>
    3b60:	10050b63          	beqz	a0,3c76 <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    3b64:	00004597          	auipc	a1,0x4
    3b68:	e1c58593          	addi	a1,a1,-484 # 7980 <malloc+0x1d86>
    3b6c:	00002517          	auipc	a0,0x2
    3b70:	6ac50513          	addi	a0,a0,1708 # 6218 <malloc+0x61e>
    3b74:	00002097          	auipc	ra,0x2
    3b78:	cb0080e7          	jalr	-848(ra) # 5824 <link>
    3b7c:	10050b63          	beqz	a0,3c92 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3b80:	00002517          	auipc	a0,0x2
    3b84:	49850513          	addi	a0,a0,1176 # 6018 <malloc+0x41e>
    3b88:	00002097          	auipc	ra,0x2
    3b8c:	c8c080e7          	jalr	-884(ra) # 5814 <unlink>
    3b90:	10051f63          	bnez	a0,3cae <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3b94:	4589                	li	a1,2
    3b96:	00003517          	auipc	a0,0x3
    3b9a:	b8250513          	addi	a0,a0,-1150 # 6718 <malloc+0xb1e>
    3b9e:	00002097          	auipc	ra,0x2
    3ba2:	c66080e7          	jalr	-922(ra) # 5804 <open>
  if(fd >= 0){
    3ba6:	12055263          	bgez	a0,3cca <dirfile+0x1fc>
  fd = open(".", 0);
    3baa:	4581                	li	a1,0
    3bac:	00003517          	auipc	a0,0x3
    3bb0:	b6c50513          	addi	a0,a0,-1172 # 6718 <malloc+0xb1e>
    3bb4:	00002097          	auipc	ra,0x2
    3bb8:	c50080e7          	jalr	-944(ra) # 5804 <open>
    3bbc:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3bbe:	4605                	li	a2,1
    3bc0:	00002597          	auipc	a1,0x2
    3bc4:	53058593          	addi	a1,a1,1328 # 60f0 <malloc+0x4f6>
    3bc8:	00002097          	auipc	ra,0x2
    3bcc:	c1c080e7          	jalr	-996(ra) # 57e4 <write>
    3bd0:	10a04b63          	bgtz	a0,3ce6 <dirfile+0x218>
  close(fd);
    3bd4:	8526                	mv	a0,s1
    3bd6:	00002097          	auipc	ra,0x2
    3bda:	c16080e7          	jalr	-1002(ra) # 57ec <close>
}
    3bde:	60e2                	ld	ra,24(sp)
    3be0:	6442                	ld	s0,16(sp)
    3be2:	64a2                	ld	s1,8(sp)
    3be4:	6902                	ld	s2,0(sp)
    3be6:	6105                	addi	sp,sp,32
    3be8:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3bea:	85ca                	mv	a1,s2
    3bec:	00004517          	auipc	a0,0x4
    3bf0:	d5450513          	addi	a0,a0,-684 # 7940 <malloc+0x1d46>
    3bf4:	00002097          	auipc	ra,0x2
    3bf8:	f48080e7          	jalr	-184(ra) # 5b3c <printf>
    exit(1);
    3bfc:	4505                	li	a0,1
    3bfe:	00002097          	auipc	ra,0x2
    3c02:	bc6080e7          	jalr	-1082(ra) # 57c4 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3c06:	85ca                	mv	a1,s2
    3c08:	00004517          	auipc	a0,0x4
    3c0c:	d5850513          	addi	a0,a0,-680 # 7960 <malloc+0x1d66>
    3c10:	00002097          	auipc	ra,0x2
    3c14:	f2c080e7          	jalr	-212(ra) # 5b3c <printf>
    exit(1);
    3c18:	4505                	li	a0,1
    3c1a:	00002097          	auipc	ra,0x2
    3c1e:	baa080e7          	jalr	-1110(ra) # 57c4 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3c22:	85ca                	mv	a1,s2
    3c24:	00004517          	auipc	a0,0x4
    3c28:	d6c50513          	addi	a0,a0,-660 # 7990 <malloc+0x1d96>
    3c2c:	00002097          	auipc	ra,0x2
    3c30:	f10080e7          	jalr	-240(ra) # 5b3c <printf>
    exit(1);
    3c34:	4505                	li	a0,1
    3c36:	00002097          	auipc	ra,0x2
    3c3a:	b8e080e7          	jalr	-1138(ra) # 57c4 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3c3e:	85ca                	mv	a1,s2
    3c40:	00004517          	auipc	a0,0x4
    3c44:	d5050513          	addi	a0,a0,-688 # 7990 <malloc+0x1d96>
    3c48:	00002097          	auipc	ra,0x2
    3c4c:	ef4080e7          	jalr	-268(ra) # 5b3c <printf>
    exit(1);
    3c50:	4505                	li	a0,1
    3c52:	00002097          	auipc	ra,0x2
    3c56:	b72080e7          	jalr	-1166(ra) # 57c4 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3c5a:	85ca                	mv	a1,s2
    3c5c:	00004517          	auipc	a0,0x4
    3c60:	d5c50513          	addi	a0,a0,-676 # 79b8 <malloc+0x1dbe>
    3c64:	00002097          	auipc	ra,0x2
    3c68:	ed8080e7          	jalr	-296(ra) # 5b3c <printf>
    exit(1);
    3c6c:	4505                	li	a0,1
    3c6e:	00002097          	auipc	ra,0x2
    3c72:	b56080e7          	jalr	-1194(ra) # 57c4 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3c76:	85ca                	mv	a1,s2
    3c78:	00004517          	auipc	a0,0x4
    3c7c:	d6850513          	addi	a0,a0,-664 # 79e0 <malloc+0x1de6>
    3c80:	00002097          	auipc	ra,0x2
    3c84:	ebc080e7          	jalr	-324(ra) # 5b3c <printf>
    exit(1);
    3c88:	4505                	li	a0,1
    3c8a:	00002097          	auipc	ra,0x2
    3c8e:	b3a080e7          	jalr	-1222(ra) # 57c4 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3c92:	85ca                	mv	a1,s2
    3c94:	00004517          	auipc	a0,0x4
    3c98:	d7450513          	addi	a0,a0,-652 # 7a08 <malloc+0x1e0e>
    3c9c:	00002097          	auipc	ra,0x2
    3ca0:	ea0080e7          	jalr	-352(ra) # 5b3c <printf>
    exit(1);
    3ca4:	4505                	li	a0,1
    3ca6:	00002097          	auipc	ra,0x2
    3caa:	b1e080e7          	jalr	-1250(ra) # 57c4 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3cae:	85ca                	mv	a1,s2
    3cb0:	00004517          	auipc	a0,0x4
    3cb4:	d8050513          	addi	a0,a0,-640 # 7a30 <malloc+0x1e36>
    3cb8:	00002097          	auipc	ra,0x2
    3cbc:	e84080e7          	jalr	-380(ra) # 5b3c <printf>
    exit(1);
    3cc0:	4505                	li	a0,1
    3cc2:	00002097          	auipc	ra,0x2
    3cc6:	b02080e7          	jalr	-1278(ra) # 57c4 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3cca:	85ca                	mv	a1,s2
    3ccc:	00004517          	auipc	a0,0x4
    3cd0:	d8450513          	addi	a0,a0,-636 # 7a50 <malloc+0x1e56>
    3cd4:	00002097          	auipc	ra,0x2
    3cd8:	e68080e7          	jalr	-408(ra) # 5b3c <printf>
    exit(1);
    3cdc:	4505                	li	a0,1
    3cde:	00002097          	auipc	ra,0x2
    3ce2:	ae6080e7          	jalr	-1306(ra) # 57c4 <exit>
    printf("%s: write . succeeded!\n", s);
    3ce6:	85ca                	mv	a1,s2
    3ce8:	00004517          	auipc	a0,0x4
    3cec:	d9050513          	addi	a0,a0,-624 # 7a78 <malloc+0x1e7e>
    3cf0:	00002097          	auipc	ra,0x2
    3cf4:	e4c080e7          	jalr	-436(ra) # 5b3c <printf>
    exit(1);
    3cf8:	4505                	li	a0,1
    3cfa:	00002097          	auipc	ra,0x2
    3cfe:	aca080e7          	jalr	-1334(ra) # 57c4 <exit>

0000000000003d02 <iref>:
{
    3d02:	7139                	addi	sp,sp,-64
    3d04:	fc06                	sd	ra,56(sp)
    3d06:	f822                	sd	s0,48(sp)
    3d08:	f426                	sd	s1,40(sp)
    3d0a:	f04a                	sd	s2,32(sp)
    3d0c:	ec4e                	sd	s3,24(sp)
    3d0e:	e852                	sd	s4,16(sp)
    3d10:	e456                	sd	s5,8(sp)
    3d12:	e05a                	sd	s6,0(sp)
    3d14:	0080                	addi	s0,sp,64
    3d16:	8b2a                	mv	s6,a0
    3d18:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    3d1c:	00004a17          	auipc	s4,0x4
    3d20:	d74a0a13          	addi	s4,s4,-652 # 7a90 <malloc+0x1e96>
    mkdir("");
    3d24:	00004497          	auipc	s1,0x4
    3d28:	87c48493          	addi	s1,s1,-1924 # 75a0 <malloc+0x19a6>
    link("README", "");
    3d2c:	00002a97          	auipc	s5,0x2
    3d30:	4eca8a93          	addi	s5,s5,1260 # 6218 <malloc+0x61e>
    fd = open("xx", O_CREATE);
    3d34:	00004997          	auipc	s3,0x4
    3d38:	c5498993          	addi	s3,s3,-940 # 7988 <malloc+0x1d8e>
    3d3c:	a891                	j	3d90 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    3d3e:	85da                	mv	a1,s6
    3d40:	00004517          	auipc	a0,0x4
    3d44:	d5850513          	addi	a0,a0,-680 # 7a98 <malloc+0x1e9e>
    3d48:	00002097          	auipc	ra,0x2
    3d4c:	df4080e7          	jalr	-524(ra) # 5b3c <printf>
      exit(1);
    3d50:	4505                	li	a0,1
    3d52:	00002097          	auipc	ra,0x2
    3d56:	a72080e7          	jalr	-1422(ra) # 57c4 <exit>
      printf("%s: chdir irefd failed\n", s);
    3d5a:	85da                	mv	a1,s6
    3d5c:	00004517          	auipc	a0,0x4
    3d60:	d5450513          	addi	a0,a0,-684 # 7ab0 <malloc+0x1eb6>
    3d64:	00002097          	auipc	ra,0x2
    3d68:	dd8080e7          	jalr	-552(ra) # 5b3c <printf>
      exit(1);
    3d6c:	4505                	li	a0,1
    3d6e:	00002097          	auipc	ra,0x2
    3d72:	a56080e7          	jalr	-1450(ra) # 57c4 <exit>
      close(fd);
    3d76:	00002097          	auipc	ra,0x2
    3d7a:	a76080e7          	jalr	-1418(ra) # 57ec <close>
    3d7e:	a889                	j	3dd0 <iref+0xce>
    unlink("xx");
    3d80:	854e                	mv	a0,s3
    3d82:	00002097          	auipc	ra,0x2
    3d86:	a92080e7          	jalr	-1390(ra) # 5814 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3d8a:	397d                	addiw	s2,s2,-1
    3d8c:	06090063          	beqz	s2,3dec <iref+0xea>
    if(mkdir("irefd") != 0){
    3d90:	8552                	mv	a0,s4
    3d92:	00002097          	auipc	ra,0x2
    3d96:	a9a080e7          	jalr	-1382(ra) # 582c <mkdir>
    3d9a:	f155                	bnez	a0,3d3e <iref+0x3c>
    if(chdir("irefd") != 0){
    3d9c:	8552                	mv	a0,s4
    3d9e:	00002097          	auipc	ra,0x2
    3da2:	a96080e7          	jalr	-1386(ra) # 5834 <chdir>
    3da6:	f955                	bnez	a0,3d5a <iref+0x58>
    mkdir("");
    3da8:	8526                	mv	a0,s1
    3daa:	00002097          	auipc	ra,0x2
    3dae:	a82080e7          	jalr	-1406(ra) # 582c <mkdir>
    link("README", "");
    3db2:	85a6                	mv	a1,s1
    3db4:	8556                	mv	a0,s5
    3db6:	00002097          	auipc	ra,0x2
    3dba:	a6e080e7          	jalr	-1426(ra) # 5824 <link>
    fd = open("", O_CREATE);
    3dbe:	20000593          	li	a1,512
    3dc2:	8526                	mv	a0,s1
    3dc4:	00002097          	auipc	ra,0x2
    3dc8:	a40080e7          	jalr	-1472(ra) # 5804 <open>
    if(fd >= 0)
    3dcc:	fa0555e3          	bgez	a0,3d76 <iref+0x74>
    fd = open("xx", O_CREATE);
    3dd0:	20000593          	li	a1,512
    3dd4:	854e                	mv	a0,s3
    3dd6:	00002097          	auipc	ra,0x2
    3dda:	a2e080e7          	jalr	-1490(ra) # 5804 <open>
    if(fd >= 0)
    3dde:	fa0541e3          	bltz	a0,3d80 <iref+0x7e>
      close(fd);
    3de2:	00002097          	auipc	ra,0x2
    3de6:	a0a080e7          	jalr	-1526(ra) # 57ec <close>
    3dea:	bf59                	j	3d80 <iref+0x7e>
    3dec:	03300493          	li	s1,51
    chdir("..");
    3df0:	00003997          	auipc	s3,0x3
    3df4:	4d098993          	addi	s3,s3,1232 # 72c0 <malloc+0x16c6>
    unlink("irefd");
    3df8:	00004917          	auipc	s2,0x4
    3dfc:	c9890913          	addi	s2,s2,-872 # 7a90 <malloc+0x1e96>
    chdir("..");
    3e00:	854e                	mv	a0,s3
    3e02:	00002097          	auipc	ra,0x2
    3e06:	a32080e7          	jalr	-1486(ra) # 5834 <chdir>
    unlink("irefd");
    3e0a:	854a                	mv	a0,s2
    3e0c:	00002097          	auipc	ra,0x2
    3e10:	a08080e7          	jalr	-1528(ra) # 5814 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3e14:	34fd                	addiw	s1,s1,-1
    3e16:	f4ed                	bnez	s1,3e00 <iref+0xfe>
  chdir("/");
    3e18:	00003517          	auipc	a0,0x3
    3e1c:	45050513          	addi	a0,a0,1104 # 7268 <malloc+0x166e>
    3e20:	00002097          	auipc	ra,0x2
    3e24:	a14080e7          	jalr	-1516(ra) # 5834 <chdir>
}
    3e28:	70e2                	ld	ra,56(sp)
    3e2a:	7442                	ld	s0,48(sp)
    3e2c:	74a2                	ld	s1,40(sp)
    3e2e:	7902                	ld	s2,32(sp)
    3e30:	69e2                	ld	s3,24(sp)
    3e32:	6a42                	ld	s4,16(sp)
    3e34:	6aa2                	ld	s5,8(sp)
    3e36:	6b02                	ld	s6,0(sp)
    3e38:	6121                	addi	sp,sp,64
    3e3a:	8082                	ret

0000000000003e3c <openiputtest>:
{
    3e3c:	7179                	addi	sp,sp,-48
    3e3e:	f406                	sd	ra,40(sp)
    3e40:	f022                	sd	s0,32(sp)
    3e42:	ec26                	sd	s1,24(sp)
    3e44:	1800                	addi	s0,sp,48
    3e46:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    3e48:	00004517          	auipc	a0,0x4
    3e4c:	c8050513          	addi	a0,a0,-896 # 7ac8 <malloc+0x1ece>
    3e50:	00002097          	auipc	ra,0x2
    3e54:	9dc080e7          	jalr	-1572(ra) # 582c <mkdir>
    3e58:	04054263          	bltz	a0,3e9c <openiputtest+0x60>
  pid = fork();
    3e5c:	00002097          	auipc	ra,0x2
    3e60:	960080e7          	jalr	-1696(ra) # 57bc <fork>
  if(pid < 0){
    3e64:	04054a63          	bltz	a0,3eb8 <openiputtest+0x7c>
  if(pid == 0){
    3e68:	e93d                	bnez	a0,3ede <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    3e6a:	4589                	li	a1,2
    3e6c:	00004517          	auipc	a0,0x4
    3e70:	c5c50513          	addi	a0,a0,-932 # 7ac8 <malloc+0x1ece>
    3e74:	00002097          	auipc	ra,0x2
    3e78:	990080e7          	jalr	-1648(ra) # 5804 <open>
    if(fd >= 0){
    3e7c:	04054c63          	bltz	a0,3ed4 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    3e80:	85a6                	mv	a1,s1
    3e82:	00004517          	auipc	a0,0x4
    3e86:	c6650513          	addi	a0,a0,-922 # 7ae8 <malloc+0x1eee>
    3e8a:	00002097          	auipc	ra,0x2
    3e8e:	cb2080e7          	jalr	-846(ra) # 5b3c <printf>
      exit(1);
    3e92:	4505                	li	a0,1
    3e94:	00002097          	auipc	ra,0x2
    3e98:	930080e7          	jalr	-1744(ra) # 57c4 <exit>
    printf("%s: mkdir oidir failed\n", s);
    3e9c:	85a6                	mv	a1,s1
    3e9e:	00004517          	auipc	a0,0x4
    3ea2:	c3250513          	addi	a0,a0,-974 # 7ad0 <malloc+0x1ed6>
    3ea6:	00002097          	auipc	ra,0x2
    3eaa:	c96080e7          	jalr	-874(ra) # 5b3c <printf>
    exit(1);
    3eae:	4505                	li	a0,1
    3eb0:	00002097          	auipc	ra,0x2
    3eb4:	914080e7          	jalr	-1772(ra) # 57c4 <exit>
    printf("%s: fork failed\n", s);
    3eb8:	85a6                	mv	a1,s1
    3eba:	00003517          	auipc	a0,0x3
    3ebe:	9fe50513          	addi	a0,a0,-1538 # 68b8 <malloc+0xcbe>
    3ec2:	00002097          	auipc	ra,0x2
    3ec6:	c7a080e7          	jalr	-902(ra) # 5b3c <printf>
    exit(1);
    3eca:	4505                	li	a0,1
    3ecc:	00002097          	auipc	ra,0x2
    3ed0:	8f8080e7          	jalr	-1800(ra) # 57c4 <exit>
    exit(0);
    3ed4:	4501                	li	a0,0
    3ed6:	00002097          	auipc	ra,0x2
    3eda:	8ee080e7          	jalr	-1810(ra) # 57c4 <exit>
  sleep(1);
    3ede:	4505                	li	a0,1
    3ee0:	00002097          	auipc	ra,0x2
    3ee4:	974080e7          	jalr	-1676(ra) # 5854 <sleep>
  if(unlink("oidir") != 0){
    3ee8:	00004517          	auipc	a0,0x4
    3eec:	be050513          	addi	a0,a0,-1056 # 7ac8 <malloc+0x1ece>
    3ef0:	00002097          	auipc	ra,0x2
    3ef4:	924080e7          	jalr	-1756(ra) # 5814 <unlink>
    3ef8:	cd19                	beqz	a0,3f16 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    3efa:	85a6                	mv	a1,s1
    3efc:	00003517          	auipc	a0,0x3
    3f00:	bac50513          	addi	a0,a0,-1108 # 6aa8 <malloc+0xeae>
    3f04:	00002097          	auipc	ra,0x2
    3f08:	c38080e7          	jalr	-968(ra) # 5b3c <printf>
    exit(1);
    3f0c:	4505                	li	a0,1
    3f0e:	00002097          	auipc	ra,0x2
    3f12:	8b6080e7          	jalr	-1866(ra) # 57c4 <exit>
  wait(&xstatus);
    3f16:	fdc40513          	addi	a0,s0,-36
    3f1a:	00002097          	auipc	ra,0x2
    3f1e:	8b2080e7          	jalr	-1870(ra) # 57cc <wait>
  exit(xstatus);
    3f22:	fdc42503          	lw	a0,-36(s0)
    3f26:	00002097          	auipc	ra,0x2
    3f2a:	89e080e7          	jalr	-1890(ra) # 57c4 <exit>

0000000000003f2e <forkforkfork>:
{
    3f2e:	1101                	addi	sp,sp,-32
    3f30:	ec06                	sd	ra,24(sp)
    3f32:	e822                	sd	s0,16(sp)
    3f34:	e426                	sd	s1,8(sp)
    3f36:	1000                	addi	s0,sp,32
    3f38:	84aa                	mv	s1,a0
  unlink("stopforking");
    3f3a:	00004517          	auipc	a0,0x4
    3f3e:	bd650513          	addi	a0,a0,-1066 # 7b10 <malloc+0x1f16>
    3f42:	00002097          	auipc	ra,0x2
    3f46:	8d2080e7          	jalr	-1838(ra) # 5814 <unlink>
  int pid = fork();
    3f4a:	00002097          	auipc	ra,0x2
    3f4e:	872080e7          	jalr	-1934(ra) # 57bc <fork>
  if(pid < 0){
    3f52:	04054563          	bltz	a0,3f9c <forkforkfork+0x6e>
  if(pid == 0){
    3f56:	c12d                	beqz	a0,3fb8 <forkforkfork+0x8a>
  sleep(20); // two seconds
    3f58:	4551                	li	a0,20
    3f5a:	00002097          	auipc	ra,0x2
    3f5e:	8fa080e7          	jalr	-1798(ra) # 5854 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    3f62:	20200593          	li	a1,514
    3f66:	00004517          	auipc	a0,0x4
    3f6a:	baa50513          	addi	a0,a0,-1110 # 7b10 <malloc+0x1f16>
    3f6e:	00002097          	auipc	ra,0x2
    3f72:	896080e7          	jalr	-1898(ra) # 5804 <open>
    3f76:	00002097          	auipc	ra,0x2
    3f7a:	876080e7          	jalr	-1930(ra) # 57ec <close>
  wait(0);
    3f7e:	4501                	li	a0,0
    3f80:	00002097          	auipc	ra,0x2
    3f84:	84c080e7          	jalr	-1972(ra) # 57cc <wait>
  sleep(10); // one second
    3f88:	4529                	li	a0,10
    3f8a:	00002097          	auipc	ra,0x2
    3f8e:	8ca080e7          	jalr	-1846(ra) # 5854 <sleep>
}
    3f92:	60e2                	ld	ra,24(sp)
    3f94:	6442                	ld	s0,16(sp)
    3f96:	64a2                	ld	s1,8(sp)
    3f98:	6105                	addi	sp,sp,32
    3f9a:	8082                	ret
    printf("%s: fork failed", s);
    3f9c:	85a6                	mv	a1,s1
    3f9e:	00003517          	auipc	a0,0x3
    3fa2:	ada50513          	addi	a0,a0,-1318 # 6a78 <malloc+0xe7e>
    3fa6:	00002097          	auipc	ra,0x2
    3faa:	b96080e7          	jalr	-1130(ra) # 5b3c <printf>
    exit(1);
    3fae:	4505                	li	a0,1
    3fb0:	00002097          	auipc	ra,0x2
    3fb4:	814080e7          	jalr	-2028(ra) # 57c4 <exit>
      int fd = open("stopforking", 0);
    3fb8:	00004497          	auipc	s1,0x4
    3fbc:	b5848493          	addi	s1,s1,-1192 # 7b10 <malloc+0x1f16>
    3fc0:	4581                	li	a1,0
    3fc2:	8526                	mv	a0,s1
    3fc4:	00002097          	auipc	ra,0x2
    3fc8:	840080e7          	jalr	-1984(ra) # 5804 <open>
      if(fd >= 0){
    3fcc:	02055463          	bgez	a0,3ff4 <forkforkfork+0xc6>
      if(fork() < 0){
    3fd0:	00001097          	auipc	ra,0x1
    3fd4:	7ec080e7          	jalr	2028(ra) # 57bc <fork>
    3fd8:	fe0554e3          	bgez	a0,3fc0 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    3fdc:	20200593          	li	a1,514
    3fe0:	8526                	mv	a0,s1
    3fe2:	00002097          	auipc	ra,0x2
    3fe6:	822080e7          	jalr	-2014(ra) # 5804 <open>
    3fea:	00002097          	auipc	ra,0x2
    3fee:	802080e7          	jalr	-2046(ra) # 57ec <close>
    3ff2:	b7f9                	j	3fc0 <forkforkfork+0x92>
        exit(0);
    3ff4:	4501                	li	a0,0
    3ff6:	00001097          	auipc	ra,0x1
    3ffa:	7ce080e7          	jalr	1998(ra) # 57c4 <exit>

0000000000003ffe <killstatus>:
{
    3ffe:	7139                	addi	sp,sp,-64
    4000:	fc06                	sd	ra,56(sp)
    4002:	f822                	sd	s0,48(sp)
    4004:	f426                	sd	s1,40(sp)
    4006:	f04a                	sd	s2,32(sp)
    4008:	ec4e                	sd	s3,24(sp)
    400a:	e852                	sd	s4,16(sp)
    400c:	0080                	addi	s0,sp,64
    400e:	8a2a                	mv	s4,a0
    4010:	06400913          	li	s2,100
    if(xst != -1) {
    4014:	59fd                	li	s3,-1
    int pid1 = fork();
    4016:	00001097          	auipc	ra,0x1
    401a:	7a6080e7          	jalr	1958(ra) # 57bc <fork>
    401e:	84aa                	mv	s1,a0
    if(pid1 < 0){
    4020:	02054f63          	bltz	a0,405e <killstatus+0x60>
    if(pid1 == 0){
    4024:	c939                	beqz	a0,407a <killstatus+0x7c>
    sleep(1);
    4026:	4505                	li	a0,1
    4028:	00002097          	auipc	ra,0x2
    402c:	82c080e7          	jalr	-2004(ra) # 5854 <sleep>
    kill(pid1);
    4030:	8526                	mv	a0,s1
    4032:	00001097          	auipc	ra,0x1
    4036:	7c2080e7          	jalr	1986(ra) # 57f4 <kill>
    wait(&xst);
    403a:	fcc40513          	addi	a0,s0,-52
    403e:	00001097          	auipc	ra,0x1
    4042:	78e080e7          	jalr	1934(ra) # 57cc <wait>
    if(xst != -1) {
    4046:	fcc42783          	lw	a5,-52(s0)
    404a:	03379d63          	bne	a5,s3,4084 <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    404e:	397d                	addiw	s2,s2,-1
    4050:	fc0913e3          	bnez	s2,4016 <killstatus+0x18>
  exit(0);
    4054:	4501                	li	a0,0
    4056:	00001097          	auipc	ra,0x1
    405a:	76e080e7          	jalr	1902(ra) # 57c4 <exit>
      printf("%s: fork failed\n", s);
    405e:	85d2                	mv	a1,s4
    4060:	00003517          	auipc	a0,0x3
    4064:	85850513          	addi	a0,a0,-1960 # 68b8 <malloc+0xcbe>
    4068:	00002097          	auipc	ra,0x2
    406c:	ad4080e7          	jalr	-1324(ra) # 5b3c <printf>
      exit(1);
    4070:	4505                	li	a0,1
    4072:	00001097          	auipc	ra,0x1
    4076:	752080e7          	jalr	1874(ra) # 57c4 <exit>
        getpid();
    407a:	00001097          	auipc	ra,0x1
    407e:	7ca080e7          	jalr	1994(ra) # 5844 <getpid>
      while(1) {
    4082:	bfe5                	j	407a <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    4084:	85d2                	mv	a1,s4
    4086:	00004517          	auipc	a0,0x4
    408a:	a9a50513          	addi	a0,a0,-1382 # 7b20 <malloc+0x1f26>
    408e:	00002097          	auipc	ra,0x2
    4092:	aae080e7          	jalr	-1362(ra) # 5b3c <printf>
       exit(1);
    4096:	4505                	li	a0,1
    4098:	00001097          	auipc	ra,0x1
    409c:	72c080e7          	jalr	1836(ra) # 57c4 <exit>

00000000000040a0 <preempt>:
{
    40a0:	7139                	addi	sp,sp,-64
    40a2:	fc06                	sd	ra,56(sp)
    40a4:	f822                	sd	s0,48(sp)
    40a6:	f426                	sd	s1,40(sp)
    40a8:	f04a                	sd	s2,32(sp)
    40aa:	ec4e                	sd	s3,24(sp)
    40ac:	e852                	sd	s4,16(sp)
    40ae:	0080                	addi	s0,sp,64
    40b0:	84aa                	mv	s1,a0
  pid1 = fork();
    40b2:	00001097          	auipc	ra,0x1
    40b6:	70a080e7          	jalr	1802(ra) # 57bc <fork>
  if(pid1 < 0) {
    40ba:	00054563          	bltz	a0,40c4 <preempt+0x24>
    40be:	8a2a                	mv	s4,a0
  if(pid1 == 0)
    40c0:	e105                	bnez	a0,40e0 <preempt+0x40>
    for(;;)
    40c2:	a001                	j	40c2 <preempt+0x22>
    printf("%s: fork failed", s);
    40c4:	85a6                	mv	a1,s1
    40c6:	00003517          	auipc	a0,0x3
    40ca:	9b250513          	addi	a0,a0,-1614 # 6a78 <malloc+0xe7e>
    40ce:	00002097          	auipc	ra,0x2
    40d2:	a6e080e7          	jalr	-1426(ra) # 5b3c <printf>
    exit(1);
    40d6:	4505                	li	a0,1
    40d8:	00001097          	auipc	ra,0x1
    40dc:	6ec080e7          	jalr	1772(ra) # 57c4 <exit>
  pid2 = fork();
    40e0:	00001097          	auipc	ra,0x1
    40e4:	6dc080e7          	jalr	1756(ra) # 57bc <fork>
    40e8:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    40ea:	00054463          	bltz	a0,40f2 <preempt+0x52>
  if(pid2 == 0)
    40ee:	e105                	bnez	a0,410e <preempt+0x6e>
    for(;;)
    40f0:	a001                	j	40f0 <preempt+0x50>
    printf("%s: fork failed\n", s);
    40f2:	85a6                	mv	a1,s1
    40f4:	00002517          	auipc	a0,0x2
    40f8:	7c450513          	addi	a0,a0,1988 # 68b8 <malloc+0xcbe>
    40fc:	00002097          	auipc	ra,0x2
    4100:	a40080e7          	jalr	-1472(ra) # 5b3c <printf>
    exit(1);
    4104:	4505                	li	a0,1
    4106:	00001097          	auipc	ra,0x1
    410a:	6be080e7          	jalr	1726(ra) # 57c4 <exit>
  pipe(pfds);
    410e:	fc840513          	addi	a0,s0,-56
    4112:	00001097          	auipc	ra,0x1
    4116:	6c2080e7          	jalr	1730(ra) # 57d4 <pipe>
  pid3 = fork();
    411a:	00001097          	auipc	ra,0x1
    411e:	6a2080e7          	jalr	1698(ra) # 57bc <fork>
    4122:	892a                	mv	s2,a0
  if(pid3 < 0) {
    4124:	02054e63          	bltz	a0,4160 <preempt+0xc0>
  if(pid3 == 0){
    4128:	e525                	bnez	a0,4190 <preempt+0xf0>
    close(pfds[0]);
    412a:	fc842503          	lw	a0,-56(s0)
    412e:	00001097          	auipc	ra,0x1
    4132:	6be080e7          	jalr	1726(ra) # 57ec <close>
    if(write(pfds[1], "x", 1) != 1)
    4136:	4605                	li	a2,1
    4138:	00002597          	auipc	a1,0x2
    413c:	fb858593          	addi	a1,a1,-72 # 60f0 <malloc+0x4f6>
    4140:	fcc42503          	lw	a0,-52(s0)
    4144:	00001097          	auipc	ra,0x1
    4148:	6a0080e7          	jalr	1696(ra) # 57e4 <write>
    414c:	4785                	li	a5,1
    414e:	02f51763          	bne	a0,a5,417c <preempt+0xdc>
    close(pfds[1]);
    4152:	fcc42503          	lw	a0,-52(s0)
    4156:	00001097          	auipc	ra,0x1
    415a:	696080e7          	jalr	1686(ra) # 57ec <close>
    for(;;)
    415e:	a001                	j	415e <preempt+0xbe>
     printf("%s: fork failed\n", s);
    4160:	85a6                	mv	a1,s1
    4162:	00002517          	auipc	a0,0x2
    4166:	75650513          	addi	a0,a0,1878 # 68b8 <malloc+0xcbe>
    416a:	00002097          	auipc	ra,0x2
    416e:	9d2080e7          	jalr	-1582(ra) # 5b3c <printf>
     exit(1);
    4172:	4505                	li	a0,1
    4174:	00001097          	auipc	ra,0x1
    4178:	650080e7          	jalr	1616(ra) # 57c4 <exit>
      printf("%s: preempt write error", s);
    417c:	85a6                	mv	a1,s1
    417e:	00004517          	auipc	a0,0x4
    4182:	9c250513          	addi	a0,a0,-1598 # 7b40 <malloc+0x1f46>
    4186:	00002097          	auipc	ra,0x2
    418a:	9b6080e7          	jalr	-1610(ra) # 5b3c <printf>
    418e:	b7d1                	j	4152 <preempt+0xb2>
  close(pfds[1]);
    4190:	fcc42503          	lw	a0,-52(s0)
    4194:	00001097          	auipc	ra,0x1
    4198:	658080e7          	jalr	1624(ra) # 57ec <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    419c:	660d                	lui	a2,0x3
    419e:	00008597          	auipc	a1,0x8
    41a2:	b5258593          	addi	a1,a1,-1198 # bcf0 <buf>
    41a6:	fc842503          	lw	a0,-56(s0)
    41aa:	00001097          	auipc	ra,0x1
    41ae:	632080e7          	jalr	1586(ra) # 57dc <read>
    41b2:	4785                	li	a5,1
    41b4:	02f50363          	beq	a0,a5,41da <preempt+0x13a>
    printf("%s: preempt read error", s);
    41b8:	85a6                	mv	a1,s1
    41ba:	00004517          	auipc	a0,0x4
    41be:	99e50513          	addi	a0,a0,-1634 # 7b58 <malloc+0x1f5e>
    41c2:	00002097          	auipc	ra,0x2
    41c6:	97a080e7          	jalr	-1670(ra) # 5b3c <printf>
}
    41ca:	70e2                	ld	ra,56(sp)
    41cc:	7442                	ld	s0,48(sp)
    41ce:	74a2                	ld	s1,40(sp)
    41d0:	7902                	ld	s2,32(sp)
    41d2:	69e2                	ld	s3,24(sp)
    41d4:	6a42                	ld	s4,16(sp)
    41d6:	6121                	addi	sp,sp,64
    41d8:	8082                	ret
  close(pfds[0]);
    41da:	fc842503          	lw	a0,-56(s0)
    41de:	00001097          	auipc	ra,0x1
    41e2:	60e080e7          	jalr	1550(ra) # 57ec <close>
  printf("kill... ");
    41e6:	00004517          	auipc	a0,0x4
    41ea:	98a50513          	addi	a0,a0,-1654 # 7b70 <malloc+0x1f76>
    41ee:	00002097          	auipc	ra,0x2
    41f2:	94e080e7          	jalr	-1714(ra) # 5b3c <printf>
  kill(pid1);
    41f6:	8552                	mv	a0,s4
    41f8:	00001097          	auipc	ra,0x1
    41fc:	5fc080e7          	jalr	1532(ra) # 57f4 <kill>
  kill(pid2);
    4200:	854e                	mv	a0,s3
    4202:	00001097          	auipc	ra,0x1
    4206:	5f2080e7          	jalr	1522(ra) # 57f4 <kill>
  kill(pid3);
    420a:	854a                	mv	a0,s2
    420c:	00001097          	auipc	ra,0x1
    4210:	5e8080e7          	jalr	1512(ra) # 57f4 <kill>
  printf("wait... ");
    4214:	00004517          	auipc	a0,0x4
    4218:	96c50513          	addi	a0,a0,-1684 # 7b80 <malloc+0x1f86>
    421c:	00002097          	auipc	ra,0x2
    4220:	920080e7          	jalr	-1760(ra) # 5b3c <printf>
  wait(0);
    4224:	4501                	li	a0,0
    4226:	00001097          	auipc	ra,0x1
    422a:	5a6080e7          	jalr	1446(ra) # 57cc <wait>
  wait(0);
    422e:	4501                	li	a0,0
    4230:	00001097          	auipc	ra,0x1
    4234:	59c080e7          	jalr	1436(ra) # 57cc <wait>
  wait(0);
    4238:	4501                	li	a0,0
    423a:	00001097          	auipc	ra,0x1
    423e:	592080e7          	jalr	1426(ra) # 57cc <wait>
    4242:	b761                	j	41ca <preempt+0x12a>

0000000000004244 <reparent>:
{
    4244:	7179                	addi	sp,sp,-48
    4246:	f406                	sd	ra,40(sp)
    4248:	f022                	sd	s0,32(sp)
    424a:	ec26                	sd	s1,24(sp)
    424c:	e84a                	sd	s2,16(sp)
    424e:	e44e                	sd	s3,8(sp)
    4250:	e052                	sd	s4,0(sp)
    4252:	1800                	addi	s0,sp,48
    4254:	89aa                	mv	s3,a0
  int master_pid = getpid();
    4256:	00001097          	auipc	ra,0x1
    425a:	5ee080e7          	jalr	1518(ra) # 5844 <getpid>
    425e:	8a2a                	mv	s4,a0
    4260:	0c800913          	li	s2,200
    int pid = fork();
    4264:	00001097          	auipc	ra,0x1
    4268:	558080e7          	jalr	1368(ra) # 57bc <fork>
    426c:	84aa                	mv	s1,a0
    if(pid < 0){
    426e:	02054263          	bltz	a0,4292 <reparent+0x4e>
    if(pid){
    4272:	cd21                	beqz	a0,42ca <reparent+0x86>
      if(wait(0) != pid){
    4274:	4501                	li	a0,0
    4276:	00001097          	auipc	ra,0x1
    427a:	556080e7          	jalr	1366(ra) # 57cc <wait>
    427e:	02951863          	bne	a0,s1,42ae <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    4282:	397d                	addiw	s2,s2,-1
    4284:	fe0910e3          	bnez	s2,4264 <reparent+0x20>
  exit(0);
    4288:	4501                	li	a0,0
    428a:	00001097          	auipc	ra,0x1
    428e:	53a080e7          	jalr	1338(ra) # 57c4 <exit>
      printf("%s: fork failed\n", s);
    4292:	85ce                	mv	a1,s3
    4294:	00002517          	auipc	a0,0x2
    4298:	62450513          	addi	a0,a0,1572 # 68b8 <malloc+0xcbe>
    429c:	00002097          	auipc	ra,0x2
    42a0:	8a0080e7          	jalr	-1888(ra) # 5b3c <printf>
      exit(1);
    42a4:	4505                	li	a0,1
    42a6:	00001097          	auipc	ra,0x1
    42aa:	51e080e7          	jalr	1310(ra) # 57c4 <exit>
        printf("%s: wait wrong pid\n", s);
    42ae:	85ce                	mv	a1,s3
    42b0:	00002517          	auipc	a0,0x2
    42b4:	79050513          	addi	a0,a0,1936 # 6a40 <malloc+0xe46>
    42b8:	00002097          	auipc	ra,0x2
    42bc:	884080e7          	jalr	-1916(ra) # 5b3c <printf>
        exit(1);
    42c0:	4505                	li	a0,1
    42c2:	00001097          	auipc	ra,0x1
    42c6:	502080e7          	jalr	1282(ra) # 57c4 <exit>
      int pid2 = fork();
    42ca:	00001097          	auipc	ra,0x1
    42ce:	4f2080e7          	jalr	1266(ra) # 57bc <fork>
      if(pid2 < 0){
    42d2:	00054763          	bltz	a0,42e0 <reparent+0x9c>
      exit(0);
    42d6:	4501                	li	a0,0
    42d8:	00001097          	auipc	ra,0x1
    42dc:	4ec080e7          	jalr	1260(ra) # 57c4 <exit>
        kill(master_pid);
    42e0:	8552                	mv	a0,s4
    42e2:	00001097          	auipc	ra,0x1
    42e6:	512080e7          	jalr	1298(ra) # 57f4 <kill>
        exit(1);
    42ea:	4505                	li	a0,1
    42ec:	00001097          	auipc	ra,0x1
    42f0:	4d8080e7          	jalr	1240(ra) # 57c4 <exit>

00000000000042f4 <sbrkfail>:
{
    42f4:	7119                	addi	sp,sp,-128
    42f6:	fc86                	sd	ra,120(sp)
    42f8:	f8a2                	sd	s0,112(sp)
    42fa:	f4a6                	sd	s1,104(sp)
    42fc:	f0ca                	sd	s2,96(sp)
    42fe:	ecce                	sd	s3,88(sp)
    4300:	e8d2                	sd	s4,80(sp)
    4302:	e4d6                	sd	s5,72(sp)
    4304:	0100                	addi	s0,sp,128
    4306:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    4308:	fb040513          	addi	a0,s0,-80
    430c:	00001097          	auipc	ra,0x1
    4310:	4c8080e7          	jalr	1224(ra) # 57d4 <pipe>
    4314:	e901                	bnez	a0,4324 <sbrkfail+0x30>
    4316:	f8040493          	addi	s1,s0,-128
    431a:	fa840a13          	addi	s4,s0,-88
    431e:	89a6                	mv	s3,s1
    if(pids[i] != -1)
    4320:	5afd                	li	s5,-1
    4322:	a08d                	j	4384 <sbrkfail+0x90>
    printf("%s: pipe() failed\n", s);
    4324:	85ca                	mv	a1,s2
    4326:	00002517          	auipc	a0,0x2
    432a:	69a50513          	addi	a0,a0,1690 # 69c0 <malloc+0xdc6>
    432e:	00002097          	auipc	ra,0x2
    4332:	80e080e7          	jalr	-2034(ra) # 5b3c <printf>
    exit(1);
    4336:	4505                	li	a0,1
    4338:	00001097          	auipc	ra,0x1
    433c:	48c080e7          	jalr	1164(ra) # 57c4 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    4340:	4501                	li	a0,0
    4342:	00001097          	auipc	ra,0x1
    4346:	50a080e7          	jalr	1290(ra) # 584c <sbrk>
    434a:	064007b7          	lui	a5,0x6400
    434e:	40a7853b          	subw	a0,a5,a0
    4352:	00001097          	auipc	ra,0x1
    4356:	4fa080e7          	jalr	1274(ra) # 584c <sbrk>
      write(fds[1], "x", 1);
    435a:	4605                	li	a2,1
    435c:	00002597          	auipc	a1,0x2
    4360:	d9458593          	addi	a1,a1,-620 # 60f0 <malloc+0x4f6>
    4364:	fb442503          	lw	a0,-76(s0)
    4368:	00001097          	auipc	ra,0x1
    436c:	47c080e7          	jalr	1148(ra) # 57e4 <write>
      for(;;) sleep(1000);
    4370:	3e800513          	li	a0,1000
    4374:	00001097          	auipc	ra,0x1
    4378:	4e0080e7          	jalr	1248(ra) # 5854 <sleep>
    437c:	bfd5                	j	4370 <sbrkfail+0x7c>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    437e:	0991                	addi	s3,s3,4
    4380:	03498563          	beq	s3,s4,43aa <sbrkfail+0xb6>
    if((pids[i] = fork()) == 0){
    4384:	00001097          	auipc	ra,0x1
    4388:	438080e7          	jalr	1080(ra) # 57bc <fork>
    438c:	00a9a023          	sw	a0,0(s3)
    4390:	d945                	beqz	a0,4340 <sbrkfail+0x4c>
    if(pids[i] != -1)
    4392:	ff5506e3          	beq	a0,s5,437e <sbrkfail+0x8a>
      read(fds[0], &scratch, 1);
    4396:	4605                	li	a2,1
    4398:	faf40593          	addi	a1,s0,-81
    439c:	fb042503          	lw	a0,-80(s0)
    43a0:	00001097          	auipc	ra,0x1
    43a4:	43c080e7          	jalr	1084(ra) # 57dc <read>
    43a8:	bfd9                	j	437e <sbrkfail+0x8a>
  c = sbrk(PGSIZE);
    43aa:	6505                	lui	a0,0x1
    43ac:	00001097          	auipc	ra,0x1
    43b0:	4a0080e7          	jalr	1184(ra) # 584c <sbrk>
    43b4:	89aa                	mv	s3,a0
    if(pids[i] == -1)
    43b6:	5afd                	li	s5,-1
    43b8:	a021                	j	43c0 <sbrkfail+0xcc>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    43ba:	0491                	addi	s1,s1,4
    43bc:	01448f63          	beq	s1,s4,43da <sbrkfail+0xe6>
    if(pids[i] == -1)
    43c0:	4088                	lw	a0,0(s1)
    43c2:	ff550ce3          	beq	a0,s5,43ba <sbrkfail+0xc6>
    kill(pids[i]);
    43c6:	00001097          	auipc	ra,0x1
    43ca:	42e080e7          	jalr	1070(ra) # 57f4 <kill>
    wait(0);
    43ce:	4501                	li	a0,0
    43d0:	00001097          	auipc	ra,0x1
    43d4:	3fc080e7          	jalr	1020(ra) # 57cc <wait>
    43d8:	b7cd                	j	43ba <sbrkfail+0xc6>
  if(c == (char*)0xffffffffffffffffL){
    43da:	57fd                	li	a5,-1
    43dc:	04f98163          	beq	s3,a5,441e <sbrkfail+0x12a>
  pid = fork();
    43e0:	00001097          	auipc	ra,0x1
    43e4:	3dc080e7          	jalr	988(ra) # 57bc <fork>
    43e8:	84aa                	mv	s1,a0
  if(pid < 0){
    43ea:	04054863          	bltz	a0,443a <sbrkfail+0x146>
  if(pid == 0){
    43ee:	c525                	beqz	a0,4456 <sbrkfail+0x162>
  wait(&xstatus);
    43f0:	fbc40513          	addi	a0,s0,-68
    43f4:	00001097          	auipc	ra,0x1
    43f8:	3d8080e7          	jalr	984(ra) # 57cc <wait>
  if(xstatus != -1 && xstatus != 2)
    43fc:	fbc42783          	lw	a5,-68(s0)
    4400:	577d                	li	a4,-1
    4402:	00e78563          	beq	a5,a4,440c <sbrkfail+0x118>
    4406:	4709                	li	a4,2
    4408:	08e79d63          	bne	a5,a4,44a2 <sbrkfail+0x1ae>
}
    440c:	70e6                	ld	ra,120(sp)
    440e:	7446                	ld	s0,112(sp)
    4410:	74a6                	ld	s1,104(sp)
    4412:	7906                	ld	s2,96(sp)
    4414:	69e6                	ld	s3,88(sp)
    4416:	6a46                	ld	s4,80(sp)
    4418:	6aa6                	ld	s5,72(sp)
    441a:	6109                	addi	sp,sp,128
    441c:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    441e:	85ca                	mv	a1,s2
    4420:	00003517          	auipc	a0,0x3
    4424:	77050513          	addi	a0,a0,1904 # 7b90 <malloc+0x1f96>
    4428:	00001097          	auipc	ra,0x1
    442c:	714080e7          	jalr	1812(ra) # 5b3c <printf>
    exit(1);
    4430:	4505                	li	a0,1
    4432:	00001097          	auipc	ra,0x1
    4436:	392080e7          	jalr	914(ra) # 57c4 <exit>
    printf("%s: fork failed\n", s);
    443a:	85ca                	mv	a1,s2
    443c:	00002517          	auipc	a0,0x2
    4440:	47c50513          	addi	a0,a0,1148 # 68b8 <malloc+0xcbe>
    4444:	00001097          	auipc	ra,0x1
    4448:	6f8080e7          	jalr	1784(ra) # 5b3c <printf>
    exit(1);
    444c:	4505                	li	a0,1
    444e:	00001097          	auipc	ra,0x1
    4452:	376080e7          	jalr	886(ra) # 57c4 <exit>
    a = sbrk(0);
    4456:	4501                	li	a0,0
    4458:	00001097          	auipc	ra,0x1
    445c:	3f4080e7          	jalr	1012(ra) # 584c <sbrk>
    4460:	89aa                	mv	s3,a0
    sbrk(10*BIG);
    4462:	3e800537          	lui	a0,0x3e800
    4466:	00001097          	auipc	ra,0x1
    446a:	3e6080e7          	jalr	998(ra) # 584c <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    446e:	874e                	mv	a4,s3
    4470:	3e8007b7          	lui	a5,0x3e800
    4474:	97ce                	add	a5,a5,s3
    4476:	6685                	lui	a3,0x1
      n += *(a+i);
    4478:	00074603          	lbu	a2,0(a4)
    447c:	9cb1                	addw	s1,s1,a2
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    447e:	9736                	add	a4,a4,a3
    4480:	fef71ce3          	bne	a4,a5,4478 <sbrkfail+0x184>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    4484:	8626                	mv	a2,s1
    4486:	85ca                	mv	a1,s2
    4488:	00003517          	auipc	a0,0x3
    448c:	72850513          	addi	a0,a0,1832 # 7bb0 <malloc+0x1fb6>
    4490:	00001097          	auipc	ra,0x1
    4494:	6ac080e7          	jalr	1708(ra) # 5b3c <printf>
    exit(1);
    4498:	4505                	li	a0,1
    449a:	00001097          	auipc	ra,0x1
    449e:	32a080e7          	jalr	810(ra) # 57c4 <exit>
    exit(1);
    44a2:	4505                	li	a0,1
    44a4:	00001097          	auipc	ra,0x1
    44a8:	320080e7          	jalr	800(ra) # 57c4 <exit>

00000000000044ac <mem>:
{
    44ac:	7139                	addi	sp,sp,-64
    44ae:	fc06                	sd	ra,56(sp)
    44b0:	f822                	sd	s0,48(sp)
    44b2:	f426                	sd	s1,40(sp)
    44b4:	f04a                	sd	s2,32(sp)
    44b6:	ec4e                	sd	s3,24(sp)
    44b8:	0080                	addi	s0,sp,64
    44ba:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    44bc:	00001097          	auipc	ra,0x1
    44c0:	300080e7          	jalr	768(ra) # 57bc <fork>
    m1 = 0;
    44c4:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    44c6:	6909                	lui	s2,0x2
    44c8:	71190913          	addi	s2,s2,1809 # 2711 <sbrkbasic+0x139>
  if((pid = fork()) == 0){
    44cc:	ed39                	bnez	a0,452a <mem+0x7e>
    while((m2 = malloc(10001)) != 0){
    44ce:	854a                	mv	a0,s2
    44d0:	00001097          	auipc	ra,0x1
    44d4:	72a080e7          	jalr	1834(ra) # 5bfa <malloc>
    44d8:	c501                	beqz	a0,44e0 <mem+0x34>
      *(char**)m2 = m1;
    44da:	e104                	sd	s1,0(a0)
      m1 = m2;
    44dc:	84aa                	mv	s1,a0
    44de:	bfc5                	j	44ce <mem+0x22>
    while(m1){
    44e0:	c881                	beqz	s1,44f0 <mem+0x44>
      m2 = *(char**)m1;
    44e2:	8526                	mv	a0,s1
    44e4:	6084                	ld	s1,0(s1)
      free(m1);
    44e6:	00001097          	auipc	ra,0x1
    44ea:	68c080e7          	jalr	1676(ra) # 5b72 <free>
    while(m1){
    44ee:	f8f5                	bnez	s1,44e2 <mem+0x36>
    m1 = malloc(1024*20);
    44f0:	6515                	lui	a0,0x5
    44f2:	00001097          	auipc	ra,0x1
    44f6:	708080e7          	jalr	1800(ra) # 5bfa <malloc>
    if(m1 == 0){
    44fa:	c911                	beqz	a0,450e <mem+0x62>
    free(m1);
    44fc:	00001097          	auipc	ra,0x1
    4500:	676080e7          	jalr	1654(ra) # 5b72 <free>
    exit(0);
    4504:	4501                	li	a0,0
    4506:	00001097          	auipc	ra,0x1
    450a:	2be080e7          	jalr	702(ra) # 57c4 <exit>
      printf("couldn't allocate mem?!!\n", s);
    450e:	85ce                	mv	a1,s3
    4510:	00003517          	auipc	a0,0x3
    4514:	6d050513          	addi	a0,a0,1744 # 7be0 <malloc+0x1fe6>
    4518:	00001097          	auipc	ra,0x1
    451c:	624080e7          	jalr	1572(ra) # 5b3c <printf>
      exit(1);
    4520:	4505                	li	a0,1
    4522:	00001097          	auipc	ra,0x1
    4526:	2a2080e7          	jalr	674(ra) # 57c4 <exit>
    wait(&xstatus);
    452a:	fcc40513          	addi	a0,s0,-52
    452e:	00001097          	auipc	ra,0x1
    4532:	29e080e7          	jalr	670(ra) # 57cc <wait>
    if(xstatus == -1){
    4536:	fcc42503          	lw	a0,-52(s0)
    453a:	57fd                	li	a5,-1
    453c:	00f50663          	beq	a0,a5,4548 <mem+0x9c>
    exit(xstatus);
    4540:	00001097          	auipc	ra,0x1
    4544:	284080e7          	jalr	644(ra) # 57c4 <exit>
      exit(0);
    4548:	4501                	li	a0,0
    454a:	00001097          	auipc	ra,0x1
    454e:	27a080e7          	jalr	634(ra) # 57c4 <exit>

0000000000004552 <sharedfd>:
{
    4552:	7159                	addi	sp,sp,-112
    4554:	f486                	sd	ra,104(sp)
    4556:	f0a2                	sd	s0,96(sp)
    4558:	eca6                	sd	s1,88(sp)
    455a:	e8ca                	sd	s2,80(sp)
    455c:	e4ce                	sd	s3,72(sp)
    455e:	e0d2                	sd	s4,64(sp)
    4560:	fc56                	sd	s5,56(sp)
    4562:	f85a                	sd	s6,48(sp)
    4564:	f45e                	sd	s7,40(sp)
    4566:	1880                	addi	s0,sp,112
    4568:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    456a:	00002517          	auipc	a0,0x2
    456e:	91e50513          	addi	a0,a0,-1762 # 5e88 <malloc+0x28e>
    4572:	00001097          	auipc	ra,0x1
    4576:	2a2080e7          	jalr	674(ra) # 5814 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    457a:	20200593          	li	a1,514
    457e:	00002517          	auipc	a0,0x2
    4582:	90a50513          	addi	a0,a0,-1782 # 5e88 <malloc+0x28e>
    4586:	00001097          	auipc	ra,0x1
    458a:	27e080e7          	jalr	638(ra) # 5804 <open>
  if(fd < 0){
    458e:	04054a63          	bltz	a0,45e2 <sharedfd+0x90>
    4592:	892a                	mv	s2,a0
  pid = fork();
    4594:	00001097          	auipc	ra,0x1
    4598:	228080e7          	jalr	552(ra) # 57bc <fork>
    459c:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    459e:	06300593          	li	a1,99
    45a2:	c119                	beqz	a0,45a8 <sharedfd+0x56>
    45a4:	07000593          	li	a1,112
    45a8:	4629                	li	a2,10
    45aa:	fa040513          	addi	a0,s0,-96
    45ae:	00001097          	auipc	ra,0x1
    45b2:	012080e7          	jalr	18(ra) # 55c0 <memset>
    45b6:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    45ba:	4629                	li	a2,10
    45bc:	fa040593          	addi	a1,s0,-96
    45c0:	854a                	mv	a0,s2
    45c2:	00001097          	auipc	ra,0x1
    45c6:	222080e7          	jalr	546(ra) # 57e4 <write>
    45ca:	47a9                	li	a5,10
    45cc:	02f51963          	bne	a0,a5,45fe <sharedfd+0xac>
  for(i = 0; i < N; i++){
    45d0:	34fd                	addiw	s1,s1,-1
    45d2:	f4e5                	bnez	s1,45ba <sharedfd+0x68>
  if(pid == 0) {
    45d4:	04099363          	bnez	s3,461a <sharedfd+0xc8>
    exit(0);
    45d8:	4501                	li	a0,0
    45da:	00001097          	auipc	ra,0x1
    45de:	1ea080e7          	jalr	490(ra) # 57c4 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    45e2:	85d2                	mv	a1,s4
    45e4:	00003517          	auipc	a0,0x3
    45e8:	61c50513          	addi	a0,a0,1564 # 7c00 <malloc+0x2006>
    45ec:	00001097          	auipc	ra,0x1
    45f0:	550080e7          	jalr	1360(ra) # 5b3c <printf>
    exit(1);
    45f4:	4505                	li	a0,1
    45f6:	00001097          	auipc	ra,0x1
    45fa:	1ce080e7          	jalr	462(ra) # 57c4 <exit>
      printf("%s: write sharedfd failed\n", s);
    45fe:	85d2                	mv	a1,s4
    4600:	00003517          	auipc	a0,0x3
    4604:	62850513          	addi	a0,a0,1576 # 7c28 <malloc+0x202e>
    4608:	00001097          	auipc	ra,0x1
    460c:	534080e7          	jalr	1332(ra) # 5b3c <printf>
      exit(1);
    4610:	4505                	li	a0,1
    4612:	00001097          	auipc	ra,0x1
    4616:	1b2080e7          	jalr	434(ra) # 57c4 <exit>
    wait(&xstatus);
    461a:	f9c40513          	addi	a0,s0,-100
    461e:	00001097          	auipc	ra,0x1
    4622:	1ae080e7          	jalr	430(ra) # 57cc <wait>
    if(xstatus != 0)
    4626:	f9c42983          	lw	s3,-100(s0)
    462a:	00098763          	beqz	s3,4638 <sharedfd+0xe6>
      exit(xstatus);
    462e:	854e                	mv	a0,s3
    4630:	00001097          	auipc	ra,0x1
    4634:	194080e7          	jalr	404(ra) # 57c4 <exit>
  close(fd);
    4638:	854a                	mv	a0,s2
    463a:	00001097          	auipc	ra,0x1
    463e:	1b2080e7          	jalr	434(ra) # 57ec <close>
  fd = open("sharedfd", 0);
    4642:	4581                	li	a1,0
    4644:	00002517          	auipc	a0,0x2
    4648:	84450513          	addi	a0,a0,-1980 # 5e88 <malloc+0x28e>
    464c:	00001097          	auipc	ra,0x1
    4650:	1b8080e7          	jalr	440(ra) # 5804 <open>
    4654:	8baa                	mv	s7,a0
  nc = np = 0;
    4656:	8ace                	mv	s5,s3
  if(fd < 0){
    4658:	02054563          	bltz	a0,4682 <sharedfd+0x130>
    465c:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    4660:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4664:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4668:	4629                	li	a2,10
    466a:	fa040593          	addi	a1,s0,-96
    466e:	855e                	mv	a0,s7
    4670:	00001097          	auipc	ra,0x1
    4674:	16c080e7          	jalr	364(ra) # 57dc <read>
    4678:	02a05f63          	blez	a0,46b6 <sharedfd+0x164>
    467c:	fa040793          	addi	a5,s0,-96
    4680:	a01d                	j	46a6 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4682:	85d2                	mv	a1,s4
    4684:	00003517          	auipc	a0,0x3
    4688:	5c450513          	addi	a0,a0,1476 # 7c48 <malloc+0x204e>
    468c:	00001097          	auipc	ra,0x1
    4690:	4b0080e7          	jalr	1200(ra) # 5b3c <printf>
    exit(1);
    4694:	4505                	li	a0,1
    4696:	00001097          	auipc	ra,0x1
    469a:	12e080e7          	jalr	302(ra) # 57c4 <exit>
        nc++;
    469e:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    46a0:	0785                	addi	a5,a5,1
    46a2:	fd2783e3          	beq	a5,s2,4668 <sharedfd+0x116>
      if(buf[i] == 'c')
    46a6:	0007c703          	lbu	a4,0(a5) # 3e800000 <__BSS_END__+0x3e7f1300>
    46aa:	fe970ae3          	beq	a4,s1,469e <sharedfd+0x14c>
      if(buf[i] == 'p')
    46ae:	ff6719e3          	bne	a4,s6,46a0 <sharedfd+0x14e>
        np++;
    46b2:	2a85                	addiw	s5,s5,1
    46b4:	b7f5                	j	46a0 <sharedfd+0x14e>
  close(fd);
    46b6:	855e                	mv	a0,s7
    46b8:	00001097          	auipc	ra,0x1
    46bc:	134080e7          	jalr	308(ra) # 57ec <close>
  unlink("sharedfd");
    46c0:	00001517          	auipc	a0,0x1
    46c4:	7c850513          	addi	a0,a0,1992 # 5e88 <malloc+0x28e>
    46c8:	00001097          	auipc	ra,0x1
    46cc:	14c080e7          	jalr	332(ra) # 5814 <unlink>
  if(nc == N*SZ && np == N*SZ){
    46d0:	6789                	lui	a5,0x2
    46d2:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0x138>
    46d6:	00f99763          	bne	s3,a5,46e4 <sharedfd+0x192>
    46da:	6789                	lui	a5,0x2
    46dc:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0x138>
    46e0:	02fa8063          	beq	s5,a5,4700 <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    46e4:	85d2                	mv	a1,s4
    46e6:	00003517          	auipc	a0,0x3
    46ea:	58a50513          	addi	a0,a0,1418 # 7c70 <malloc+0x2076>
    46ee:	00001097          	auipc	ra,0x1
    46f2:	44e080e7          	jalr	1102(ra) # 5b3c <printf>
    exit(1);
    46f6:	4505                	li	a0,1
    46f8:	00001097          	auipc	ra,0x1
    46fc:	0cc080e7          	jalr	204(ra) # 57c4 <exit>
    exit(0);
    4700:	4501                	li	a0,0
    4702:	00001097          	auipc	ra,0x1
    4706:	0c2080e7          	jalr	194(ra) # 57c4 <exit>

000000000000470a <fourfiles>:
{
    470a:	7171                	addi	sp,sp,-176
    470c:	f506                	sd	ra,168(sp)
    470e:	f122                	sd	s0,160(sp)
    4710:	ed26                	sd	s1,152(sp)
    4712:	e94a                	sd	s2,144(sp)
    4714:	e54e                	sd	s3,136(sp)
    4716:	e152                	sd	s4,128(sp)
    4718:	fcd6                	sd	s5,120(sp)
    471a:	f8da                	sd	s6,112(sp)
    471c:	f4de                	sd	s7,104(sp)
    471e:	f0e2                	sd	s8,96(sp)
    4720:	ece6                	sd	s9,88(sp)
    4722:	e8ea                	sd	s10,80(sp)
    4724:	e4ee                	sd	s11,72(sp)
    4726:	1900                	addi	s0,sp,176
    4728:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    472a:	00001797          	auipc	a5,0x1
    472e:	5b678793          	addi	a5,a5,1462 # 5ce0 <malloc+0xe6>
    4732:	f6f43823          	sd	a5,-144(s0)
    4736:	00001797          	auipc	a5,0x1
    473a:	5b278793          	addi	a5,a5,1458 # 5ce8 <malloc+0xee>
    473e:	f6f43c23          	sd	a5,-136(s0)
    4742:	00001797          	auipc	a5,0x1
    4746:	5ae78793          	addi	a5,a5,1454 # 5cf0 <malloc+0xf6>
    474a:	f8f43023          	sd	a5,-128(s0)
    474e:	00001797          	auipc	a5,0x1
    4752:	5aa78793          	addi	a5,a5,1450 # 5cf8 <malloc+0xfe>
    4756:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    475a:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    475e:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    4760:	4481                	li	s1,0
    4762:	4a11                	li	s4,4
    fname = names[pi];
    4764:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4768:	854e                	mv	a0,s3
    476a:	00001097          	auipc	ra,0x1
    476e:	0aa080e7          	jalr	170(ra) # 5814 <unlink>
    pid = fork();
    4772:	00001097          	auipc	ra,0x1
    4776:	04a080e7          	jalr	74(ra) # 57bc <fork>
    if(pid < 0){
    477a:	04054563          	bltz	a0,47c4 <fourfiles+0xba>
    if(pid == 0){
    477e:	c12d                	beqz	a0,47e0 <fourfiles+0xd6>
  for(pi = 0; pi < NCHILD; pi++){
    4780:	2485                	addiw	s1,s1,1
    4782:	0921                	addi	s2,s2,8
    4784:	ff4490e3          	bne	s1,s4,4764 <fourfiles+0x5a>
    4788:	4491                	li	s1,4
    wait(&xstatus);
    478a:	f6c40513          	addi	a0,s0,-148
    478e:	00001097          	auipc	ra,0x1
    4792:	03e080e7          	jalr	62(ra) # 57cc <wait>
    if(xstatus != 0)
    4796:	f6c42503          	lw	a0,-148(s0)
    479a:	ed69                	bnez	a0,4874 <fourfiles+0x16a>
  for(pi = 0; pi < NCHILD; pi++){
    479c:	34fd                	addiw	s1,s1,-1
    479e:	f4f5                	bnez	s1,478a <fourfiles+0x80>
    47a0:	03000b13          	li	s6,48
    total = 0;
    47a4:	f4a43c23          	sd	a0,-168(s0)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    47a8:	00007a17          	auipc	s4,0x7
    47ac:	548a0a13          	addi	s4,s4,1352 # bcf0 <buf>
    47b0:	00007a97          	auipc	s5,0x7
    47b4:	541a8a93          	addi	s5,s5,1345 # bcf1 <buf+0x1>
    if(total != N*SZ){
    47b8:	6d05                	lui	s10,0x1
    47ba:	770d0d13          	addi	s10,s10,1904 # 1770 <pipe1+0x12>
  for(i = 0; i < NCHILD; i++){
    47be:	03400d93          	li	s11,52
    47c2:	a23d                	j	48f0 <fourfiles+0x1e6>
      printf("fork failed\n", s);
    47c4:	85e6                	mv	a1,s9
    47c6:	00002517          	auipc	a0,0x2
    47ca:	4fa50513          	addi	a0,a0,1274 # 6cc0 <malloc+0x10c6>
    47ce:	00001097          	auipc	ra,0x1
    47d2:	36e080e7          	jalr	878(ra) # 5b3c <printf>
      exit(1);
    47d6:	4505                	li	a0,1
    47d8:	00001097          	auipc	ra,0x1
    47dc:	fec080e7          	jalr	-20(ra) # 57c4 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    47e0:	20200593          	li	a1,514
    47e4:	854e                	mv	a0,s3
    47e6:	00001097          	auipc	ra,0x1
    47ea:	01e080e7          	jalr	30(ra) # 5804 <open>
    47ee:	892a                	mv	s2,a0
      if(fd < 0){
    47f0:	04054763          	bltz	a0,483e <fourfiles+0x134>
      memset(buf, '0'+pi, SZ);
    47f4:	1f400613          	li	a2,500
    47f8:	0304859b          	addiw	a1,s1,48
    47fc:	00007517          	auipc	a0,0x7
    4800:	4f450513          	addi	a0,a0,1268 # bcf0 <buf>
    4804:	00001097          	auipc	ra,0x1
    4808:	dbc080e7          	jalr	-580(ra) # 55c0 <memset>
    480c:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    480e:	00007997          	auipc	s3,0x7
    4812:	4e298993          	addi	s3,s3,1250 # bcf0 <buf>
    4816:	1f400613          	li	a2,500
    481a:	85ce                	mv	a1,s3
    481c:	854a                	mv	a0,s2
    481e:	00001097          	auipc	ra,0x1
    4822:	fc6080e7          	jalr	-58(ra) # 57e4 <write>
    4826:	85aa                	mv	a1,a0
    4828:	1f400793          	li	a5,500
    482c:	02f51763          	bne	a0,a5,485a <fourfiles+0x150>
      for(i = 0; i < N; i++){
    4830:	34fd                	addiw	s1,s1,-1
    4832:	f0f5                	bnez	s1,4816 <fourfiles+0x10c>
      exit(0);
    4834:	4501                	li	a0,0
    4836:	00001097          	auipc	ra,0x1
    483a:	f8e080e7          	jalr	-114(ra) # 57c4 <exit>
        printf("create failed\n", s);
    483e:	85e6                	mv	a1,s9
    4840:	00003517          	auipc	a0,0x3
    4844:	44850513          	addi	a0,a0,1096 # 7c88 <malloc+0x208e>
    4848:	00001097          	auipc	ra,0x1
    484c:	2f4080e7          	jalr	756(ra) # 5b3c <printf>
        exit(1);
    4850:	4505                	li	a0,1
    4852:	00001097          	auipc	ra,0x1
    4856:	f72080e7          	jalr	-142(ra) # 57c4 <exit>
          printf("write failed %d\n", n);
    485a:	00003517          	auipc	a0,0x3
    485e:	43e50513          	addi	a0,a0,1086 # 7c98 <malloc+0x209e>
    4862:	00001097          	auipc	ra,0x1
    4866:	2da080e7          	jalr	730(ra) # 5b3c <printf>
          exit(1);
    486a:	4505                	li	a0,1
    486c:	00001097          	auipc	ra,0x1
    4870:	f58080e7          	jalr	-168(ra) # 57c4 <exit>
      exit(xstatus);
    4874:	00001097          	auipc	ra,0x1
    4878:	f50080e7          	jalr	-176(ra) # 57c4 <exit>
          printf("wrong char\n", s);
    487c:	85e6                	mv	a1,s9
    487e:	00003517          	auipc	a0,0x3
    4882:	43250513          	addi	a0,a0,1074 # 7cb0 <malloc+0x20b6>
    4886:	00001097          	auipc	ra,0x1
    488a:	2b6080e7          	jalr	694(ra) # 5b3c <printf>
          exit(1);
    488e:	4505                	li	a0,1
    4890:	00001097          	auipc	ra,0x1
    4894:	f34080e7          	jalr	-204(ra) # 57c4 <exit>
      total += n;
    4898:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    489c:	660d                	lui	a2,0x3
    489e:	85d2                	mv	a1,s4
    48a0:	854e                	mv	a0,s3
    48a2:	00001097          	auipc	ra,0x1
    48a6:	f3a080e7          	jalr	-198(ra) # 57dc <read>
    48aa:	02a05363          	blez	a0,48d0 <fourfiles+0x1c6>
    48ae:	00007797          	auipc	a5,0x7
    48b2:	44278793          	addi	a5,a5,1090 # bcf0 <buf>
    48b6:	fff5069b          	addiw	a3,a0,-1
    48ba:	1682                	slli	a3,a3,0x20
    48bc:	9281                	srli	a3,a3,0x20
    48be:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    48c0:	0007c703          	lbu	a4,0(a5)
    48c4:	fa971ce3          	bne	a4,s1,487c <fourfiles+0x172>
      for(j = 0; j < n; j++){
    48c8:	0785                	addi	a5,a5,1
    48ca:	fed79be3          	bne	a5,a3,48c0 <fourfiles+0x1b6>
    48ce:	b7e9                	j	4898 <fourfiles+0x18e>
    close(fd);
    48d0:	854e                	mv	a0,s3
    48d2:	00001097          	auipc	ra,0x1
    48d6:	f1a080e7          	jalr	-230(ra) # 57ec <close>
    if(total != N*SZ){
    48da:	03a91963          	bne	s2,s10,490c <fourfiles+0x202>
    unlink(fname);
    48de:	8562                	mv	a0,s8
    48e0:	00001097          	auipc	ra,0x1
    48e4:	f34080e7          	jalr	-204(ra) # 5814 <unlink>
  for(i = 0; i < NCHILD; i++){
    48e8:	0ba1                	addi	s7,s7,8
    48ea:	2b05                	addiw	s6,s6,1
    48ec:	03bb0e63          	beq	s6,s11,4928 <fourfiles+0x21e>
    fname = names[i];
    48f0:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    48f4:	4581                	li	a1,0
    48f6:	8562                	mv	a0,s8
    48f8:	00001097          	auipc	ra,0x1
    48fc:	f0c080e7          	jalr	-244(ra) # 5804 <open>
    4900:	89aa                	mv	s3,a0
    total = 0;
    4902:	f5843903          	ld	s2,-168(s0)
        if(buf[j] != '0'+i){
    4906:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    490a:	bf49                	j	489c <fourfiles+0x192>
      printf("wrong length %d\n", total);
    490c:	85ca                	mv	a1,s2
    490e:	00003517          	auipc	a0,0x3
    4912:	3b250513          	addi	a0,a0,946 # 7cc0 <malloc+0x20c6>
    4916:	00001097          	auipc	ra,0x1
    491a:	226080e7          	jalr	550(ra) # 5b3c <printf>
      exit(1);
    491e:	4505                	li	a0,1
    4920:	00001097          	auipc	ra,0x1
    4924:	ea4080e7          	jalr	-348(ra) # 57c4 <exit>
}
    4928:	70aa                	ld	ra,168(sp)
    492a:	740a                	ld	s0,160(sp)
    492c:	64ea                	ld	s1,152(sp)
    492e:	694a                	ld	s2,144(sp)
    4930:	69aa                	ld	s3,136(sp)
    4932:	6a0a                	ld	s4,128(sp)
    4934:	7ae6                	ld	s5,120(sp)
    4936:	7b46                	ld	s6,112(sp)
    4938:	7ba6                	ld	s7,104(sp)
    493a:	7c06                	ld	s8,96(sp)
    493c:	6ce6                	ld	s9,88(sp)
    493e:	6d46                	ld	s10,80(sp)
    4940:	6da6                	ld	s11,72(sp)
    4942:	614d                	addi	sp,sp,176
    4944:	8082                	ret

0000000000004946 <concreate>:
{
    4946:	7135                	addi	sp,sp,-160
    4948:	ed06                	sd	ra,152(sp)
    494a:	e922                	sd	s0,144(sp)
    494c:	e526                	sd	s1,136(sp)
    494e:	e14a                	sd	s2,128(sp)
    4950:	fcce                	sd	s3,120(sp)
    4952:	f8d2                	sd	s4,112(sp)
    4954:	f4d6                	sd	s5,104(sp)
    4956:	f0da                	sd	s6,96(sp)
    4958:	ecde                	sd	s7,88(sp)
    495a:	1100                	addi	s0,sp,160
    495c:	89aa                	mv	s3,a0
  file[0] = 'C';
    495e:	04300793          	li	a5,67
    4962:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4966:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    496a:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    496c:	4b0d                	li	s6,3
    496e:	4a85                	li	s5,1
      link("C0", file);
    4970:	00003b97          	auipc	s7,0x3
    4974:	368b8b93          	addi	s7,s7,872 # 7cd8 <malloc+0x20de>
  for(i = 0; i < N; i++){
    4978:	02800a13          	li	s4,40
    497c:	acc1                	j	4c4c <concreate+0x306>
      link("C0", file);
    497e:	fa840593          	addi	a1,s0,-88
    4982:	855e                	mv	a0,s7
    4984:	00001097          	auipc	ra,0x1
    4988:	ea0080e7          	jalr	-352(ra) # 5824 <link>
    if(pid == 0) {
    498c:	a45d                	j	4c32 <concreate+0x2ec>
    } else if(pid == 0 && (i % 5) == 1){
    498e:	4795                	li	a5,5
    4990:	02f9693b          	remw	s2,s2,a5
    4994:	4785                	li	a5,1
    4996:	02f90b63          	beq	s2,a5,49cc <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    499a:	20200593          	li	a1,514
    499e:	fa840513          	addi	a0,s0,-88
    49a2:	00001097          	auipc	ra,0x1
    49a6:	e62080e7          	jalr	-414(ra) # 5804 <open>
      if(fd < 0){
    49aa:	26055b63          	bgez	a0,4c20 <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    49ae:	fa840593          	addi	a1,s0,-88
    49b2:	00003517          	auipc	a0,0x3
    49b6:	32e50513          	addi	a0,a0,814 # 7ce0 <malloc+0x20e6>
    49ba:	00001097          	auipc	ra,0x1
    49be:	182080e7          	jalr	386(ra) # 5b3c <printf>
        exit(1);
    49c2:	4505                	li	a0,1
    49c4:	00001097          	auipc	ra,0x1
    49c8:	e00080e7          	jalr	-512(ra) # 57c4 <exit>
      link("C0", file);
    49cc:	fa840593          	addi	a1,s0,-88
    49d0:	00003517          	auipc	a0,0x3
    49d4:	30850513          	addi	a0,a0,776 # 7cd8 <malloc+0x20de>
    49d8:	00001097          	auipc	ra,0x1
    49dc:	e4c080e7          	jalr	-436(ra) # 5824 <link>
      exit(0);
    49e0:	4501                	li	a0,0
    49e2:	00001097          	auipc	ra,0x1
    49e6:	de2080e7          	jalr	-542(ra) # 57c4 <exit>
        exit(1);
    49ea:	4505                	li	a0,1
    49ec:	00001097          	auipc	ra,0x1
    49f0:	dd8080e7          	jalr	-552(ra) # 57c4 <exit>
  memset(fa, 0, sizeof(fa));
    49f4:	02800613          	li	a2,40
    49f8:	4581                	li	a1,0
    49fa:	f8040513          	addi	a0,s0,-128
    49fe:	00001097          	auipc	ra,0x1
    4a02:	bc2080e7          	jalr	-1086(ra) # 55c0 <memset>
  fd = open(".", 0);
    4a06:	4581                	li	a1,0
    4a08:	00002517          	auipc	a0,0x2
    4a0c:	d1050513          	addi	a0,a0,-752 # 6718 <malloc+0xb1e>
    4a10:	00001097          	auipc	ra,0x1
    4a14:	df4080e7          	jalr	-524(ra) # 5804 <open>
    4a18:	892a                	mv	s2,a0
  n = 0;
    4a1a:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4a1c:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4a20:	02700b13          	li	s6,39
      fa[i] = 1;
    4a24:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4a26:	a03d                	j	4a54 <concreate+0x10e>
        printf("%s: concreate weird file %s\n", s, de.name);
    4a28:	f7240613          	addi	a2,s0,-142
    4a2c:	85ce                	mv	a1,s3
    4a2e:	00003517          	auipc	a0,0x3
    4a32:	2d250513          	addi	a0,a0,722 # 7d00 <malloc+0x2106>
    4a36:	00001097          	auipc	ra,0x1
    4a3a:	106080e7          	jalr	262(ra) # 5b3c <printf>
        exit(1);
    4a3e:	4505                	li	a0,1
    4a40:	00001097          	auipc	ra,0x1
    4a44:	d84080e7          	jalr	-636(ra) # 57c4 <exit>
      fa[i] = 1;
    4a48:	fb040793          	addi	a5,s0,-80
    4a4c:	973e                	add	a4,a4,a5
    4a4e:	fd770823          	sb	s7,-48(a4)
      n++;
    4a52:	2a85                	addiw	s5,s5,1
  while(read(fd, &de, sizeof(de)) > 0){
    4a54:	4641                	li	a2,16
    4a56:	f7040593          	addi	a1,s0,-144
    4a5a:	854a                	mv	a0,s2
    4a5c:	00001097          	auipc	ra,0x1
    4a60:	d80080e7          	jalr	-640(ra) # 57dc <read>
    4a64:	04a05a63          	blez	a0,4ab8 <concreate+0x172>
    if(de.inum == 0)
    4a68:	f7045783          	lhu	a5,-144(s0)
    4a6c:	d7e5                	beqz	a5,4a54 <concreate+0x10e>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4a6e:	f7244783          	lbu	a5,-142(s0)
    4a72:	ff4791e3          	bne	a5,s4,4a54 <concreate+0x10e>
    4a76:	f7444783          	lbu	a5,-140(s0)
    4a7a:	ffe9                	bnez	a5,4a54 <concreate+0x10e>
      i = de.name[1] - '0';
    4a7c:	f7344783          	lbu	a5,-141(s0)
    4a80:	fd07879b          	addiw	a5,a5,-48
    4a84:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4a88:	faeb60e3          	bltu	s6,a4,4a28 <concreate+0xe2>
      if(fa[i]){
    4a8c:	fb040793          	addi	a5,s0,-80
    4a90:	97ba                	add	a5,a5,a4
    4a92:	fd07c783          	lbu	a5,-48(a5)
    4a96:	dbcd                	beqz	a5,4a48 <concreate+0x102>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4a98:	f7240613          	addi	a2,s0,-142
    4a9c:	85ce                	mv	a1,s3
    4a9e:	00003517          	auipc	a0,0x3
    4aa2:	28250513          	addi	a0,a0,642 # 7d20 <malloc+0x2126>
    4aa6:	00001097          	auipc	ra,0x1
    4aaa:	096080e7          	jalr	150(ra) # 5b3c <printf>
        exit(1);
    4aae:	4505                	li	a0,1
    4ab0:	00001097          	auipc	ra,0x1
    4ab4:	d14080e7          	jalr	-748(ra) # 57c4 <exit>
  close(fd);
    4ab8:	854a                	mv	a0,s2
    4aba:	00001097          	auipc	ra,0x1
    4abe:	d32080e7          	jalr	-718(ra) # 57ec <close>
  if(n != N){
    4ac2:	02800793          	li	a5,40
    4ac6:	00fa9763          	bne	s5,a5,4ad4 <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    4aca:	4a8d                	li	s5,3
    4acc:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    4ace:	02800a13          	li	s4,40
    4ad2:	a8c9                	j	4ba4 <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    4ad4:	85ce                	mv	a1,s3
    4ad6:	00003517          	auipc	a0,0x3
    4ada:	27250513          	addi	a0,a0,626 # 7d48 <malloc+0x214e>
    4ade:	00001097          	auipc	ra,0x1
    4ae2:	05e080e7          	jalr	94(ra) # 5b3c <printf>
    exit(1);
    4ae6:	4505                	li	a0,1
    4ae8:	00001097          	auipc	ra,0x1
    4aec:	cdc080e7          	jalr	-804(ra) # 57c4 <exit>
      printf("%s: fork failed\n", s);
    4af0:	85ce                	mv	a1,s3
    4af2:	00002517          	auipc	a0,0x2
    4af6:	dc650513          	addi	a0,a0,-570 # 68b8 <malloc+0xcbe>
    4afa:	00001097          	auipc	ra,0x1
    4afe:	042080e7          	jalr	66(ra) # 5b3c <printf>
      exit(1);
    4b02:	4505                	li	a0,1
    4b04:	00001097          	auipc	ra,0x1
    4b08:	cc0080e7          	jalr	-832(ra) # 57c4 <exit>
      close(open(file, 0));
    4b0c:	4581                	li	a1,0
    4b0e:	fa840513          	addi	a0,s0,-88
    4b12:	00001097          	auipc	ra,0x1
    4b16:	cf2080e7          	jalr	-782(ra) # 5804 <open>
    4b1a:	00001097          	auipc	ra,0x1
    4b1e:	cd2080e7          	jalr	-814(ra) # 57ec <close>
      close(open(file, 0));
    4b22:	4581                	li	a1,0
    4b24:	fa840513          	addi	a0,s0,-88
    4b28:	00001097          	auipc	ra,0x1
    4b2c:	cdc080e7          	jalr	-804(ra) # 5804 <open>
    4b30:	00001097          	auipc	ra,0x1
    4b34:	cbc080e7          	jalr	-836(ra) # 57ec <close>
      close(open(file, 0));
    4b38:	4581                	li	a1,0
    4b3a:	fa840513          	addi	a0,s0,-88
    4b3e:	00001097          	auipc	ra,0x1
    4b42:	cc6080e7          	jalr	-826(ra) # 5804 <open>
    4b46:	00001097          	auipc	ra,0x1
    4b4a:	ca6080e7          	jalr	-858(ra) # 57ec <close>
      close(open(file, 0));
    4b4e:	4581                	li	a1,0
    4b50:	fa840513          	addi	a0,s0,-88
    4b54:	00001097          	auipc	ra,0x1
    4b58:	cb0080e7          	jalr	-848(ra) # 5804 <open>
    4b5c:	00001097          	auipc	ra,0x1
    4b60:	c90080e7          	jalr	-880(ra) # 57ec <close>
      close(open(file, 0));
    4b64:	4581                	li	a1,0
    4b66:	fa840513          	addi	a0,s0,-88
    4b6a:	00001097          	auipc	ra,0x1
    4b6e:	c9a080e7          	jalr	-870(ra) # 5804 <open>
    4b72:	00001097          	auipc	ra,0x1
    4b76:	c7a080e7          	jalr	-902(ra) # 57ec <close>
      close(open(file, 0));
    4b7a:	4581                	li	a1,0
    4b7c:	fa840513          	addi	a0,s0,-88
    4b80:	00001097          	auipc	ra,0x1
    4b84:	c84080e7          	jalr	-892(ra) # 5804 <open>
    4b88:	00001097          	auipc	ra,0x1
    4b8c:	c64080e7          	jalr	-924(ra) # 57ec <close>
    if(pid == 0)
    4b90:	08090363          	beqz	s2,4c16 <concreate+0x2d0>
      wait(0);
    4b94:	4501                	li	a0,0
    4b96:	00001097          	auipc	ra,0x1
    4b9a:	c36080e7          	jalr	-970(ra) # 57cc <wait>
  for(i = 0; i < N; i++){
    4b9e:	2485                	addiw	s1,s1,1
    4ba0:	0f448563          	beq	s1,s4,4c8a <concreate+0x344>
    file[1] = '0' + i;
    4ba4:	0304879b          	addiw	a5,s1,48
    4ba8:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    4bac:	00001097          	auipc	ra,0x1
    4bb0:	c10080e7          	jalr	-1008(ra) # 57bc <fork>
    4bb4:	892a                	mv	s2,a0
    if(pid < 0){
    4bb6:	f2054de3          	bltz	a0,4af0 <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    4bba:	0354e73b          	remw	a4,s1,s5
    4bbe:	00a767b3          	or	a5,a4,a0
    4bc2:	2781                	sext.w	a5,a5
    4bc4:	d7a1                	beqz	a5,4b0c <concreate+0x1c6>
    4bc6:	01671363          	bne	a4,s6,4bcc <concreate+0x286>
       ((i % 3) == 1 && pid != 0)){
    4bca:	f129                	bnez	a0,4b0c <concreate+0x1c6>
      unlink(file);
    4bcc:	fa840513          	addi	a0,s0,-88
    4bd0:	00001097          	auipc	ra,0x1
    4bd4:	c44080e7          	jalr	-956(ra) # 5814 <unlink>
      unlink(file);
    4bd8:	fa840513          	addi	a0,s0,-88
    4bdc:	00001097          	auipc	ra,0x1
    4be0:	c38080e7          	jalr	-968(ra) # 5814 <unlink>
      unlink(file);
    4be4:	fa840513          	addi	a0,s0,-88
    4be8:	00001097          	auipc	ra,0x1
    4bec:	c2c080e7          	jalr	-980(ra) # 5814 <unlink>
      unlink(file);
    4bf0:	fa840513          	addi	a0,s0,-88
    4bf4:	00001097          	auipc	ra,0x1
    4bf8:	c20080e7          	jalr	-992(ra) # 5814 <unlink>
      unlink(file);
    4bfc:	fa840513          	addi	a0,s0,-88
    4c00:	00001097          	auipc	ra,0x1
    4c04:	c14080e7          	jalr	-1004(ra) # 5814 <unlink>
      unlink(file);
    4c08:	fa840513          	addi	a0,s0,-88
    4c0c:	00001097          	auipc	ra,0x1
    4c10:	c08080e7          	jalr	-1016(ra) # 5814 <unlink>
    4c14:	bfb5                	j	4b90 <concreate+0x24a>
      exit(0);
    4c16:	4501                	li	a0,0
    4c18:	00001097          	auipc	ra,0x1
    4c1c:	bac080e7          	jalr	-1108(ra) # 57c4 <exit>
      close(fd);
    4c20:	00001097          	auipc	ra,0x1
    4c24:	bcc080e7          	jalr	-1076(ra) # 57ec <close>
    if(pid == 0) {
    4c28:	bb65                	j	49e0 <concreate+0x9a>
      close(fd);
    4c2a:	00001097          	auipc	ra,0x1
    4c2e:	bc2080e7          	jalr	-1086(ra) # 57ec <close>
      wait(&xstatus);
    4c32:	f6c40513          	addi	a0,s0,-148
    4c36:	00001097          	auipc	ra,0x1
    4c3a:	b96080e7          	jalr	-1130(ra) # 57cc <wait>
      if(xstatus != 0)
    4c3e:	f6c42483          	lw	s1,-148(s0)
    4c42:	da0494e3          	bnez	s1,49ea <concreate+0xa4>
  for(i = 0; i < N; i++){
    4c46:	2905                	addiw	s2,s2,1
    4c48:	db4906e3          	beq	s2,s4,49f4 <concreate+0xae>
    file[1] = '0' + i;
    4c4c:	0309079b          	addiw	a5,s2,48
    4c50:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4c54:	fa840513          	addi	a0,s0,-88
    4c58:	00001097          	auipc	ra,0x1
    4c5c:	bbc080e7          	jalr	-1092(ra) # 5814 <unlink>
    pid = fork();
    4c60:	00001097          	auipc	ra,0x1
    4c64:	b5c080e7          	jalr	-1188(ra) # 57bc <fork>
    if(pid && (i % 3) == 1){
    4c68:	d20503e3          	beqz	a0,498e <concreate+0x48>
    4c6c:	036967bb          	remw	a5,s2,s6
    4c70:	d15787e3          	beq	a5,s5,497e <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    4c74:	20200593          	li	a1,514
    4c78:	fa840513          	addi	a0,s0,-88
    4c7c:	00001097          	auipc	ra,0x1
    4c80:	b88080e7          	jalr	-1144(ra) # 5804 <open>
      if(fd < 0){
    4c84:	fa0553e3          	bgez	a0,4c2a <concreate+0x2e4>
    4c88:	b31d                	j	49ae <concreate+0x68>
}
    4c8a:	60ea                	ld	ra,152(sp)
    4c8c:	644a                	ld	s0,144(sp)
    4c8e:	64aa                	ld	s1,136(sp)
    4c90:	690a                	ld	s2,128(sp)
    4c92:	79e6                	ld	s3,120(sp)
    4c94:	7a46                	ld	s4,112(sp)
    4c96:	7aa6                	ld	s5,104(sp)
    4c98:	7b06                	ld	s6,96(sp)
    4c9a:	6be6                	ld	s7,88(sp)
    4c9c:	610d                	addi	sp,sp,160
    4c9e:	8082                	ret

0000000000004ca0 <bigfile>:
{
    4ca0:	7139                	addi	sp,sp,-64
    4ca2:	fc06                	sd	ra,56(sp)
    4ca4:	f822                	sd	s0,48(sp)
    4ca6:	f426                	sd	s1,40(sp)
    4ca8:	f04a                	sd	s2,32(sp)
    4caa:	ec4e                	sd	s3,24(sp)
    4cac:	e852                	sd	s4,16(sp)
    4cae:	e456                	sd	s5,8(sp)
    4cb0:	0080                	addi	s0,sp,64
    4cb2:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    4cb4:	00003517          	auipc	a0,0x3
    4cb8:	0cc50513          	addi	a0,a0,204 # 7d80 <malloc+0x2186>
    4cbc:	00001097          	auipc	ra,0x1
    4cc0:	b58080e7          	jalr	-1192(ra) # 5814 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4cc4:	20200593          	li	a1,514
    4cc8:	00003517          	auipc	a0,0x3
    4ccc:	0b850513          	addi	a0,a0,184 # 7d80 <malloc+0x2186>
    4cd0:	00001097          	auipc	ra,0x1
    4cd4:	b34080e7          	jalr	-1228(ra) # 5804 <open>
    4cd8:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    4cda:	4481                	li	s1,0
    memset(buf, i, SZ);
    4cdc:	00007917          	auipc	s2,0x7
    4ce0:	01490913          	addi	s2,s2,20 # bcf0 <buf>
  for(i = 0; i < N; i++){
    4ce4:	4a51                	li	s4,20
  if(fd < 0){
    4ce6:	0a054063          	bltz	a0,4d86 <bigfile+0xe6>
    memset(buf, i, SZ);
    4cea:	25800613          	li	a2,600
    4cee:	85a6                	mv	a1,s1
    4cf0:	854a                	mv	a0,s2
    4cf2:	00001097          	auipc	ra,0x1
    4cf6:	8ce080e7          	jalr	-1842(ra) # 55c0 <memset>
    if(write(fd, buf, SZ) != SZ){
    4cfa:	25800613          	li	a2,600
    4cfe:	85ca                	mv	a1,s2
    4d00:	854e                	mv	a0,s3
    4d02:	00001097          	auipc	ra,0x1
    4d06:	ae2080e7          	jalr	-1310(ra) # 57e4 <write>
    4d0a:	25800793          	li	a5,600
    4d0e:	08f51a63          	bne	a0,a5,4da2 <bigfile+0x102>
  for(i = 0; i < N; i++){
    4d12:	2485                	addiw	s1,s1,1
    4d14:	fd449be3          	bne	s1,s4,4cea <bigfile+0x4a>
  close(fd);
    4d18:	854e                	mv	a0,s3
    4d1a:	00001097          	auipc	ra,0x1
    4d1e:	ad2080e7          	jalr	-1326(ra) # 57ec <close>
  fd = open("bigfile.dat", 0);
    4d22:	4581                	li	a1,0
    4d24:	00003517          	auipc	a0,0x3
    4d28:	05c50513          	addi	a0,a0,92 # 7d80 <malloc+0x2186>
    4d2c:	00001097          	auipc	ra,0x1
    4d30:	ad8080e7          	jalr	-1320(ra) # 5804 <open>
    4d34:	8a2a                	mv	s4,a0
  total = 0;
    4d36:	4981                	li	s3,0
  for(i = 0; ; i++){
    4d38:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4d3a:	00007917          	auipc	s2,0x7
    4d3e:	fb690913          	addi	s2,s2,-74 # bcf0 <buf>
  if(fd < 0){
    4d42:	06054e63          	bltz	a0,4dbe <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    4d46:	12c00613          	li	a2,300
    4d4a:	85ca                	mv	a1,s2
    4d4c:	8552                	mv	a0,s4
    4d4e:	00001097          	auipc	ra,0x1
    4d52:	a8e080e7          	jalr	-1394(ra) # 57dc <read>
    if(cc < 0){
    4d56:	08054263          	bltz	a0,4dda <bigfile+0x13a>
    if(cc == 0)
    4d5a:	c971                	beqz	a0,4e2e <bigfile+0x18e>
    if(cc != SZ/2){
    4d5c:	12c00793          	li	a5,300
    4d60:	08f51b63          	bne	a0,a5,4df6 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4d64:	01f4d79b          	srliw	a5,s1,0x1f
    4d68:	9fa5                	addw	a5,a5,s1
    4d6a:	4017d79b          	sraiw	a5,a5,0x1
    4d6e:	00094703          	lbu	a4,0(s2)
    4d72:	0af71063          	bne	a4,a5,4e12 <bigfile+0x172>
    4d76:	12b94703          	lbu	a4,299(s2)
    4d7a:	08f71c63          	bne	a4,a5,4e12 <bigfile+0x172>
    total += cc;
    4d7e:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    4d82:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4d84:	b7c9                	j	4d46 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    4d86:	85d6                	mv	a1,s5
    4d88:	00003517          	auipc	a0,0x3
    4d8c:	00850513          	addi	a0,a0,8 # 7d90 <malloc+0x2196>
    4d90:	00001097          	auipc	ra,0x1
    4d94:	dac080e7          	jalr	-596(ra) # 5b3c <printf>
    exit(1);
    4d98:	4505                	li	a0,1
    4d9a:	00001097          	auipc	ra,0x1
    4d9e:	a2a080e7          	jalr	-1494(ra) # 57c4 <exit>
      printf("%s: write bigfile failed\n", s);
    4da2:	85d6                	mv	a1,s5
    4da4:	00003517          	auipc	a0,0x3
    4da8:	00c50513          	addi	a0,a0,12 # 7db0 <malloc+0x21b6>
    4dac:	00001097          	auipc	ra,0x1
    4db0:	d90080e7          	jalr	-624(ra) # 5b3c <printf>
      exit(1);
    4db4:	4505                	li	a0,1
    4db6:	00001097          	auipc	ra,0x1
    4dba:	a0e080e7          	jalr	-1522(ra) # 57c4 <exit>
    printf("%s: cannot open bigfile\n", s);
    4dbe:	85d6                	mv	a1,s5
    4dc0:	00003517          	auipc	a0,0x3
    4dc4:	01050513          	addi	a0,a0,16 # 7dd0 <malloc+0x21d6>
    4dc8:	00001097          	auipc	ra,0x1
    4dcc:	d74080e7          	jalr	-652(ra) # 5b3c <printf>
    exit(1);
    4dd0:	4505                	li	a0,1
    4dd2:	00001097          	auipc	ra,0x1
    4dd6:	9f2080e7          	jalr	-1550(ra) # 57c4 <exit>
      printf("%s: read bigfile failed\n", s);
    4dda:	85d6                	mv	a1,s5
    4ddc:	00003517          	auipc	a0,0x3
    4de0:	01450513          	addi	a0,a0,20 # 7df0 <malloc+0x21f6>
    4de4:	00001097          	auipc	ra,0x1
    4de8:	d58080e7          	jalr	-680(ra) # 5b3c <printf>
      exit(1);
    4dec:	4505                	li	a0,1
    4dee:	00001097          	auipc	ra,0x1
    4df2:	9d6080e7          	jalr	-1578(ra) # 57c4 <exit>
      printf("%s: short read bigfile\n", s);
    4df6:	85d6                	mv	a1,s5
    4df8:	00003517          	auipc	a0,0x3
    4dfc:	01850513          	addi	a0,a0,24 # 7e10 <malloc+0x2216>
    4e00:	00001097          	auipc	ra,0x1
    4e04:	d3c080e7          	jalr	-708(ra) # 5b3c <printf>
      exit(1);
    4e08:	4505                	li	a0,1
    4e0a:	00001097          	auipc	ra,0x1
    4e0e:	9ba080e7          	jalr	-1606(ra) # 57c4 <exit>
      printf("%s: read bigfile wrong data\n", s);
    4e12:	85d6                	mv	a1,s5
    4e14:	00003517          	auipc	a0,0x3
    4e18:	01450513          	addi	a0,a0,20 # 7e28 <malloc+0x222e>
    4e1c:	00001097          	auipc	ra,0x1
    4e20:	d20080e7          	jalr	-736(ra) # 5b3c <printf>
      exit(1);
    4e24:	4505                	li	a0,1
    4e26:	00001097          	auipc	ra,0x1
    4e2a:	99e080e7          	jalr	-1634(ra) # 57c4 <exit>
  close(fd);
    4e2e:	8552                	mv	a0,s4
    4e30:	00001097          	auipc	ra,0x1
    4e34:	9bc080e7          	jalr	-1604(ra) # 57ec <close>
  if(total != N*SZ){
    4e38:	678d                	lui	a5,0x3
    4e3a:	ee078793          	addi	a5,a5,-288 # 2ee0 <fourteen+0x196>
    4e3e:	02f99363          	bne	s3,a5,4e64 <bigfile+0x1c4>
  unlink("bigfile.dat");
    4e42:	00003517          	auipc	a0,0x3
    4e46:	f3e50513          	addi	a0,a0,-194 # 7d80 <malloc+0x2186>
    4e4a:	00001097          	auipc	ra,0x1
    4e4e:	9ca080e7          	jalr	-1590(ra) # 5814 <unlink>
}
    4e52:	70e2                	ld	ra,56(sp)
    4e54:	7442                	ld	s0,48(sp)
    4e56:	74a2                	ld	s1,40(sp)
    4e58:	7902                	ld	s2,32(sp)
    4e5a:	69e2                	ld	s3,24(sp)
    4e5c:	6a42                	ld	s4,16(sp)
    4e5e:	6aa2                	ld	s5,8(sp)
    4e60:	6121                	addi	sp,sp,64
    4e62:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4e64:	85d6                	mv	a1,s5
    4e66:	00003517          	auipc	a0,0x3
    4e6a:	fe250513          	addi	a0,a0,-30 # 7e48 <malloc+0x224e>
    4e6e:	00001097          	auipc	ra,0x1
    4e72:	cce080e7          	jalr	-818(ra) # 5b3c <printf>
    exit(1);
    4e76:	4505                	li	a0,1
    4e78:	00001097          	auipc	ra,0x1
    4e7c:	94c080e7          	jalr	-1716(ra) # 57c4 <exit>

0000000000004e80 <fsfull>:
{
    4e80:	7171                	addi	sp,sp,-176
    4e82:	f506                	sd	ra,168(sp)
    4e84:	f122                	sd	s0,160(sp)
    4e86:	ed26                	sd	s1,152(sp)
    4e88:	e94a                	sd	s2,144(sp)
    4e8a:	e54e                	sd	s3,136(sp)
    4e8c:	e152                	sd	s4,128(sp)
    4e8e:	fcd6                	sd	s5,120(sp)
    4e90:	f8da                	sd	s6,112(sp)
    4e92:	f4de                	sd	s7,104(sp)
    4e94:	f0e2                	sd	s8,96(sp)
    4e96:	ece6                	sd	s9,88(sp)
    4e98:	e8ea                	sd	s10,80(sp)
    4e9a:	e4ee                	sd	s11,72(sp)
    4e9c:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4e9e:	00003517          	auipc	a0,0x3
    4ea2:	fca50513          	addi	a0,a0,-54 # 7e68 <malloc+0x226e>
    4ea6:	00001097          	auipc	ra,0x1
    4eaa:	c96080e7          	jalr	-874(ra) # 5b3c <printf>
  for(nfiles = 0; ; nfiles++){
    4eae:	4481                	li	s1,0
    name[0] = 'f';
    4eb0:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4eb4:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4eb8:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4ebc:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4ebe:	00003c97          	auipc	s9,0x3
    4ec2:	fbac8c93          	addi	s9,s9,-70 # 7e78 <malloc+0x227e>
    int total = 0;
    4ec6:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    4ec8:	00007a17          	auipc	s4,0x7
    4ecc:	e28a0a13          	addi	s4,s4,-472 # bcf0 <buf>
    name[0] = 'f';
    4ed0:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4ed4:	0384c7bb          	divw	a5,s1,s8
    4ed8:	0307879b          	addiw	a5,a5,48
    4edc:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4ee0:	0384e7bb          	remw	a5,s1,s8
    4ee4:	0377c7bb          	divw	a5,a5,s7
    4ee8:	0307879b          	addiw	a5,a5,48
    4eec:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4ef0:	0374e7bb          	remw	a5,s1,s7
    4ef4:	0367c7bb          	divw	a5,a5,s6
    4ef8:	0307879b          	addiw	a5,a5,48
    4efc:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4f00:	0364e7bb          	remw	a5,s1,s6
    4f04:	0307879b          	addiw	a5,a5,48
    4f08:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4f0c:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4f10:	f5040593          	addi	a1,s0,-176
    4f14:	8566                	mv	a0,s9
    4f16:	00001097          	auipc	ra,0x1
    4f1a:	c26080e7          	jalr	-986(ra) # 5b3c <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4f1e:	20200593          	li	a1,514
    4f22:	f5040513          	addi	a0,s0,-176
    4f26:	00001097          	auipc	ra,0x1
    4f2a:	8de080e7          	jalr	-1826(ra) # 5804 <open>
    4f2e:	892a                	mv	s2,a0
    if(fd < 0){
    4f30:	0a055663          	bgez	a0,4fdc <fsfull+0x15c>
      printf("open %s failed\n", name);
    4f34:	f5040593          	addi	a1,s0,-176
    4f38:	00003517          	auipc	a0,0x3
    4f3c:	f5050513          	addi	a0,a0,-176 # 7e88 <malloc+0x228e>
    4f40:	00001097          	auipc	ra,0x1
    4f44:	bfc080e7          	jalr	-1028(ra) # 5b3c <printf>
  while(nfiles >= 0){
    4f48:	0604c363          	bltz	s1,4fae <fsfull+0x12e>
    name[0] = 'f';
    4f4c:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4f50:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4f54:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4f58:	4929                	li	s2,10
  while(nfiles >= 0){
    4f5a:	5afd                	li	s5,-1
    name[0] = 'f';
    4f5c:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4f60:	0344c7bb          	divw	a5,s1,s4
    4f64:	0307879b          	addiw	a5,a5,48
    4f68:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4f6c:	0344e7bb          	remw	a5,s1,s4
    4f70:	0337c7bb          	divw	a5,a5,s3
    4f74:	0307879b          	addiw	a5,a5,48
    4f78:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4f7c:	0334e7bb          	remw	a5,s1,s3
    4f80:	0327c7bb          	divw	a5,a5,s2
    4f84:	0307879b          	addiw	a5,a5,48
    4f88:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4f8c:	0324e7bb          	remw	a5,s1,s2
    4f90:	0307879b          	addiw	a5,a5,48
    4f94:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4f98:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4f9c:	f5040513          	addi	a0,s0,-176
    4fa0:	00001097          	auipc	ra,0x1
    4fa4:	874080e7          	jalr	-1932(ra) # 5814 <unlink>
    nfiles--;
    4fa8:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    4faa:	fb5499e3          	bne	s1,s5,4f5c <fsfull+0xdc>
  printf("fsfull test finished\n");
    4fae:	00003517          	auipc	a0,0x3
    4fb2:	efa50513          	addi	a0,a0,-262 # 7ea8 <malloc+0x22ae>
    4fb6:	00001097          	auipc	ra,0x1
    4fba:	b86080e7          	jalr	-1146(ra) # 5b3c <printf>
}
    4fbe:	70aa                	ld	ra,168(sp)
    4fc0:	740a                	ld	s0,160(sp)
    4fc2:	64ea                	ld	s1,152(sp)
    4fc4:	694a                	ld	s2,144(sp)
    4fc6:	69aa                	ld	s3,136(sp)
    4fc8:	6a0a                	ld	s4,128(sp)
    4fca:	7ae6                	ld	s5,120(sp)
    4fcc:	7b46                	ld	s6,112(sp)
    4fce:	7ba6                	ld	s7,104(sp)
    4fd0:	7c06                	ld	s8,96(sp)
    4fd2:	6ce6                	ld	s9,88(sp)
    4fd4:	6d46                	ld	s10,80(sp)
    4fd6:	6da6                	ld	s11,72(sp)
    4fd8:	614d                	addi	sp,sp,176
    4fda:	8082                	ret
    int total = 0;
    4fdc:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    4fde:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    4fe2:	40000613          	li	a2,1024
    4fe6:	85d2                	mv	a1,s4
    4fe8:	854a                	mv	a0,s2
    4fea:	00000097          	auipc	ra,0x0
    4fee:	7fa080e7          	jalr	2042(ra) # 57e4 <write>
      if(cc < BSIZE)
    4ff2:	00aad563          	bge	s5,a0,4ffc <fsfull+0x17c>
      total += cc;
    4ff6:	00a989bb          	addw	s3,s3,a0
    while(1){
    4ffa:	b7e5                	j	4fe2 <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    4ffc:	85ce                	mv	a1,s3
    4ffe:	00003517          	auipc	a0,0x3
    5002:	e9a50513          	addi	a0,a0,-358 # 7e98 <malloc+0x229e>
    5006:	00001097          	auipc	ra,0x1
    500a:	b36080e7          	jalr	-1226(ra) # 5b3c <printf>
    close(fd);
    500e:	854a                	mv	a0,s2
    5010:	00000097          	auipc	ra,0x0
    5014:	7dc080e7          	jalr	2012(ra) # 57ec <close>
    if(total == 0)
    5018:	f20988e3          	beqz	s3,4f48 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    501c:	2485                	addiw	s1,s1,1
    501e:	bd4d                	j	4ed0 <fsfull+0x50>

0000000000005020 <badwrite>:
{
    5020:	7179                	addi	sp,sp,-48
    5022:	f406                	sd	ra,40(sp)
    5024:	f022                	sd	s0,32(sp)
    5026:	ec26                	sd	s1,24(sp)
    5028:	e84a                	sd	s2,16(sp)
    502a:	e44e                	sd	s3,8(sp)
    502c:	e052                	sd	s4,0(sp)
    502e:	1800                	addi	s0,sp,48
  unlink("junk");
    5030:	00003517          	auipc	a0,0x3
    5034:	e9050513          	addi	a0,a0,-368 # 7ec0 <malloc+0x22c6>
    5038:	00000097          	auipc	ra,0x0
    503c:	7dc080e7          	jalr	2012(ra) # 5814 <unlink>
    5040:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    5044:	00003997          	auipc	s3,0x3
    5048:	e7c98993          	addi	s3,s3,-388 # 7ec0 <malloc+0x22c6>
    write(fd, (char*)0xffffffffffL, 1);
    504c:	5a7d                	li	s4,-1
    504e:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    5052:	20100593          	li	a1,513
    5056:	854e                	mv	a0,s3
    5058:	00000097          	auipc	ra,0x0
    505c:	7ac080e7          	jalr	1964(ra) # 5804 <open>
    5060:	84aa                	mv	s1,a0
    if(fd < 0){
    5062:	06054b63          	bltz	a0,50d8 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    5066:	4605                	li	a2,1
    5068:	85d2                	mv	a1,s4
    506a:	00000097          	auipc	ra,0x0
    506e:	77a080e7          	jalr	1914(ra) # 57e4 <write>
    close(fd);
    5072:	8526                	mv	a0,s1
    5074:	00000097          	auipc	ra,0x0
    5078:	778080e7          	jalr	1912(ra) # 57ec <close>
    unlink("junk");
    507c:	854e                	mv	a0,s3
    507e:	00000097          	auipc	ra,0x0
    5082:	796080e7          	jalr	1942(ra) # 5814 <unlink>
  for(int i = 0; i < assumed_free; i++){
    5086:	397d                	addiw	s2,s2,-1
    5088:	fc0915e3          	bnez	s2,5052 <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    508c:	20100593          	li	a1,513
    5090:	00003517          	auipc	a0,0x3
    5094:	e3050513          	addi	a0,a0,-464 # 7ec0 <malloc+0x22c6>
    5098:	00000097          	auipc	ra,0x0
    509c:	76c080e7          	jalr	1900(ra) # 5804 <open>
    50a0:	84aa                	mv	s1,a0
  if(fd < 0){
    50a2:	04054863          	bltz	a0,50f2 <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    50a6:	4605                	li	a2,1
    50a8:	00001597          	auipc	a1,0x1
    50ac:	04858593          	addi	a1,a1,72 # 60f0 <malloc+0x4f6>
    50b0:	00000097          	auipc	ra,0x0
    50b4:	734080e7          	jalr	1844(ra) # 57e4 <write>
    50b8:	4785                	li	a5,1
    50ba:	04f50963          	beq	a0,a5,510c <badwrite+0xec>
    printf("write failed\n");
    50be:	00003517          	auipc	a0,0x3
    50c2:	e2250513          	addi	a0,a0,-478 # 7ee0 <malloc+0x22e6>
    50c6:	00001097          	auipc	ra,0x1
    50ca:	a76080e7          	jalr	-1418(ra) # 5b3c <printf>
    exit(1);
    50ce:	4505                	li	a0,1
    50d0:	00000097          	auipc	ra,0x0
    50d4:	6f4080e7          	jalr	1780(ra) # 57c4 <exit>
      printf("open junk failed\n");
    50d8:	00003517          	auipc	a0,0x3
    50dc:	df050513          	addi	a0,a0,-528 # 7ec8 <malloc+0x22ce>
    50e0:	00001097          	auipc	ra,0x1
    50e4:	a5c080e7          	jalr	-1444(ra) # 5b3c <printf>
      exit(1);
    50e8:	4505                	li	a0,1
    50ea:	00000097          	auipc	ra,0x0
    50ee:	6da080e7          	jalr	1754(ra) # 57c4 <exit>
    printf("open junk failed\n");
    50f2:	00003517          	auipc	a0,0x3
    50f6:	dd650513          	addi	a0,a0,-554 # 7ec8 <malloc+0x22ce>
    50fa:	00001097          	auipc	ra,0x1
    50fe:	a42080e7          	jalr	-1470(ra) # 5b3c <printf>
    exit(1);
    5102:	4505                	li	a0,1
    5104:	00000097          	auipc	ra,0x0
    5108:	6c0080e7          	jalr	1728(ra) # 57c4 <exit>
  close(fd);
    510c:	8526                	mv	a0,s1
    510e:	00000097          	auipc	ra,0x0
    5112:	6de080e7          	jalr	1758(ra) # 57ec <close>
  unlink("junk");
    5116:	00003517          	auipc	a0,0x3
    511a:	daa50513          	addi	a0,a0,-598 # 7ec0 <malloc+0x22c6>
    511e:	00000097          	auipc	ra,0x0
    5122:	6f6080e7          	jalr	1782(ra) # 5814 <unlink>
  exit(0);
    5126:	4501                	li	a0,0
    5128:	00000097          	auipc	ra,0x0
    512c:	69c080e7          	jalr	1692(ra) # 57c4 <exit>

0000000000005130 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    5130:	7139                	addi	sp,sp,-64
    5132:	fc06                	sd	ra,56(sp)
    5134:	f822                	sd	s0,48(sp)
    5136:	f426                	sd	s1,40(sp)
    5138:	f04a                	sd	s2,32(sp)
    513a:	ec4e                	sd	s3,24(sp)
    513c:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    513e:	fc840513          	addi	a0,s0,-56
    5142:	00000097          	auipc	ra,0x0
    5146:	692080e7          	jalr	1682(ra) # 57d4 <pipe>
    514a:	06054863          	bltz	a0,51ba <countfree+0x8a>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    514e:	00000097          	auipc	ra,0x0
    5152:	66e080e7          	jalr	1646(ra) # 57bc <fork>

  if(pid < 0){
    5156:	06054f63          	bltz	a0,51d4 <countfree+0xa4>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    515a:	ed59                	bnez	a0,51f8 <countfree+0xc8>
    close(fds[0]);
    515c:	fc842503          	lw	a0,-56(s0)
    5160:	00000097          	auipc	ra,0x0
    5164:	68c080e7          	jalr	1676(ra) # 57ec <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    5168:	54fd                	li	s1,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    516a:	4985                	li	s3,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    516c:	00001917          	auipc	s2,0x1
    5170:	f8490913          	addi	s2,s2,-124 # 60f0 <malloc+0x4f6>
      uint64 a = (uint64) sbrk(4096);
    5174:	6505                	lui	a0,0x1
    5176:	00000097          	auipc	ra,0x0
    517a:	6d6080e7          	jalr	1750(ra) # 584c <sbrk>
      if(a == 0xffffffffffffffff){
    517e:	06950863          	beq	a0,s1,51ee <countfree+0xbe>
      *(char *)(a + 4096 - 1) = 1;
    5182:	6785                	lui	a5,0x1
    5184:	953e                	add	a0,a0,a5
    5186:	ff350fa3          	sb	s3,-1(a0) # fff <bigdir+0x7d>
      if(write(fds[1], "x", 1) != 1){
    518a:	4605                	li	a2,1
    518c:	85ca                	mv	a1,s2
    518e:	fcc42503          	lw	a0,-52(s0)
    5192:	00000097          	auipc	ra,0x0
    5196:	652080e7          	jalr	1618(ra) # 57e4 <write>
    519a:	4785                	li	a5,1
    519c:	fcf50ce3          	beq	a0,a5,5174 <countfree+0x44>
        printf("write() failed in countfree()\n");
    51a0:	00003517          	auipc	a0,0x3
    51a4:	d9050513          	addi	a0,a0,-624 # 7f30 <malloc+0x2336>
    51a8:	00001097          	auipc	ra,0x1
    51ac:	994080e7          	jalr	-1644(ra) # 5b3c <printf>
        exit(1);
    51b0:	4505                	li	a0,1
    51b2:	00000097          	auipc	ra,0x0
    51b6:	612080e7          	jalr	1554(ra) # 57c4 <exit>
    printf("pipe() failed in countfree()\n");
    51ba:	00003517          	auipc	a0,0x3
    51be:	d3650513          	addi	a0,a0,-714 # 7ef0 <malloc+0x22f6>
    51c2:	00001097          	auipc	ra,0x1
    51c6:	97a080e7          	jalr	-1670(ra) # 5b3c <printf>
    exit(1);
    51ca:	4505                	li	a0,1
    51cc:	00000097          	auipc	ra,0x0
    51d0:	5f8080e7          	jalr	1528(ra) # 57c4 <exit>
    printf("fork failed in countfree()\n");
    51d4:	00003517          	auipc	a0,0x3
    51d8:	d3c50513          	addi	a0,a0,-708 # 7f10 <malloc+0x2316>
    51dc:	00001097          	auipc	ra,0x1
    51e0:	960080e7          	jalr	-1696(ra) # 5b3c <printf>
    exit(1);
    51e4:	4505                	li	a0,1
    51e6:	00000097          	auipc	ra,0x0
    51ea:	5de080e7          	jalr	1502(ra) # 57c4 <exit>
      }
    }

    exit(0);
    51ee:	4501                	li	a0,0
    51f0:	00000097          	auipc	ra,0x0
    51f4:	5d4080e7          	jalr	1492(ra) # 57c4 <exit>
  }

  close(fds[1]);
    51f8:	fcc42503          	lw	a0,-52(s0)
    51fc:	00000097          	auipc	ra,0x0
    5200:	5f0080e7          	jalr	1520(ra) # 57ec <close>

  int n = 0;
    5204:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    5206:	4605                	li	a2,1
    5208:	fc740593          	addi	a1,s0,-57
    520c:	fc842503          	lw	a0,-56(s0)
    5210:	00000097          	auipc	ra,0x0
    5214:	5cc080e7          	jalr	1484(ra) # 57dc <read>
    if(cc < 0){
    5218:	00054563          	bltz	a0,5222 <countfree+0xf2>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    521c:	c105                	beqz	a0,523c <countfree+0x10c>
      break;
    n += 1;
    521e:	2485                	addiw	s1,s1,1
  while(1){
    5220:	b7dd                	j	5206 <countfree+0xd6>
      printf("read() failed in countfree()\n");
    5222:	00003517          	auipc	a0,0x3
    5226:	d2e50513          	addi	a0,a0,-722 # 7f50 <malloc+0x2356>
    522a:	00001097          	auipc	ra,0x1
    522e:	912080e7          	jalr	-1774(ra) # 5b3c <printf>
      exit(1);
    5232:	4505                	li	a0,1
    5234:	00000097          	auipc	ra,0x0
    5238:	590080e7          	jalr	1424(ra) # 57c4 <exit>
  }

  close(fds[0]);
    523c:	fc842503          	lw	a0,-56(s0)
    5240:	00000097          	auipc	ra,0x0
    5244:	5ac080e7          	jalr	1452(ra) # 57ec <close>
  wait((int*)0);
    5248:	4501                	li	a0,0
    524a:	00000097          	auipc	ra,0x0
    524e:	582080e7          	jalr	1410(ra) # 57cc <wait>
  
  return n;
}
    5252:	8526                	mv	a0,s1
    5254:	70e2                	ld	ra,56(sp)
    5256:	7442                	ld	s0,48(sp)
    5258:	74a2                	ld	s1,40(sp)
    525a:	7902                	ld	s2,32(sp)
    525c:	69e2                	ld	s3,24(sp)
    525e:	6121                	addi	sp,sp,64
    5260:	8082                	ret

0000000000005262 <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    5262:	7179                	addi	sp,sp,-48
    5264:	f406                	sd	ra,40(sp)
    5266:	f022                	sd	s0,32(sp)
    5268:	ec26                	sd	s1,24(sp)
    526a:	e84a                	sd	s2,16(sp)
    526c:	1800                	addi	s0,sp,48
    526e:	84aa                	mv	s1,a0
    5270:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    5272:	00003517          	auipc	a0,0x3
    5276:	cfe50513          	addi	a0,a0,-770 # 7f70 <malloc+0x2376>
    527a:	00001097          	auipc	ra,0x1
    527e:	8c2080e7          	jalr	-1854(ra) # 5b3c <printf>
  if((pid = fork()) < 0) {
    5282:	00000097          	auipc	ra,0x0
    5286:	53a080e7          	jalr	1338(ra) # 57bc <fork>
    528a:	02054e63          	bltz	a0,52c6 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    528e:	c929                	beqz	a0,52e0 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    5290:	fdc40513          	addi	a0,s0,-36
    5294:	00000097          	auipc	ra,0x0
    5298:	538080e7          	jalr	1336(ra) # 57cc <wait>
    if(xstatus != 0) 
    529c:	fdc42783          	lw	a5,-36(s0)
    52a0:	c7b9                	beqz	a5,52ee <run+0x8c>
      printf("FAILED\n");
    52a2:	00003517          	auipc	a0,0x3
    52a6:	cf650513          	addi	a0,a0,-778 # 7f98 <malloc+0x239e>
    52aa:	00001097          	auipc	ra,0x1
    52ae:	892080e7          	jalr	-1902(ra) # 5b3c <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    52b2:	fdc42503          	lw	a0,-36(s0)
  }
}
    52b6:	00153513          	seqz	a0,a0
    52ba:	70a2                	ld	ra,40(sp)
    52bc:	7402                	ld	s0,32(sp)
    52be:	64e2                	ld	s1,24(sp)
    52c0:	6942                	ld	s2,16(sp)
    52c2:	6145                	addi	sp,sp,48
    52c4:	8082                	ret
    printf("runtest: fork error\n");
    52c6:	00003517          	auipc	a0,0x3
    52ca:	cba50513          	addi	a0,a0,-838 # 7f80 <malloc+0x2386>
    52ce:	00001097          	auipc	ra,0x1
    52d2:	86e080e7          	jalr	-1938(ra) # 5b3c <printf>
    exit(1);
    52d6:	4505                	li	a0,1
    52d8:	00000097          	auipc	ra,0x0
    52dc:	4ec080e7          	jalr	1260(ra) # 57c4 <exit>
    f(s);
    52e0:	854a                	mv	a0,s2
    52e2:	9482                	jalr	s1
    exit(0);
    52e4:	4501                	li	a0,0
    52e6:	00000097          	auipc	ra,0x0
    52ea:	4de080e7          	jalr	1246(ra) # 57c4 <exit>
      printf("OK\n");
    52ee:	00003517          	auipc	a0,0x3
    52f2:	cb250513          	addi	a0,a0,-846 # 7fa0 <malloc+0x23a6>
    52f6:	00001097          	auipc	ra,0x1
    52fa:	846080e7          	jalr	-1978(ra) # 5b3c <printf>
    52fe:	bf55                	j	52b2 <run+0x50>

0000000000005300 <main>:

int
main(int argc, char *argv[])
{
    5300:	bd010113          	addi	sp,sp,-1072
    5304:	42113423          	sd	ra,1064(sp)
    5308:	42813023          	sd	s0,1056(sp)
    530c:	40913c23          	sd	s1,1048(sp)
    5310:	41213823          	sd	s2,1040(sp)
    5314:	41313423          	sd	s3,1032(sp)
    5318:	41413023          	sd	s4,1024(sp)
    531c:	3f513c23          	sd	s5,1016(sp)
    5320:	3f613823          	sd	s6,1008(sp)
    5324:	43010413          	addi	s0,sp,1072
    5328:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    532a:	4789                	li	a5,2
    532c:	08f50f63          	beq	a0,a5,53ca <main+0xca>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    5330:	4785                	li	a5,1
  char *justone = 0;
    5332:	4901                	li	s2,0
  } else if(argc > 1){
    5334:	0ca7c963          	blt	a5,a0,5406 <main+0x106>
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    5338:	00003797          	auipc	a5,0x3
    533c:	d8078793          	addi	a5,a5,-640 # 80b8 <malloc+0x24be>
    5340:	bd040713          	addi	a4,s0,-1072
    5344:	00003317          	auipc	t1,0x3
    5348:	16430313          	addi	t1,t1,356 # 84a8 <malloc+0x28ae>
    534c:	0007b883          	ld	a7,0(a5)
    5350:	0087b803          	ld	a6,8(a5)
    5354:	6b88                	ld	a0,16(a5)
    5356:	6f8c                	ld	a1,24(a5)
    5358:	7390                	ld	a2,32(a5)
    535a:	7794                	ld	a3,40(a5)
    535c:	01173023          	sd	a7,0(a4)
    5360:	01073423          	sd	a6,8(a4)
    5364:	eb08                	sd	a0,16(a4)
    5366:	ef0c                	sd	a1,24(a4)
    5368:	f310                	sd	a2,32(a4)
    536a:	f714                	sd	a3,40(a4)
    536c:	03078793          	addi	a5,a5,48
    5370:	03070713          	addi	a4,a4,48
    5374:	fc679ce3          	bne	a5,t1,534c <main+0x4c>
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    5378:	00003517          	auipc	a0,0x3
    537c:	ce050513          	addi	a0,a0,-800 # 8058 <malloc+0x245e>
    5380:	00000097          	auipc	ra,0x0
    5384:	7bc080e7          	jalr	1980(ra) # 5b3c <printf>
  int free0 = countfree();
    5388:	00000097          	auipc	ra,0x0
    538c:	da8080e7          	jalr	-600(ra) # 5130 <countfree>
    5390:	8a2a                	mv	s4,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    5392:	bd843503          	ld	a0,-1064(s0)
    5396:	bd040493          	addi	s1,s0,-1072
  int fail = 0;
    539a:	4981                	li	s3,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    539c:	4a85                	li	s5,1
  for (struct test *t = tests; t->s != 0; t++) {
    539e:	e55d                	bnez	a0,544c <main+0x14c>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    53a0:	00000097          	auipc	ra,0x0
    53a4:	d90080e7          	jalr	-624(ra) # 5130 <countfree>
    53a8:	85aa                	mv	a1,a0
    53aa:	0f455163          	bge	a0,s4,548c <main+0x18c>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    53ae:	8652                	mv	a2,s4
    53b0:	00003517          	auipc	a0,0x3
    53b4:	c6050513          	addi	a0,a0,-928 # 8010 <malloc+0x2416>
    53b8:	00000097          	auipc	ra,0x0
    53bc:	784080e7          	jalr	1924(ra) # 5b3c <printf>
    exit(1);
    53c0:	4505                	li	a0,1
    53c2:	00000097          	auipc	ra,0x0
    53c6:	402080e7          	jalr	1026(ra) # 57c4 <exit>
    53ca:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    53cc:	00003597          	auipc	a1,0x3
    53d0:	bdc58593          	addi	a1,a1,-1060 # 7fa8 <malloc+0x23ae>
    53d4:	6488                	ld	a0,8(s1)
    53d6:	00000097          	auipc	ra,0x0
    53da:	194080e7          	jalr	404(ra) # 556a <strcmp>
    53de:	10050563          	beqz	a0,54e8 <main+0x1e8>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    53e2:	00003597          	auipc	a1,0x3
    53e6:	cae58593          	addi	a1,a1,-850 # 8090 <malloc+0x2496>
    53ea:	6488                	ld	a0,8(s1)
    53ec:	00000097          	auipc	ra,0x0
    53f0:	17e080e7          	jalr	382(ra) # 556a <strcmp>
    53f4:	c97d                	beqz	a0,54ea <main+0x1ea>
  } else if(argc == 2 && argv[1][0] != '-'){
    53f6:	0084b903          	ld	s2,8(s1)
    53fa:	00094703          	lbu	a4,0(s2)
    53fe:	02d00793          	li	a5,45
    5402:	f2f71be3          	bne	a4,a5,5338 <main+0x38>
    printf("Usage: usertests [-c] [testname]\n");
    5406:	00003517          	auipc	a0,0x3
    540a:	baa50513          	addi	a0,a0,-1110 # 7fb0 <malloc+0x23b6>
    540e:	00000097          	auipc	ra,0x0
    5412:	72e080e7          	jalr	1838(ra) # 5b3c <printf>
    exit(1);
    5416:	4505                	li	a0,1
    5418:	00000097          	auipc	ra,0x0
    541c:	3ac080e7          	jalr	940(ra) # 57c4 <exit>
          exit(1);
    5420:	4505                	li	a0,1
    5422:	00000097          	auipc	ra,0x0
    5426:	3a2080e7          	jalr	930(ra) # 57c4 <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    542a:	40a905bb          	subw	a1,s2,a0
    542e:	855a                	mv	a0,s6
    5430:	00000097          	auipc	ra,0x0
    5434:	70c080e7          	jalr	1804(ra) # 5b3c <printf>
        if(continuous != 2)
    5438:	09498463          	beq	s3,s4,54c0 <main+0x1c0>
          exit(1);
    543c:	4505                	li	a0,1
    543e:	00000097          	auipc	ra,0x0
    5442:	386080e7          	jalr	902(ra) # 57c4 <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    5446:	04c1                	addi	s1,s1,16
    5448:	6488                	ld	a0,8(s1)
    544a:	c115                	beqz	a0,546e <main+0x16e>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    544c:	00090863          	beqz	s2,545c <main+0x15c>
    5450:	85ca                	mv	a1,s2
    5452:	00000097          	auipc	ra,0x0
    5456:	118080e7          	jalr	280(ra) # 556a <strcmp>
    545a:	f575                	bnez	a0,5446 <main+0x146>
      if(!run(t->f, t->s))
    545c:	648c                	ld	a1,8(s1)
    545e:	6088                	ld	a0,0(s1)
    5460:	00000097          	auipc	ra,0x0
    5464:	e02080e7          	jalr	-510(ra) # 5262 <run>
    5468:	fd79                	bnez	a0,5446 <main+0x146>
        fail = 1;
    546a:	89d6                	mv	s3,s5
    546c:	bfe9                	j	5446 <main+0x146>
  if(fail){
    546e:	f20989e3          	beqz	s3,53a0 <main+0xa0>
    printf("SOME TESTS FAILED\n");
    5472:	00003517          	auipc	a0,0x3
    5476:	b8650513          	addi	a0,a0,-1146 # 7ff8 <malloc+0x23fe>
    547a:	00000097          	auipc	ra,0x0
    547e:	6c2080e7          	jalr	1730(ra) # 5b3c <printf>
    exit(1);
    5482:	4505                	li	a0,1
    5484:	00000097          	auipc	ra,0x0
    5488:	340080e7          	jalr	832(ra) # 57c4 <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    548c:	00003517          	auipc	a0,0x3
    5490:	bb450513          	addi	a0,a0,-1100 # 8040 <malloc+0x2446>
    5494:	00000097          	auipc	ra,0x0
    5498:	6a8080e7          	jalr	1704(ra) # 5b3c <printf>
    exit(0);
    549c:	4501                	li	a0,0
    549e:	00000097          	auipc	ra,0x0
    54a2:	326080e7          	jalr	806(ra) # 57c4 <exit>
        printf("SOME TESTS FAILED\n");
    54a6:	8556                	mv	a0,s5
    54a8:	00000097          	auipc	ra,0x0
    54ac:	694080e7          	jalr	1684(ra) # 5b3c <printf>
        if(continuous != 2)
    54b0:	f74998e3          	bne	s3,s4,5420 <main+0x120>
      int free1 = countfree();
    54b4:	00000097          	auipc	ra,0x0
    54b8:	c7c080e7          	jalr	-900(ra) # 5130 <countfree>
      if(free1 < free0){
    54bc:	f72547e3          	blt	a0,s2,542a <main+0x12a>
      int free0 = countfree();
    54c0:	00000097          	auipc	ra,0x0
    54c4:	c70080e7          	jalr	-912(ra) # 5130 <countfree>
    54c8:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    54ca:	bd843583          	ld	a1,-1064(s0)
    54ce:	d1fd                	beqz	a1,54b4 <main+0x1b4>
    54d0:	bd040493          	addi	s1,s0,-1072
        if(!run(t->f, t->s)){
    54d4:	6088                	ld	a0,0(s1)
    54d6:	00000097          	auipc	ra,0x0
    54da:	d8c080e7          	jalr	-628(ra) # 5262 <run>
    54de:	d561                	beqz	a0,54a6 <main+0x1a6>
      for (struct test *t = tests; t->s != 0; t++) {
    54e0:	04c1                	addi	s1,s1,16
    54e2:	648c                	ld	a1,8(s1)
    54e4:	f9e5                	bnez	a1,54d4 <main+0x1d4>
    54e6:	b7f9                	j	54b4 <main+0x1b4>
    continuous = 1;
    54e8:	4985                	li	s3,1
  } tests[] = {
    54ea:	00003797          	auipc	a5,0x3
    54ee:	bce78793          	addi	a5,a5,-1074 # 80b8 <malloc+0x24be>
    54f2:	bd040713          	addi	a4,s0,-1072
    54f6:	00003317          	auipc	t1,0x3
    54fa:	fb230313          	addi	t1,t1,-78 # 84a8 <malloc+0x28ae>
    54fe:	0007b883          	ld	a7,0(a5)
    5502:	0087b803          	ld	a6,8(a5)
    5506:	6b88                	ld	a0,16(a5)
    5508:	6f8c                	ld	a1,24(a5)
    550a:	7390                	ld	a2,32(a5)
    550c:	7794                	ld	a3,40(a5)
    550e:	01173023          	sd	a7,0(a4)
    5512:	01073423          	sd	a6,8(a4)
    5516:	eb08                	sd	a0,16(a4)
    5518:	ef0c                	sd	a1,24(a4)
    551a:	f310                	sd	a2,32(a4)
    551c:	f714                	sd	a3,40(a4)
    551e:	03078793          	addi	a5,a5,48
    5522:	03070713          	addi	a4,a4,48
    5526:	fc679ce3          	bne	a5,t1,54fe <main+0x1fe>
    printf("continuous usertests starting\n");
    552a:	00003517          	auipc	a0,0x3
    552e:	b4650513          	addi	a0,a0,-1210 # 8070 <malloc+0x2476>
    5532:	00000097          	auipc	ra,0x0
    5536:	60a080e7          	jalr	1546(ra) # 5b3c <printf>
        printf("SOME TESTS FAILED\n");
    553a:	00003a97          	auipc	s5,0x3
    553e:	abea8a93          	addi	s5,s5,-1346 # 7ff8 <malloc+0x23fe>
        if(continuous != 2)
    5542:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    5544:	00003b17          	auipc	s6,0x3
    5548:	a94b0b13          	addi	s6,s6,-1388 # 7fd8 <malloc+0x23de>
    554c:	bf95                	j	54c0 <main+0x1c0>

000000000000554e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    554e:	1141                	addi	sp,sp,-16
    5550:	e422                	sd	s0,8(sp)
    5552:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    5554:	87aa                	mv	a5,a0
    5556:	0585                	addi	a1,a1,1
    5558:	0785                	addi	a5,a5,1
    555a:	fff5c703          	lbu	a4,-1(a1)
    555e:	fee78fa3          	sb	a4,-1(a5)
    5562:	fb75                	bnez	a4,5556 <strcpy+0x8>
    ;
  return os;
}
    5564:	6422                	ld	s0,8(sp)
    5566:	0141                	addi	sp,sp,16
    5568:	8082                	ret

000000000000556a <strcmp>:

int
strcmp(const char *p, const char *q)
{
    556a:	1141                	addi	sp,sp,-16
    556c:	e422                	sd	s0,8(sp)
    556e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    5570:	00054783          	lbu	a5,0(a0)
    5574:	cb91                	beqz	a5,5588 <strcmp+0x1e>
    5576:	0005c703          	lbu	a4,0(a1)
    557a:	00f71763          	bne	a4,a5,5588 <strcmp+0x1e>
    p++, q++;
    557e:	0505                	addi	a0,a0,1
    5580:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    5582:	00054783          	lbu	a5,0(a0)
    5586:	fbe5                	bnez	a5,5576 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    5588:	0005c503          	lbu	a0,0(a1)
}
    558c:	40a7853b          	subw	a0,a5,a0
    5590:	6422                	ld	s0,8(sp)
    5592:	0141                	addi	sp,sp,16
    5594:	8082                	ret

0000000000005596 <strlen>:

uint
strlen(const char *s)
{
    5596:	1141                	addi	sp,sp,-16
    5598:	e422                	sd	s0,8(sp)
    559a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    559c:	00054783          	lbu	a5,0(a0)
    55a0:	cf91                	beqz	a5,55bc <strlen+0x26>
    55a2:	0505                	addi	a0,a0,1
    55a4:	87aa                	mv	a5,a0
    55a6:	4685                	li	a3,1
    55a8:	9e89                	subw	a3,a3,a0
    55aa:	00f6853b          	addw	a0,a3,a5
    55ae:	0785                	addi	a5,a5,1
    55b0:	fff7c703          	lbu	a4,-1(a5)
    55b4:	fb7d                	bnez	a4,55aa <strlen+0x14>
    ;
  return n;
}
    55b6:	6422                	ld	s0,8(sp)
    55b8:	0141                	addi	sp,sp,16
    55ba:	8082                	ret
  for(n = 0; s[n]; n++)
    55bc:	4501                	li	a0,0
    55be:	bfe5                	j	55b6 <strlen+0x20>

00000000000055c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    55c0:	1141                	addi	sp,sp,-16
    55c2:	e422                	sd	s0,8(sp)
    55c4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    55c6:	ce09                	beqz	a2,55e0 <memset+0x20>
    55c8:	87aa                	mv	a5,a0
    55ca:	fff6071b          	addiw	a4,a2,-1
    55ce:	1702                	slli	a4,a4,0x20
    55d0:	9301                	srli	a4,a4,0x20
    55d2:	0705                	addi	a4,a4,1
    55d4:	972a                	add	a4,a4,a0
    cdst[i] = c;
    55d6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    55da:	0785                	addi	a5,a5,1
    55dc:	fee79de3          	bne	a5,a4,55d6 <memset+0x16>
  }
  return dst;
}
    55e0:	6422                	ld	s0,8(sp)
    55e2:	0141                	addi	sp,sp,16
    55e4:	8082                	ret

00000000000055e6 <strchr>:

char*
strchr(const char *s, char c)
{
    55e6:	1141                	addi	sp,sp,-16
    55e8:	e422                	sd	s0,8(sp)
    55ea:	0800                	addi	s0,sp,16
  for(; *s; s++)
    55ec:	00054783          	lbu	a5,0(a0)
    55f0:	cb99                	beqz	a5,5606 <strchr+0x20>
    if(*s == c)
    55f2:	00f58763          	beq	a1,a5,5600 <strchr+0x1a>
  for(; *s; s++)
    55f6:	0505                	addi	a0,a0,1
    55f8:	00054783          	lbu	a5,0(a0)
    55fc:	fbfd                	bnez	a5,55f2 <strchr+0xc>
      return (char*)s;
  return 0;
    55fe:	4501                	li	a0,0
}
    5600:	6422                	ld	s0,8(sp)
    5602:	0141                	addi	sp,sp,16
    5604:	8082                	ret
  return 0;
    5606:	4501                	li	a0,0
    5608:	bfe5                	j	5600 <strchr+0x1a>

000000000000560a <gets>:

char*
gets(char *buf, int max)
{
    560a:	711d                	addi	sp,sp,-96
    560c:	ec86                	sd	ra,88(sp)
    560e:	e8a2                	sd	s0,80(sp)
    5610:	e4a6                	sd	s1,72(sp)
    5612:	e0ca                	sd	s2,64(sp)
    5614:	fc4e                	sd	s3,56(sp)
    5616:	f852                	sd	s4,48(sp)
    5618:	f456                	sd	s5,40(sp)
    561a:	f05a                	sd	s6,32(sp)
    561c:	ec5e                	sd	s7,24(sp)
    561e:	1080                	addi	s0,sp,96
    5620:	8baa                	mv	s7,a0
    5622:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5624:	892a                	mv	s2,a0
    5626:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5628:	4aa9                	li	s5,10
    562a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    562c:	89a6                	mv	s3,s1
    562e:	2485                	addiw	s1,s1,1
    5630:	0344d863          	bge	s1,s4,5660 <gets+0x56>
    cc = read(0, &c, 1);
    5634:	4605                	li	a2,1
    5636:	faf40593          	addi	a1,s0,-81
    563a:	4501                	li	a0,0
    563c:	00000097          	auipc	ra,0x0
    5640:	1a0080e7          	jalr	416(ra) # 57dc <read>
    if(cc < 1)
    5644:	00a05e63          	blez	a0,5660 <gets+0x56>
    buf[i++] = c;
    5648:	faf44783          	lbu	a5,-81(s0)
    564c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5650:	01578763          	beq	a5,s5,565e <gets+0x54>
    5654:	0905                	addi	s2,s2,1
    5656:	fd679be3          	bne	a5,s6,562c <gets+0x22>
  for(i=0; i+1 < max; ){
    565a:	89a6                	mv	s3,s1
    565c:	a011                	j	5660 <gets+0x56>
    565e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5660:	99de                	add	s3,s3,s7
    5662:	00098023          	sb	zero,0(s3)
  return buf;
}
    5666:	855e                	mv	a0,s7
    5668:	60e6                	ld	ra,88(sp)
    566a:	6446                	ld	s0,80(sp)
    566c:	64a6                	ld	s1,72(sp)
    566e:	6906                	ld	s2,64(sp)
    5670:	79e2                	ld	s3,56(sp)
    5672:	7a42                	ld	s4,48(sp)
    5674:	7aa2                	ld	s5,40(sp)
    5676:	7b02                	ld	s6,32(sp)
    5678:	6be2                	ld	s7,24(sp)
    567a:	6125                	addi	sp,sp,96
    567c:	8082                	ret

000000000000567e <stat>:

int
stat(const char *n, struct stat *st)
{
    567e:	1101                	addi	sp,sp,-32
    5680:	ec06                	sd	ra,24(sp)
    5682:	e822                	sd	s0,16(sp)
    5684:	e426                	sd	s1,8(sp)
    5686:	e04a                	sd	s2,0(sp)
    5688:	1000                	addi	s0,sp,32
    568a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    568c:	4581                	li	a1,0
    568e:	00000097          	auipc	ra,0x0
    5692:	176080e7          	jalr	374(ra) # 5804 <open>
  if(fd < 0)
    5696:	02054563          	bltz	a0,56c0 <stat+0x42>
    569a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    569c:	85ca                	mv	a1,s2
    569e:	00000097          	auipc	ra,0x0
    56a2:	17e080e7          	jalr	382(ra) # 581c <fstat>
    56a6:	892a                	mv	s2,a0
  close(fd);
    56a8:	8526                	mv	a0,s1
    56aa:	00000097          	auipc	ra,0x0
    56ae:	142080e7          	jalr	322(ra) # 57ec <close>
  return r;
}
    56b2:	854a                	mv	a0,s2
    56b4:	60e2                	ld	ra,24(sp)
    56b6:	6442                	ld	s0,16(sp)
    56b8:	64a2                	ld	s1,8(sp)
    56ba:	6902                	ld	s2,0(sp)
    56bc:	6105                	addi	sp,sp,32
    56be:	8082                	ret
    return -1;
    56c0:	597d                	li	s2,-1
    56c2:	bfc5                	j	56b2 <stat+0x34>

00000000000056c4 <atoi>:

int
atoi(const char *s)
{
    56c4:	1141                	addi	sp,sp,-16
    56c6:	e422                	sd	s0,8(sp)
    56c8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    56ca:	00054603          	lbu	a2,0(a0)
    56ce:	fd06079b          	addiw	a5,a2,-48
    56d2:	0ff7f793          	andi	a5,a5,255
    56d6:	4725                	li	a4,9
    56d8:	02f76963          	bltu	a4,a5,570a <atoi+0x46>
    56dc:	86aa                	mv	a3,a0
  n = 0;
    56de:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    56e0:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    56e2:	0685                	addi	a3,a3,1
    56e4:	0025179b          	slliw	a5,a0,0x2
    56e8:	9fa9                	addw	a5,a5,a0
    56ea:	0017979b          	slliw	a5,a5,0x1
    56ee:	9fb1                	addw	a5,a5,a2
    56f0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    56f4:	0006c603          	lbu	a2,0(a3) # 1000 <bigdir+0x7e>
    56f8:	fd06071b          	addiw	a4,a2,-48
    56fc:	0ff77713          	andi	a4,a4,255
    5700:	fee5f1e3          	bgeu	a1,a4,56e2 <atoi+0x1e>
  return n;
}
    5704:	6422                	ld	s0,8(sp)
    5706:	0141                	addi	sp,sp,16
    5708:	8082                	ret
  n = 0;
    570a:	4501                	li	a0,0
    570c:	bfe5                	j	5704 <atoi+0x40>

000000000000570e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    570e:	1141                	addi	sp,sp,-16
    5710:	e422                	sd	s0,8(sp)
    5712:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5714:	02b57663          	bgeu	a0,a1,5740 <memmove+0x32>
    while(n-- > 0)
    5718:	02c05163          	blez	a2,573a <memmove+0x2c>
    571c:	fff6079b          	addiw	a5,a2,-1
    5720:	1782                	slli	a5,a5,0x20
    5722:	9381                	srli	a5,a5,0x20
    5724:	0785                	addi	a5,a5,1
    5726:	97aa                	add	a5,a5,a0
  dst = vdst;
    5728:	872a                	mv	a4,a0
      *dst++ = *src++;
    572a:	0585                	addi	a1,a1,1
    572c:	0705                	addi	a4,a4,1
    572e:	fff5c683          	lbu	a3,-1(a1)
    5732:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5736:	fee79ae3          	bne	a5,a4,572a <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    573a:	6422                	ld	s0,8(sp)
    573c:	0141                	addi	sp,sp,16
    573e:	8082                	ret
    dst += n;
    5740:	00c50733          	add	a4,a0,a2
    src += n;
    5744:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5746:	fec05ae3          	blez	a2,573a <memmove+0x2c>
    574a:	fff6079b          	addiw	a5,a2,-1
    574e:	1782                	slli	a5,a5,0x20
    5750:	9381                	srli	a5,a5,0x20
    5752:	fff7c793          	not	a5,a5
    5756:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5758:	15fd                	addi	a1,a1,-1
    575a:	177d                	addi	a4,a4,-1
    575c:	0005c683          	lbu	a3,0(a1)
    5760:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5764:	fee79ae3          	bne	a5,a4,5758 <memmove+0x4a>
    5768:	bfc9                	j	573a <memmove+0x2c>

000000000000576a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    576a:	1141                	addi	sp,sp,-16
    576c:	e422                	sd	s0,8(sp)
    576e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5770:	ca05                	beqz	a2,57a0 <memcmp+0x36>
    5772:	fff6069b          	addiw	a3,a2,-1
    5776:	1682                	slli	a3,a3,0x20
    5778:	9281                	srli	a3,a3,0x20
    577a:	0685                	addi	a3,a3,1
    577c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    577e:	00054783          	lbu	a5,0(a0)
    5782:	0005c703          	lbu	a4,0(a1)
    5786:	00e79863          	bne	a5,a4,5796 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    578a:	0505                	addi	a0,a0,1
    p2++;
    578c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    578e:	fed518e3          	bne	a0,a3,577e <memcmp+0x14>
  }
  return 0;
    5792:	4501                	li	a0,0
    5794:	a019                	j	579a <memcmp+0x30>
      return *p1 - *p2;
    5796:	40e7853b          	subw	a0,a5,a4
}
    579a:	6422                	ld	s0,8(sp)
    579c:	0141                	addi	sp,sp,16
    579e:	8082                	ret
  return 0;
    57a0:	4501                	li	a0,0
    57a2:	bfe5                	j	579a <memcmp+0x30>

00000000000057a4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    57a4:	1141                	addi	sp,sp,-16
    57a6:	e406                	sd	ra,8(sp)
    57a8:	e022                	sd	s0,0(sp)
    57aa:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    57ac:	00000097          	auipc	ra,0x0
    57b0:	f62080e7          	jalr	-158(ra) # 570e <memmove>
}
    57b4:	60a2                	ld	ra,8(sp)
    57b6:	6402                	ld	s0,0(sp)
    57b8:	0141                	addi	sp,sp,16
    57ba:	8082                	ret

00000000000057bc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    57bc:	4885                	li	a7,1
 ecall
    57be:	00000073          	ecall
 ret
    57c2:	8082                	ret

00000000000057c4 <exit>:
.global exit
exit:
 li a7, SYS_exit
    57c4:	4889                	li	a7,2
 ecall
    57c6:	00000073          	ecall
 ret
    57ca:	8082                	ret

00000000000057cc <wait>:
.global wait
wait:
 li a7, SYS_wait
    57cc:	488d                	li	a7,3
 ecall
    57ce:	00000073          	ecall
 ret
    57d2:	8082                	ret

00000000000057d4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    57d4:	4891                	li	a7,4
 ecall
    57d6:	00000073          	ecall
 ret
    57da:	8082                	ret

00000000000057dc <read>:
.global read
read:
 li a7, SYS_read
    57dc:	4895                	li	a7,5
 ecall
    57de:	00000073          	ecall
 ret
    57e2:	8082                	ret

00000000000057e4 <write>:
.global write
write:
 li a7, SYS_write
    57e4:	48c1                	li	a7,16
 ecall
    57e6:	00000073          	ecall
 ret
    57ea:	8082                	ret

00000000000057ec <close>:
.global close
close:
 li a7, SYS_close
    57ec:	48d5                	li	a7,21
 ecall
    57ee:	00000073          	ecall
 ret
    57f2:	8082                	ret

00000000000057f4 <kill>:
.global kill
kill:
 li a7, SYS_kill
    57f4:	4899                	li	a7,6
 ecall
    57f6:	00000073          	ecall
 ret
    57fa:	8082                	ret

00000000000057fc <exec>:
.global exec
exec:
 li a7, SYS_exec
    57fc:	489d                	li	a7,7
 ecall
    57fe:	00000073          	ecall
 ret
    5802:	8082                	ret

0000000000005804 <open>:
.global open
open:
 li a7, SYS_open
    5804:	48bd                	li	a7,15
 ecall
    5806:	00000073          	ecall
 ret
    580a:	8082                	ret

000000000000580c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    580c:	48c5                	li	a7,17
 ecall
    580e:	00000073          	ecall
 ret
    5812:	8082                	ret

0000000000005814 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5814:	48c9                	li	a7,18
 ecall
    5816:	00000073          	ecall
 ret
    581a:	8082                	ret

000000000000581c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    581c:	48a1                	li	a7,8
 ecall
    581e:	00000073          	ecall
 ret
    5822:	8082                	ret

0000000000005824 <link>:
.global link
link:
 li a7, SYS_link
    5824:	48cd                	li	a7,19
 ecall
    5826:	00000073          	ecall
 ret
    582a:	8082                	ret

000000000000582c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    582c:	48d1                	li	a7,20
 ecall
    582e:	00000073          	ecall
 ret
    5832:	8082                	ret

0000000000005834 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5834:	48a5                	li	a7,9
 ecall
    5836:	00000073          	ecall
 ret
    583a:	8082                	ret

000000000000583c <dup>:
.global dup
dup:
 li a7, SYS_dup
    583c:	48a9                	li	a7,10
 ecall
    583e:	00000073          	ecall
 ret
    5842:	8082                	ret

0000000000005844 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5844:	48ad                	li	a7,11
 ecall
    5846:	00000073          	ecall
 ret
    584a:	8082                	ret

000000000000584c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    584c:	48b1                	li	a7,12
 ecall
    584e:	00000073          	ecall
 ret
    5852:	8082                	ret

0000000000005854 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5854:	48b5                	li	a7,13
 ecall
    5856:	00000073          	ecall
 ret
    585a:	8082                	ret

000000000000585c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    585c:	48b9                	li	a7,14
 ecall
    585e:	00000073          	ecall
 ret
    5862:	8082                	ret

0000000000005864 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5864:	1101                	addi	sp,sp,-32
    5866:	ec06                	sd	ra,24(sp)
    5868:	e822                	sd	s0,16(sp)
    586a:	1000                	addi	s0,sp,32
    586c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5870:	4605                	li	a2,1
    5872:	fef40593          	addi	a1,s0,-17
    5876:	00000097          	auipc	ra,0x0
    587a:	f6e080e7          	jalr	-146(ra) # 57e4 <write>
}
    587e:	60e2                	ld	ra,24(sp)
    5880:	6442                	ld	s0,16(sp)
    5882:	6105                	addi	sp,sp,32
    5884:	8082                	ret

0000000000005886 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5886:	7139                	addi	sp,sp,-64
    5888:	fc06                	sd	ra,56(sp)
    588a:	f822                	sd	s0,48(sp)
    588c:	f426                	sd	s1,40(sp)
    588e:	f04a                	sd	s2,32(sp)
    5890:	ec4e                	sd	s3,24(sp)
    5892:	0080                	addi	s0,sp,64
    5894:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5896:	c299                	beqz	a3,589c <printint+0x16>
    5898:	0805c863          	bltz	a1,5928 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    589c:	2581                	sext.w	a1,a1
  neg = 0;
    589e:	4881                	li	a7,0
    58a0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    58a4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    58a6:	2601                	sext.w	a2,a2
    58a8:	00003517          	auipc	a0,0x3
    58ac:	c0850513          	addi	a0,a0,-1016 # 84b0 <digits>
    58b0:	883a                	mv	a6,a4
    58b2:	2705                	addiw	a4,a4,1
    58b4:	02c5f7bb          	remuw	a5,a1,a2
    58b8:	1782                	slli	a5,a5,0x20
    58ba:	9381                	srli	a5,a5,0x20
    58bc:	97aa                	add	a5,a5,a0
    58be:	0007c783          	lbu	a5,0(a5)
    58c2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    58c6:	0005879b          	sext.w	a5,a1
    58ca:	02c5d5bb          	divuw	a1,a1,a2
    58ce:	0685                	addi	a3,a3,1
    58d0:	fec7f0e3          	bgeu	a5,a2,58b0 <printint+0x2a>
  if(neg)
    58d4:	00088b63          	beqz	a7,58ea <printint+0x64>
    buf[i++] = '-';
    58d8:	fd040793          	addi	a5,s0,-48
    58dc:	973e                	add	a4,a4,a5
    58de:	02d00793          	li	a5,45
    58e2:	fef70823          	sb	a5,-16(a4)
    58e6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    58ea:	02e05863          	blez	a4,591a <printint+0x94>
    58ee:	fc040793          	addi	a5,s0,-64
    58f2:	00e78933          	add	s2,a5,a4
    58f6:	fff78993          	addi	s3,a5,-1
    58fa:	99ba                	add	s3,s3,a4
    58fc:	377d                	addiw	a4,a4,-1
    58fe:	1702                	slli	a4,a4,0x20
    5900:	9301                	srli	a4,a4,0x20
    5902:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5906:	fff94583          	lbu	a1,-1(s2)
    590a:	8526                	mv	a0,s1
    590c:	00000097          	auipc	ra,0x0
    5910:	f58080e7          	jalr	-168(ra) # 5864 <putc>
  while(--i >= 0)
    5914:	197d                	addi	s2,s2,-1
    5916:	ff3918e3          	bne	s2,s3,5906 <printint+0x80>
}
    591a:	70e2                	ld	ra,56(sp)
    591c:	7442                	ld	s0,48(sp)
    591e:	74a2                	ld	s1,40(sp)
    5920:	7902                	ld	s2,32(sp)
    5922:	69e2                	ld	s3,24(sp)
    5924:	6121                	addi	sp,sp,64
    5926:	8082                	ret
    x = -xx;
    5928:	40b005bb          	negw	a1,a1
    neg = 1;
    592c:	4885                	li	a7,1
    x = -xx;
    592e:	bf8d                	j	58a0 <printint+0x1a>

0000000000005930 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5930:	7119                	addi	sp,sp,-128
    5932:	fc86                	sd	ra,120(sp)
    5934:	f8a2                	sd	s0,112(sp)
    5936:	f4a6                	sd	s1,104(sp)
    5938:	f0ca                	sd	s2,96(sp)
    593a:	ecce                	sd	s3,88(sp)
    593c:	e8d2                	sd	s4,80(sp)
    593e:	e4d6                	sd	s5,72(sp)
    5940:	e0da                	sd	s6,64(sp)
    5942:	fc5e                	sd	s7,56(sp)
    5944:	f862                	sd	s8,48(sp)
    5946:	f466                	sd	s9,40(sp)
    5948:	f06a                	sd	s10,32(sp)
    594a:	ec6e                	sd	s11,24(sp)
    594c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    594e:	0005c903          	lbu	s2,0(a1)
    5952:	18090f63          	beqz	s2,5af0 <vprintf+0x1c0>
    5956:	8aaa                	mv	s5,a0
    5958:	8b32                	mv	s6,a2
    595a:	00158493          	addi	s1,a1,1
  state = 0;
    595e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5960:	02500a13          	li	s4,37
      if(c == 'd'){
    5964:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    5968:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    596c:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    5970:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5974:	00003b97          	auipc	s7,0x3
    5978:	b3cb8b93          	addi	s7,s7,-1220 # 84b0 <digits>
    597c:	a839                	j	599a <vprintf+0x6a>
        putc(fd, c);
    597e:	85ca                	mv	a1,s2
    5980:	8556                	mv	a0,s5
    5982:	00000097          	auipc	ra,0x0
    5986:	ee2080e7          	jalr	-286(ra) # 5864 <putc>
    598a:	a019                	j	5990 <vprintf+0x60>
    } else if(state == '%'){
    598c:	01498f63          	beq	s3,s4,59aa <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    5990:	0485                	addi	s1,s1,1
    5992:	fff4c903          	lbu	s2,-1(s1)
    5996:	14090d63          	beqz	s2,5af0 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    599a:	0009079b          	sext.w	a5,s2
    if(state == 0){
    599e:	fe0997e3          	bnez	s3,598c <vprintf+0x5c>
      if(c == '%'){
    59a2:	fd479ee3          	bne	a5,s4,597e <vprintf+0x4e>
        state = '%';
    59a6:	89be                	mv	s3,a5
    59a8:	b7e5                	j	5990 <vprintf+0x60>
      if(c == 'd'){
    59aa:	05878063          	beq	a5,s8,59ea <vprintf+0xba>
      } else if(c == 'l') {
    59ae:	05978c63          	beq	a5,s9,5a06 <vprintf+0xd6>
      } else if(c == 'x') {
    59b2:	07a78863          	beq	a5,s10,5a22 <vprintf+0xf2>
      } else if(c == 'p') {
    59b6:	09b78463          	beq	a5,s11,5a3e <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    59ba:	07300713          	li	a4,115
    59be:	0ce78663          	beq	a5,a4,5a8a <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    59c2:	06300713          	li	a4,99
    59c6:	0ee78e63          	beq	a5,a4,5ac2 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    59ca:	11478863          	beq	a5,s4,5ada <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    59ce:	85d2                	mv	a1,s4
    59d0:	8556                	mv	a0,s5
    59d2:	00000097          	auipc	ra,0x0
    59d6:	e92080e7          	jalr	-366(ra) # 5864 <putc>
        putc(fd, c);
    59da:	85ca                	mv	a1,s2
    59dc:	8556                	mv	a0,s5
    59de:	00000097          	auipc	ra,0x0
    59e2:	e86080e7          	jalr	-378(ra) # 5864 <putc>
      }
      state = 0;
    59e6:	4981                	li	s3,0
    59e8:	b765                	j	5990 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    59ea:	008b0913          	addi	s2,s6,8
    59ee:	4685                	li	a3,1
    59f0:	4629                	li	a2,10
    59f2:	000b2583          	lw	a1,0(s6)
    59f6:	8556                	mv	a0,s5
    59f8:	00000097          	auipc	ra,0x0
    59fc:	e8e080e7          	jalr	-370(ra) # 5886 <printint>
    5a00:	8b4a                	mv	s6,s2
      state = 0;
    5a02:	4981                	li	s3,0
    5a04:	b771                	j	5990 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5a06:	008b0913          	addi	s2,s6,8
    5a0a:	4681                	li	a3,0
    5a0c:	4629                	li	a2,10
    5a0e:	000b2583          	lw	a1,0(s6)
    5a12:	8556                	mv	a0,s5
    5a14:	00000097          	auipc	ra,0x0
    5a18:	e72080e7          	jalr	-398(ra) # 5886 <printint>
    5a1c:	8b4a                	mv	s6,s2
      state = 0;
    5a1e:	4981                	li	s3,0
    5a20:	bf85                	j	5990 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5a22:	008b0913          	addi	s2,s6,8
    5a26:	4681                	li	a3,0
    5a28:	4641                	li	a2,16
    5a2a:	000b2583          	lw	a1,0(s6)
    5a2e:	8556                	mv	a0,s5
    5a30:	00000097          	auipc	ra,0x0
    5a34:	e56080e7          	jalr	-426(ra) # 5886 <printint>
    5a38:	8b4a                	mv	s6,s2
      state = 0;
    5a3a:	4981                	li	s3,0
    5a3c:	bf91                	j	5990 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5a3e:	008b0793          	addi	a5,s6,8
    5a42:	f8f43423          	sd	a5,-120(s0)
    5a46:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5a4a:	03000593          	li	a1,48
    5a4e:	8556                	mv	a0,s5
    5a50:	00000097          	auipc	ra,0x0
    5a54:	e14080e7          	jalr	-492(ra) # 5864 <putc>
  putc(fd, 'x');
    5a58:	85ea                	mv	a1,s10
    5a5a:	8556                	mv	a0,s5
    5a5c:	00000097          	auipc	ra,0x0
    5a60:	e08080e7          	jalr	-504(ra) # 5864 <putc>
    5a64:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5a66:	03c9d793          	srli	a5,s3,0x3c
    5a6a:	97de                	add	a5,a5,s7
    5a6c:	0007c583          	lbu	a1,0(a5)
    5a70:	8556                	mv	a0,s5
    5a72:	00000097          	auipc	ra,0x0
    5a76:	df2080e7          	jalr	-526(ra) # 5864 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5a7a:	0992                	slli	s3,s3,0x4
    5a7c:	397d                	addiw	s2,s2,-1
    5a7e:	fe0914e3          	bnez	s2,5a66 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    5a82:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5a86:	4981                	li	s3,0
    5a88:	b721                	j	5990 <vprintf+0x60>
        s = va_arg(ap, char*);
    5a8a:	008b0993          	addi	s3,s6,8
    5a8e:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    5a92:	02090163          	beqz	s2,5ab4 <vprintf+0x184>
        while(*s != 0){
    5a96:	00094583          	lbu	a1,0(s2)
    5a9a:	c9a1                	beqz	a1,5aea <vprintf+0x1ba>
          putc(fd, *s);
    5a9c:	8556                	mv	a0,s5
    5a9e:	00000097          	auipc	ra,0x0
    5aa2:	dc6080e7          	jalr	-570(ra) # 5864 <putc>
          s++;
    5aa6:	0905                	addi	s2,s2,1
        while(*s != 0){
    5aa8:	00094583          	lbu	a1,0(s2)
    5aac:	f9e5                	bnez	a1,5a9c <vprintf+0x16c>
        s = va_arg(ap, char*);
    5aae:	8b4e                	mv	s6,s3
      state = 0;
    5ab0:	4981                	li	s3,0
    5ab2:	bdf9                	j	5990 <vprintf+0x60>
          s = "(null)";
    5ab4:	00003917          	auipc	s2,0x3
    5ab8:	9f490913          	addi	s2,s2,-1548 # 84a8 <malloc+0x28ae>
        while(*s != 0){
    5abc:	02800593          	li	a1,40
    5ac0:	bff1                	j	5a9c <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    5ac2:	008b0913          	addi	s2,s6,8
    5ac6:	000b4583          	lbu	a1,0(s6)
    5aca:	8556                	mv	a0,s5
    5acc:	00000097          	auipc	ra,0x0
    5ad0:	d98080e7          	jalr	-616(ra) # 5864 <putc>
    5ad4:	8b4a                	mv	s6,s2
      state = 0;
    5ad6:	4981                	li	s3,0
    5ad8:	bd65                	j	5990 <vprintf+0x60>
        putc(fd, c);
    5ada:	85d2                	mv	a1,s4
    5adc:	8556                	mv	a0,s5
    5ade:	00000097          	auipc	ra,0x0
    5ae2:	d86080e7          	jalr	-634(ra) # 5864 <putc>
      state = 0;
    5ae6:	4981                	li	s3,0
    5ae8:	b565                	j	5990 <vprintf+0x60>
        s = va_arg(ap, char*);
    5aea:	8b4e                	mv	s6,s3
      state = 0;
    5aec:	4981                	li	s3,0
    5aee:	b54d                	j	5990 <vprintf+0x60>
    }
  }
}
    5af0:	70e6                	ld	ra,120(sp)
    5af2:	7446                	ld	s0,112(sp)
    5af4:	74a6                	ld	s1,104(sp)
    5af6:	7906                	ld	s2,96(sp)
    5af8:	69e6                	ld	s3,88(sp)
    5afa:	6a46                	ld	s4,80(sp)
    5afc:	6aa6                	ld	s5,72(sp)
    5afe:	6b06                	ld	s6,64(sp)
    5b00:	7be2                	ld	s7,56(sp)
    5b02:	7c42                	ld	s8,48(sp)
    5b04:	7ca2                	ld	s9,40(sp)
    5b06:	7d02                	ld	s10,32(sp)
    5b08:	6de2                	ld	s11,24(sp)
    5b0a:	6109                	addi	sp,sp,128
    5b0c:	8082                	ret

0000000000005b0e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5b0e:	715d                	addi	sp,sp,-80
    5b10:	ec06                	sd	ra,24(sp)
    5b12:	e822                	sd	s0,16(sp)
    5b14:	1000                	addi	s0,sp,32
    5b16:	e010                	sd	a2,0(s0)
    5b18:	e414                	sd	a3,8(s0)
    5b1a:	e818                	sd	a4,16(s0)
    5b1c:	ec1c                	sd	a5,24(s0)
    5b1e:	03043023          	sd	a6,32(s0)
    5b22:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5b26:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5b2a:	8622                	mv	a2,s0
    5b2c:	00000097          	auipc	ra,0x0
    5b30:	e04080e7          	jalr	-508(ra) # 5930 <vprintf>
}
    5b34:	60e2                	ld	ra,24(sp)
    5b36:	6442                	ld	s0,16(sp)
    5b38:	6161                	addi	sp,sp,80
    5b3a:	8082                	ret

0000000000005b3c <printf>:

void
printf(const char *fmt, ...)
{
    5b3c:	711d                	addi	sp,sp,-96
    5b3e:	ec06                	sd	ra,24(sp)
    5b40:	e822                	sd	s0,16(sp)
    5b42:	1000                	addi	s0,sp,32
    5b44:	e40c                	sd	a1,8(s0)
    5b46:	e810                	sd	a2,16(s0)
    5b48:	ec14                	sd	a3,24(s0)
    5b4a:	f018                	sd	a4,32(s0)
    5b4c:	f41c                	sd	a5,40(s0)
    5b4e:	03043823          	sd	a6,48(s0)
    5b52:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5b56:	00840613          	addi	a2,s0,8
    5b5a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5b5e:	85aa                	mv	a1,a0
    5b60:	4505                	li	a0,1
    5b62:	00000097          	auipc	ra,0x0
    5b66:	dce080e7          	jalr	-562(ra) # 5930 <vprintf>
}
    5b6a:	60e2                	ld	ra,24(sp)
    5b6c:	6442                	ld	s0,16(sp)
    5b6e:	6125                	addi	sp,sp,96
    5b70:	8082                	ret

0000000000005b72 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5b72:	1141                	addi	sp,sp,-16
    5b74:	e422                	sd	s0,8(sp)
    5b76:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5b78:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5b7c:	00003797          	auipc	a5,0x3
    5b80:	9547b783          	ld	a5,-1708(a5) # 84d0 <freep>
    5b84:	a805                	j	5bb4 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5b86:	4618                	lw	a4,8(a2)
    5b88:	9db9                	addw	a1,a1,a4
    5b8a:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5b8e:	6398                	ld	a4,0(a5)
    5b90:	6318                	ld	a4,0(a4)
    5b92:	fee53823          	sd	a4,-16(a0)
    5b96:	a091                	j	5bda <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5b98:	ff852703          	lw	a4,-8(a0)
    5b9c:	9e39                	addw	a2,a2,a4
    5b9e:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    5ba0:	ff053703          	ld	a4,-16(a0)
    5ba4:	e398                	sd	a4,0(a5)
    5ba6:	a099                	j	5bec <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5ba8:	6398                	ld	a4,0(a5)
    5baa:	00e7e463          	bltu	a5,a4,5bb2 <free+0x40>
    5bae:	00e6ea63          	bltu	a3,a4,5bc2 <free+0x50>
{
    5bb2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5bb4:	fed7fae3          	bgeu	a5,a3,5ba8 <free+0x36>
    5bb8:	6398                	ld	a4,0(a5)
    5bba:	00e6e463          	bltu	a3,a4,5bc2 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5bbe:	fee7eae3          	bltu	a5,a4,5bb2 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    5bc2:	ff852583          	lw	a1,-8(a0)
    5bc6:	6390                	ld	a2,0(a5)
    5bc8:	02059713          	slli	a4,a1,0x20
    5bcc:	9301                	srli	a4,a4,0x20
    5bce:	0712                	slli	a4,a4,0x4
    5bd0:	9736                	add	a4,a4,a3
    5bd2:	fae60ae3          	beq	a2,a4,5b86 <free+0x14>
    bp->s.ptr = p->s.ptr;
    5bd6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5bda:	4790                	lw	a2,8(a5)
    5bdc:	02061713          	slli	a4,a2,0x20
    5be0:	9301                	srli	a4,a4,0x20
    5be2:	0712                	slli	a4,a4,0x4
    5be4:	973e                	add	a4,a4,a5
    5be6:	fae689e3          	beq	a3,a4,5b98 <free+0x26>
  } else
    p->s.ptr = bp;
    5bea:	e394                	sd	a3,0(a5)
  freep = p;
    5bec:	00003717          	auipc	a4,0x3
    5bf0:	8ef73223          	sd	a5,-1820(a4) # 84d0 <freep>
}
    5bf4:	6422                	ld	s0,8(sp)
    5bf6:	0141                	addi	sp,sp,16
    5bf8:	8082                	ret

0000000000005bfa <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5bfa:	7139                	addi	sp,sp,-64
    5bfc:	fc06                	sd	ra,56(sp)
    5bfe:	f822                	sd	s0,48(sp)
    5c00:	f426                	sd	s1,40(sp)
    5c02:	f04a                	sd	s2,32(sp)
    5c04:	ec4e                	sd	s3,24(sp)
    5c06:	e852                	sd	s4,16(sp)
    5c08:	e456                	sd	s5,8(sp)
    5c0a:	e05a                	sd	s6,0(sp)
    5c0c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5c0e:	02051493          	slli	s1,a0,0x20
    5c12:	9081                	srli	s1,s1,0x20
    5c14:	04bd                	addi	s1,s1,15
    5c16:	8091                	srli	s1,s1,0x4
    5c18:	0014899b          	addiw	s3,s1,1
    5c1c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    5c1e:	00003517          	auipc	a0,0x3
    5c22:	8b253503          	ld	a0,-1870(a0) # 84d0 <freep>
    5c26:	c515                	beqz	a0,5c52 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5c28:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5c2a:	4798                	lw	a4,8(a5)
    5c2c:	02977f63          	bgeu	a4,s1,5c6a <malloc+0x70>
    5c30:	8a4e                	mv	s4,s3
    5c32:	0009871b          	sext.w	a4,s3
    5c36:	6685                	lui	a3,0x1
    5c38:	00d77363          	bgeu	a4,a3,5c3e <malloc+0x44>
    5c3c:	6a05                	lui	s4,0x1
    5c3e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5c42:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5c46:	00003917          	auipc	s2,0x3
    5c4a:	88a90913          	addi	s2,s2,-1910 # 84d0 <freep>
  if(p == (char*)-1)
    5c4e:	5afd                	li	s5,-1
    5c50:	a88d                	j	5cc2 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    5c52:	00009797          	auipc	a5,0x9
    5c56:	09e78793          	addi	a5,a5,158 # ecf0 <base>
    5c5a:	00003717          	auipc	a4,0x3
    5c5e:	86f73b23          	sd	a5,-1930(a4) # 84d0 <freep>
    5c62:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5c64:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5c68:	b7e1                	j	5c30 <malloc+0x36>
      if(p->s.size == nunits)
    5c6a:	02e48b63          	beq	s1,a4,5ca0 <malloc+0xa6>
        p->s.size -= nunits;
    5c6e:	4137073b          	subw	a4,a4,s3
    5c72:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5c74:	1702                	slli	a4,a4,0x20
    5c76:	9301                	srli	a4,a4,0x20
    5c78:	0712                	slli	a4,a4,0x4
    5c7a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5c7c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5c80:	00003717          	auipc	a4,0x3
    5c84:	84a73823          	sd	a0,-1968(a4) # 84d0 <freep>
      return (void*)(p + 1);
    5c88:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5c8c:	70e2                	ld	ra,56(sp)
    5c8e:	7442                	ld	s0,48(sp)
    5c90:	74a2                	ld	s1,40(sp)
    5c92:	7902                	ld	s2,32(sp)
    5c94:	69e2                	ld	s3,24(sp)
    5c96:	6a42                	ld	s4,16(sp)
    5c98:	6aa2                	ld	s5,8(sp)
    5c9a:	6b02                	ld	s6,0(sp)
    5c9c:	6121                	addi	sp,sp,64
    5c9e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    5ca0:	6398                	ld	a4,0(a5)
    5ca2:	e118                	sd	a4,0(a0)
    5ca4:	bff1                	j	5c80 <malloc+0x86>
  hp->s.size = nu;
    5ca6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    5caa:	0541                	addi	a0,a0,16
    5cac:	00000097          	auipc	ra,0x0
    5cb0:	ec6080e7          	jalr	-314(ra) # 5b72 <free>
  return freep;
    5cb4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    5cb8:	d971                	beqz	a0,5c8c <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5cba:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5cbc:	4798                	lw	a4,8(a5)
    5cbe:	fa9776e3          	bgeu	a4,s1,5c6a <malloc+0x70>
    if(p == freep)
    5cc2:	00093703          	ld	a4,0(s2)
    5cc6:	853e                	mv	a0,a5
    5cc8:	fef719e3          	bne	a4,a5,5cba <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    5ccc:	8552                	mv	a0,s4
    5cce:	00000097          	auipc	ra,0x0
    5cd2:	b7e080e7          	jalr	-1154(ra) # 584c <sbrk>
  if(p == (char*)-1)
    5cd6:	fd5518e3          	bne	a0,s5,5ca6 <malloc+0xac>
        return 0;
    5cda:	4501                	li	a0,0
    5cdc:	bf45                	j	5c8c <malloc+0x92>
