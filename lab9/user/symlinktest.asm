
user/_symlinktest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <stat_slink>:
}

// stat a symbolic link using O_NOFOLLOW
static int
stat_slink(char *pn, struct stat *st)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84ae                	mv	s1,a1
  int fd = open(pn, O_RDONLY | O_NOFOLLOW);
   c:	10000593          	li	a1,256
  10:	00001097          	auipc	ra,0x1
  14:	97a080e7          	jalr	-1670(ra) # 98a <open>
  if(fd < 0)
  18:	02054063          	bltz	a0,38 <stat_slink+0x38>
    return -1;
  if(fstat(fd, st) != 0)
  1c:	85a6                	mv	a1,s1
  1e:	00001097          	auipc	ra,0x1
  22:	984080e7          	jalr	-1660(ra) # 9a2 <fstat>
  26:	00a03533          	snez	a0,a0
  2a:	40a00533          	neg	a0,a0
    return -1;
  return 0;
}
  2e:	60e2                	ld	ra,24(sp)
  30:	6442                	ld	s0,16(sp)
  32:	64a2                	ld	s1,8(sp)
  34:	6105                	addi	sp,sp,32
  36:	8082                	ret
    return -1;
  38:	557d                	li	a0,-1
  3a:	bfd5                	j	2e <stat_slink+0x2e>

000000000000003c <main>:
{
  3c:	7119                	addi	sp,sp,-128
  3e:	fc86                	sd	ra,120(sp)
  40:	f8a2                	sd	s0,112(sp)
  42:	f4a6                	sd	s1,104(sp)
  44:	f0ca                	sd	s2,96(sp)
  46:	ecce                	sd	s3,88(sp)
  48:	e8d2                	sd	s4,80(sp)
  4a:	e4d6                	sd	s5,72(sp)
  4c:	e0da                	sd	s6,64(sp)
  4e:	fc5e                	sd	s7,56(sp)
  50:	f862                	sd	s8,48(sp)
  52:	0100                	addi	s0,sp,128
  unlink("/testsymlink/a");
  54:	00001517          	auipc	a0,0x1
  58:	e1c50513          	addi	a0,a0,-484 # e70 <malloc+0xe8>
  5c:	00001097          	auipc	ra,0x1
  60:	93e080e7          	jalr	-1730(ra) # 99a <unlink>
  unlink("/testsymlink/b");
  64:	00001517          	auipc	a0,0x1
  68:	e1c50513          	addi	a0,a0,-484 # e80 <malloc+0xf8>
  6c:	00001097          	auipc	ra,0x1
  70:	92e080e7          	jalr	-1746(ra) # 99a <unlink>
  unlink("/testsymlink/c");
  74:	00001517          	auipc	a0,0x1
  78:	e1c50513          	addi	a0,a0,-484 # e90 <malloc+0x108>
  7c:	00001097          	auipc	ra,0x1
  80:	91e080e7          	jalr	-1762(ra) # 99a <unlink>
  unlink("/testsymlink/1");
  84:	00001517          	auipc	a0,0x1
  88:	e1c50513          	addi	a0,a0,-484 # ea0 <malloc+0x118>
  8c:	00001097          	auipc	ra,0x1
  90:	90e080e7          	jalr	-1778(ra) # 99a <unlink>
  unlink("/testsymlink/2");
  94:	00001517          	auipc	a0,0x1
  98:	e1c50513          	addi	a0,a0,-484 # eb0 <malloc+0x128>
  9c:	00001097          	auipc	ra,0x1
  a0:	8fe080e7          	jalr	-1794(ra) # 99a <unlink>
  unlink("/testsymlink/3");
  a4:	00001517          	auipc	a0,0x1
  a8:	e1c50513          	addi	a0,a0,-484 # ec0 <malloc+0x138>
  ac:	00001097          	auipc	ra,0x1
  b0:	8ee080e7          	jalr	-1810(ra) # 99a <unlink>
  unlink("/testsymlink/4");
  b4:	00001517          	auipc	a0,0x1
  b8:	e1c50513          	addi	a0,a0,-484 # ed0 <malloc+0x148>
  bc:	00001097          	auipc	ra,0x1
  c0:	8de080e7          	jalr	-1826(ra) # 99a <unlink>
  unlink("/testsymlink/z");
  c4:	00001517          	auipc	a0,0x1
  c8:	e1c50513          	addi	a0,a0,-484 # ee0 <malloc+0x158>
  cc:	00001097          	auipc	ra,0x1
  d0:	8ce080e7          	jalr	-1842(ra) # 99a <unlink>
  unlink("/testsymlink/y");
  d4:	00001517          	auipc	a0,0x1
  d8:	e1c50513          	addi	a0,a0,-484 # ef0 <malloc+0x168>
  dc:	00001097          	auipc	ra,0x1
  e0:	8be080e7          	jalr	-1858(ra) # 99a <unlink>
  unlink("/testsymlink");
  e4:	00001517          	auipc	a0,0x1
  e8:	e1c50513          	addi	a0,a0,-484 # f00 <malloc+0x178>
  ec:	00001097          	auipc	ra,0x1
  f0:	8ae080e7          	jalr	-1874(ra) # 99a <unlink>

static void
testsymlink(void)
{
  int r, fd1 = -1, fd2 = -1;
  char buf[4] = {'a', 'b', 'c', 'd'};
  f4:	646367b7          	lui	a5,0x64636
  f8:	2617879b          	addiw	a5,a5,609
  fc:	f8f42823          	sw	a5,-112(s0)
  char c = 0, c2 = 0;
 100:	f8040723          	sb	zero,-114(s0)
 104:	f80407a3          	sb	zero,-113(s0)
  struct stat st;
    
  printf("Start: test symlinks\n");
 108:	00001517          	auipc	a0,0x1
 10c:	e0850513          	addi	a0,a0,-504 # f10 <malloc+0x188>
 110:	00001097          	auipc	ra,0x1
 114:	bba080e7          	jalr	-1094(ra) # cca <printf>

  mkdir("/testsymlink");
 118:	00001517          	auipc	a0,0x1
 11c:	de850513          	addi	a0,a0,-536 # f00 <malloc+0x178>
 120:	00001097          	auipc	ra,0x1
 124:	892080e7          	jalr	-1902(ra) # 9b2 <mkdir>

  fd1 = open("/testsymlink/a", O_CREATE | O_RDWR);
 128:	20200593          	li	a1,514
 12c:	00001517          	auipc	a0,0x1
 130:	d4450513          	addi	a0,a0,-700 # e70 <malloc+0xe8>
 134:	00001097          	auipc	ra,0x1
 138:	856080e7          	jalr	-1962(ra) # 98a <open>
 13c:	84aa                	mv	s1,a0
  if(fd1 < 0) fail("failed to open a");
 13e:	0e054f63          	bltz	a0,23c <main+0x200>

  r = symlink("/testsymlink/a", "/testsymlink/b");
 142:	00001597          	auipc	a1,0x1
 146:	d3e58593          	addi	a1,a1,-706 # e80 <malloc+0xf8>
 14a:	00001517          	auipc	a0,0x1
 14e:	d2650513          	addi	a0,a0,-730 # e70 <malloc+0xe8>
 152:	00001097          	auipc	ra,0x1
 156:	898080e7          	jalr	-1896(ra) # 9ea <symlink>
  if(r < 0)
 15a:	10054063          	bltz	a0,25a <main+0x21e>
    fail("symlink b -> a failed");

  if(write(fd1, buf, sizeof(buf)) != 4)
 15e:	4611                	li	a2,4
 160:	f9040593          	addi	a1,s0,-112
 164:	8526                	mv	a0,s1
 166:	00001097          	auipc	ra,0x1
 16a:	804080e7          	jalr	-2044(ra) # 96a <write>
 16e:	4791                	li	a5,4
 170:	10f50463          	beq	a0,a5,278 <main+0x23c>
    fail("failed to write to a");
 174:	00001517          	auipc	a0,0x1
 178:	df450513          	addi	a0,a0,-524 # f68 <malloc+0x1e0>
 17c:	00001097          	auipc	ra,0x1
 180:	b4e080e7          	jalr	-1202(ra) # cca <printf>
 184:	4785                	li	a5,1
 186:	00001717          	auipc	a4,0x1
 18a:	1af72123          	sw	a5,418(a4) # 1328 <failed>
  int r, fd1 = -1, fd2 = -1;
 18e:	597d                	li	s2,-1
  if(c!=c2)
    fail("Value read from 4 differed from value written to 1\n");

  printf("test symlinks: ok\n");
done:
  close(fd1);
 190:	8526                	mv	a0,s1
 192:	00000097          	auipc	ra,0x0
 196:	7e0080e7          	jalr	2016(ra) # 972 <close>
  close(fd2);
 19a:	854a                	mv	a0,s2
 19c:	00000097          	auipc	ra,0x0
 1a0:	7d6080e7          	jalr	2006(ra) # 972 <close>
  int pid, i;
  int fd;
  struct stat st;
  int nchild = 2;

  printf("Start: test concurrent symlinks\n");
 1a4:	00001517          	auipc	a0,0x1
 1a8:	0a450513          	addi	a0,a0,164 # 1248 <malloc+0x4c0>
 1ac:	00001097          	auipc	ra,0x1
 1b0:	b1e080e7          	jalr	-1250(ra) # cca <printf>
    
  fd = open("/testsymlink/z", O_CREATE | O_RDWR);
 1b4:	20200593          	li	a1,514
 1b8:	00001517          	auipc	a0,0x1
 1bc:	d2850513          	addi	a0,a0,-728 # ee0 <malloc+0x158>
 1c0:	00000097          	auipc	ra,0x0
 1c4:	7ca080e7          	jalr	1994(ra) # 98a <open>
  if(fd < 0) {
 1c8:	42054263          	bltz	a0,5ec <main+0x5b0>
    printf("FAILED: open failed");
    exit(1);
  }
  close(fd);
 1cc:	00000097          	auipc	ra,0x0
 1d0:	7a6080e7          	jalr	1958(ra) # 972 <close>

  for(int j = 0; j < nchild; j++) {
    pid = fork();
 1d4:	00000097          	auipc	ra,0x0
 1d8:	76e080e7          	jalr	1902(ra) # 942 <fork>
    if(pid < 0){
 1dc:	42054563          	bltz	a0,606 <main+0x5ca>
      printf("FAILED: fork failed\n");
      exit(1);
    }
    if(pid == 0) {
 1e0:	44050063          	beqz	a0,620 <main+0x5e4>
    pid = fork();
 1e4:	00000097          	auipc	ra,0x0
 1e8:	75e080e7          	jalr	1886(ra) # 942 <fork>
    if(pid < 0){
 1ec:	40054d63          	bltz	a0,606 <main+0x5ca>
    if(pid == 0) {
 1f0:	42050863          	beqz	a0,620 <main+0x5e4>
    }
  }

  int r;
  for(int j = 0; j < nchild; j++) {
    wait(&r);
 1f4:	f9840513          	addi	a0,s0,-104
 1f8:	00000097          	auipc	ra,0x0
 1fc:	75a080e7          	jalr	1882(ra) # 952 <wait>
    if(r != 0) {
 200:	f9842783          	lw	a5,-104(s0)
 204:	4a079b63          	bnez	a5,6ba <main+0x67e>
    wait(&r);
 208:	f9840513          	addi	a0,s0,-104
 20c:	00000097          	auipc	ra,0x0
 210:	746080e7          	jalr	1862(ra) # 952 <wait>
    if(r != 0) {
 214:	f9842783          	lw	a5,-104(s0)
 218:	4a079163          	bnez	a5,6ba <main+0x67e>
      printf("test concurrent symlinks: failed\n");
      exit(1);
    }
  }
  printf("test concurrent symlinks: ok\n");
 21c:	00001517          	auipc	a0,0x1
 220:	0cc50513          	addi	a0,a0,204 # 12e8 <malloc+0x560>
 224:	00001097          	auipc	ra,0x1
 228:	aa6080e7          	jalr	-1370(ra) # cca <printf>
  exit(failed);
 22c:	00001517          	auipc	a0,0x1
 230:	0fc52503          	lw	a0,252(a0) # 1328 <failed>
 234:	00000097          	auipc	ra,0x0
 238:	716080e7          	jalr	1814(ra) # 94a <exit>
  if(fd1 < 0) fail("failed to open a");
 23c:	00001517          	auipc	a0,0x1
 240:	cec50513          	addi	a0,a0,-788 # f28 <malloc+0x1a0>
 244:	00001097          	auipc	ra,0x1
 248:	a86080e7          	jalr	-1402(ra) # cca <printf>
 24c:	4785                	li	a5,1
 24e:	00001717          	auipc	a4,0x1
 252:	0cf72d23          	sw	a5,218(a4) # 1328 <failed>
  int r, fd1 = -1, fd2 = -1;
 256:	597d                	li	s2,-1
  if(fd1 < 0) fail("failed to open a");
 258:	bf25                	j	190 <main+0x154>
    fail("symlink b -> a failed");
 25a:	00001517          	auipc	a0,0x1
 25e:	cee50513          	addi	a0,a0,-786 # f48 <malloc+0x1c0>
 262:	00001097          	auipc	ra,0x1
 266:	a68080e7          	jalr	-1432(ra) # cca <printf>
 26a:	4785                	li	a5,1
 26c:	00001717          	auipc	a4,0x1
 270:	0af72e23          	sw	a5,188(a4) # 1328 <failed>
  int r, fd1 = -1, fd2 = -1;
 274:	597d                	li	s2,-1
    fail("symlink b -> a failed");
 276:	bf29                	j	190 <main+0x154>
  if (stat_slink("/testsymlink/b", &st) != 0)
 278:	f9840593          	addi	a1,s0,-104
 27c:	00001517          	auipc	a0,0x1
 280:	c0450513          	addi	a0,a0,-1020 # e80 <malloc+0xf8>
 284:	00000097          	auipc	ra,0x0
 288:	d7c080e7          	jalr	-644(ra) # 0 <stat_slink>
 28c:	e50d                	bnez	a0,2b6 <main+0x27a>
  if(st.type != T_SYMLINK)
 28e:	fa041703          	lh	a4,-96(s0)
 292:	4791                	li	a5,4
 294:	04f70063          	beq	a4,a5,2d4 <main+0x298>
    fail("b isn't a symlink");
 298:	00001517          	auipc	a0,0x1
 29c:	d1050513          	addi	a0,a0,-752 # fa8 <malloc+0x220>
 2a0:	00001097          	auipc	ra,0x1
 2a4:	a2a080e7          	jalr	-1494(ra) # cca <printf>
 2a8:	4785                	li	a5,1
 2aa:	00001717          	auipc	a4,0x1
 2ae:	06f72f23          	sw	a5,126(a4) # 1328 <failed>
  int r, fd1 = -1, fd2 = -1;
 2b2:	597d                	li	s2,-1
    fail("b isn't a symlink");
 2b4:	bdf1                	j	190 <main+0x154>
    fail("failed to stat b");
 2b6:	00001517          	auipc	a0,0x1
 2ba:	cd250513          	addi	a0,a0,-814 # f88 <malloc+0x200>
 2be:	00001097          	auipc	ra,0x1
 2c2:	a0c080e7          	jalr	-1524(ra) # cca <printf>
 2c6:	4785                	li	a5,1
 2c8:	00001717          	auipc	a4,0x1
 2cc:	06f72023          	sw	a5,96(a4) # 1328 <failed>
  int r, fd1 = -1, fd2 = -1;
 2d0:	597d                	li	s2,-1
    fail("failed to stat b");
 2d2:	bd7d                	j	190 <main+0x154>
  fd2 = open("/testsymlink/b", O_RDWR);
 2d4:	4589                	li	a1,2
 2d6:	00001517          	auipc	a0,0x1
 2da:	baa50513          	addi	a0,a0,-1110 # e80 <malloc+0xf8>
 2de:	00000097          	auipc	ra,0x0
 2e2:	6ac080e7          	jalr	1708(ra) # 98a <open>
 2e6:	892a                	mv	s2,a0
  if(fd2 < 0)
 2e8:	02054d63          	bltz	a0,322 <main+0x2e6>
  read(fd2, &c, 1);
 2ec:	4605                	li	a2,1
 2ee:	f8e40593          	addi	a1,s0,-114
 2f2:	00000097          	auipc	ra,0x0
 2f6:	670080e7          	jalr	1648(ra) # 962 <read>
  if (c != 'a')
 2fa:	f8e44703          	lbu	a4,-114(s0)
 2fe:	06100793          	li	a5,97
 302:	02f70e63          	beq	a4,a5,33e <main+0x302>
    fail("failed to read bytes from b");
 306:	00001517          	auipc	a0,0x1
 30a:	ce250513          	addi	a0,a0,-798 # fe8 <malloc+0x260>
 30e:	00001097          	auipc	ra,0x1
 312:	9bc080e7          	jalr	-1604(ra) # cca <printf>
 316:	4785                	li	a5,1
 318:	00001717          	auipc	a4,0x1
 31c:	00f72823          	sw	a5,16(a4) # 1328 <failed>
 320:	bd85                	j	190 <main+0x154>
    fail("failed to open b");
 322:	00001517          	auipc	a0,0x1
 326:	ca650513          	addi	a0,a0,-858 # fc8 <malloc+0x240>
 32a:	00001097          	auipc	ra,0x1
 32e:	9a0080e7          	jalr	-1632(ra) # cca <printf>
 332:	4785                	li	a5,1
 334:	00001717          	auipc	a4,0x1
 338:	fef72a23          	sw	a5,-12(a4) # 1328 <failed>
 33c:	bd91                	j	190 <main+0x154>
  unlink("/testsymlink/a");
 33e:	00001517          	auipc	a0,0x1
 342:	b3250513          	addi	a0,a0,-1230 # e70 <malloc+0xe8>
 346:	00000097          	auipc	ra,0x0
 34a:	654080e7          	jalr	1620(ra) # 99a <unlink>
  if(open("/testsymlink/b", O_RDWR) >= 0)
 34e:	4589                	li	a1,2
 350:	00001517          	auipc	a0,0x1
 354:	b3050513          	addi	a0,a0,-1232 # e80 <malloc+0xf8>
 358:	00000097          	auipc	ra,0x0
 35c:	632080e7          	jalr	1586(ra) # 98a <open>
 360:	12055263          	bgez	a0,484 <main+0x448>
  r = symlink("/testsymlink/b", "/testsymlink/a");
 364:	00001597          	auipc	a1,0x1
 368:	b0c58593          	addi	a1,a1,-1268 # e70 <malloc+0xe8>
 36c:	00001517          	auipc	a0,0x1
 370:	b1450513          	addi	a0,a0,-1260 # e80 <malloc+0xf8>
 374:	00000097          	auipc	ra,0x0
 378:	676080e7          	jalr	1654(ra) # 9ea <symlink>
  if(r < 0)
 37c:	12054263          	bltz	a0,4a0 <main+0x464>
  r = open("/testsymlink/b", O_RDWR);
 380:	4589                	li	a1,2
 382:	00001517          	auipc	a0,0x1
 386:	afe50513          	addi	a0,a0,-1282 # e80 <malloc+0xf8>
 38a:	00000097          	auipc	ra,0x0
 38e:	600080e7          	jalr	1536(ra) # 98a <open>
  if(r >= 0)
 392:	12055563          	bgez	a0,4bc <main+0x480>
  r = symlink("/testsymlink/nonexistent", "/testsymlink/c");
 396:	00001597          	auipc	a1,0x1
 39a:	afa58593          	addi	a1,a1,-1286 # e90 <malloc+0x108>
 39e:	00001517          	auipc	a0,0x1
 3a2:	d0a50513          	addi	a0,a0,-758 # 10a8 <malloc+0x320>
 3a6:	00000097          	auipc	ra,0x0
 3aa:	644080e7          	jalr	1604(ra) # 9ea <symlink>
  if(r != 0)
 3ae:	12051563          	bnez	a0,4d8 <main+0x49c>
  r = symlink("/testsymlink/2", "/testsymlink/1");
 3b2:	00001597          	auipc	a1,0x1
 3b6:	aee58593          	addi	a1,a1,-1298 # ea0 <malloc+0x118>
 3ba:	00001517          	auipc	a0,0x1
 3be:	af650513          	addi	a0,a0,-1290 # eb0 <malloc+0x128>
 3c2:	00000097          	auipc	ra,0x0
 3c6:	628080e7          	jalr	1576(ra) # 9ea <symlink>
  if(r) fail("Failed to link 1->2");
 3ca:	12051563          	bnez	a0,4f4 <main+0x4b8>
  r = symlink("/testsymlink/3", "/testsymlink/2");
 3ce:	00001597          	auipc	a1,0x1
 3d2:	ae258593          	addi	a1,a1,-1310 # eb0 <malloc+0x128>
 3d6:	00001517          	auipc	a0,0x1
 3da:	aea50513          	addi	a0,a0,-1302 # ec0 <malloc+0x138>
 3de:	00000097          	auipc	ra,0x0
 3e2:	60c080e7          	jalr	1548(ra) # 9ea <symlink>
  if(r) fail("Failed to link 2->3");
 3e6:	12051563          	bnez	a0,510 <main+0x4d4>
  r = symlink("/testsymlink/4", "/testsymlink/3");
 3ea:	00001597          	auipc	a1,0x1
 3ee:	ad658593          	addi	a1,a1,-1322 # ec0 <malloc+0x138>
 3f2:	00001517          	auipc	a0,0x1
 3f6:	ade50513          	addi	a0,a0,-1314 # ed0 <malloc+0x148>
 3fa:	00000097          	auipc	ra,0x0
 3fe:	5f0080e7          	jalr	1520(ra) # 9ea <symlink>
  if(r) fail("Failed to link 3->4");
 402:	12051563          	bnez	a0,52c <main+0x4f0>
  close(fd1);
 406:	8526                	mv	a0,s1
 408:	00000097          	auipc	ra,0x0
 40c:	56a080e7          	jalr	1386(ra) # 972 <close>
  close(fd2);
 410:	854a                	mv	a0,s2
 412:	00000097          	auipc	ra,0x0
 416:	560080e7          	jalr	1376(ra) # 972 <close>
  fd1 = open("/testsymlink/4", O_CREATE | O_RDWR);
 41a:	20200593          	li	a1,514
 41e:	00001517          	auipc	a0,0x1
 422:	ab250513          	addi	a0,a0,-1358 # ed0 <malloc+0x148>
 426:	00000097          	auipc	ra,0x0
 42a:	564080e7          	jalr	1380(ra) # 98a <open>
 42e:	84aa                	mv	s1,a0
  if(fd1<0) fail("Failed to create 4\n");
 430:	10054c63          	bltz	a0,548 <main+0x50c>
  fd2 = open("/testsymlink/1", O_RDWR);
 434:	4589                	li	a1,2
 436:	00001517          	auipc	a0,0x1
 43a:	a6a50513          	addi	a0,a0,-1430 # ea0 <malloc+0x118>
 43e:	00000097          	auipc	ra,0x0
 442:	54c080e7          	jalr	1356(ra) # 98a <open>
 446:	892a                	mv	s2,a0
  if(fd2<0) fail("Failed to open 1\n");
 448:	10054e63          	bltz	a0,564 <main+0x528>
  c = '#';
 44c:	02300793          	li	a5,35
 450:	f8f40723          	sb	a5,-114(s0)
  r = write(fd2, &c, 1);
 454:	4605                	li	a2,1
 456:	f8e40593          	addi	a1,s0,-114
 45a:	00000097          	auipc	ra,0x0
 45e:	510080e7          	jalr	1296(ra) # 96a <write>
  if(r!=1) fail("Failed to write to 1\n");
 462:	4785                	li	a5,1
 464:	10f50e63          	beq	a0,a5,580 <main+0x544>
 468:	00001517          	auipc	a0,0x1
 46c:	d4050513          	addi	a0,a0,-704 # 11a8 <malloc+0x420>
 470:	00001097          	auipc	ra,0x1
 474:	85a080e7          	jalr	-1958(ra) # cca <printf>
 478:	4785                	li	a5,1
 47a:	00001717          	auipc	a4,0x1
 47e:	eaf72723          	sw	a5,-338(a4) # 1328 <failed>
 482:	b339                	j	190 <main+0x154>
    fail("Should not be able to open b after deleting a");
 484:	00001517          	auipc	a0,0x1
 488:	b8c50513          	addi	a0,a0,-1140 # 1010 <malloc+0x288>
 48c:	00001097          	auipc	ra,0x1
 490:	83e080e7          	jalr	-1986(ra) # cca <printf>
 494:	4785                	li	a5,1
 496:	00001717          	auipc	a4,0x1
 49a:	e8f72923          	sw	a5,-366(a4) # 1328 <failed>
 49e:	b9cd                	j	190 <main+0x154>
    fail("symlink a -> b failed");
 4a0:	00001517          	auipc	a0,0x1
 4a4:	ba850513          	addi	a0,a0,-1112 # 1048 <malloc+0x2c0>
 4a8:	00001097          	auipc	ra,0x1
 4ac:	822080e7          	jalr	-2014(ra) # cca <printf>
 4b0:	4785                	li	a5,1
 4b2:	00001717          	auipc	a4,0x1
 4b6:	e6f72b23          	sw	a5,-394(a4) # 1328 <failed>
 4ba:	b9d9                	j	190 <main+0x154>
    fail("Should not be able to open b (cycle b->a->b->..)\n");
 4bc:	00001517          	auipc	a0,0x1
 4c0:	bac50513          	addi	a0,a0,-1108 # 1068 <malloc+0x2e0>
 4c4:	00001097          	auipc	ra,0x1
 4c8:	806080e7          	jalr	-2042(ra) # cca <printf>
 4cc:	4785                	li	a5,1
 4ce:	00001717          	auipc	a4,0x1
 4d2:	e4f72d23          	sw	a5,-422(a4) # 1328 <failed>
 4d6:	b96d                	j	190 <main+0x154>
    fail("Symlinking to nonexistent file should succeed\n");
 4d8:	00001517          	auipc	a0,0x1
 4dc:	bf050513          	addi	a0,a0,-1040 # 10c8 <malloc+0x340>
 4e0:	00000097          	auipc	ra,0x0
 4e4:	7ea080e7          	jalr	2026(ra) # cca <printf>
 4e8:	4785                	li	a5,1
 4ea:	00001717          	auipc	a4,0x1
 4ee:	e2f72f23          	sw	a5,-450(a4) # 1328 <failed>
 4f2:	b979                	j	190 <main+0x154>
  if(r) fail("Failed to link 1->2");
 4f4:	00001517          	auipc	a0,0x1
 4f8:	c1450513          	addi	a0,a0,-1004 # 1108 <malloc+0x380>
 4fc:	00000097          	auipc	ra,0x0
 500:	7ce080e7          	jalr	1998(ra) # cca <printf>
 504:	4785                	li	a5,1
 506:	00001717          	auipc	a4,0x1
 50a:	e2f72123          	sw	a5,-478(a4) # 1328 <failed>
 50e:	b149                	j	190 <main+0x154>
  if(r) fail("Failed to link 2->3");
 510:	00001517          	auipc	a0,0x1
 514:	c1850513          	addi	a0,a0,-1000 # 1128 <malloc+0x3a0>
 518:	00000097          	auipc	ra,0x0
 51c:	7b2080e7          	jalr	1970(ra) # cca <printf>
 520:	4785                	li	a5,1
 522:	00001717          	auipc	a4,0x1
 526:	e0f72323          	sw	a5,-506(a4) # 1328 <failed>
 52a:	b19d                	j	190 <main+0x154>
  if(r) fail("Failed to link 3->4");
 52c:	00001517          	auipc	a0,0x1
 530:	c1c50513          	addi	a0,a0,-996 # 1148 <malloc+0x3c0>
 534:	00000097          	auipc	ra,0x0
 538:	796080e7          	jalr	1942(ra) # cca <printf>
 53c:	4785                	li	a5,1
 53e:	00001717          	auipc	a4,0x1
 542:	def72523          	sw	a5,-534(a4) # 1328 <failed>
 546:	b1a9                	j	190 <main+0x154>
  if(fd1<0) fail("Failed to create 4\n");
 548:	00001517          	auipc	a0,0x1
 54c:	c2050513          	addi	a0,a0,-992 # 1168 <malloc+0x3e0>
 550:	00000097          	auipc	ra,0x0
 554:	77a080e7          	jalr	1914(ra) # cca <printf>
 558:	4785                	li	a5,1
 55a:	00001717          	auipc	a4,0x1
 55e:	dcf72723          	sw	a5,-562(a4) # 1328 <failed>
 562:	b13d                	j	190 <main+0x154>
  if(fd2<0) fail("Failed to open 1\n");
 564:	00001517          	auipc	a0,0x1
 568:	c2450513          	addi	a0,a0,-988 # 1188 <malloc+0x400>
 56c:	00000097          	auipc	ra,0x0
 570:	75e080e7          	jalr	1886(ra) # cca <printf>
 574:	4785                	li	a5,1
 576:	00001717          	auipc	a4,0x1
 57a:	daf72923          	sw	a5,-590(a4) # 1328 <failed>
 57e:	b909                	j	190 <main+0x154>
  r = read(fd1, &c2, 1);
 580:	4605                	li	a2,1
 582:	f8f40593          	addi	a1,s0,-113
 586:	8526                	mv	a0,s1
 588:	00000097          	auipc	ra,0x0
 58c:	3da080e7          	jalr	986(ra) # 962 <read>
  if(r!=1) fail("Failed to read from 4\n");
 590:	4785                	li	a5,1
 592:	02f51663          	bne	a0,a5,5be <main+0x582>
  if(c!=c2)
 596:	f8e44703          	lbu	a4,-114(s0)
 59a:	f8f44783          	lbu	a5,-113(s0)
 59e:	02f70e63          	beq	a4,a5,5da <main+0x59e>
    fail("Value read from 4 differed from value written to 1\n");
 5a2:	00001517          	auipc	a0,0x1
 5a6:	c4e50513          	addi	a0,a0,-946 # 11f0 <malloc+0x468>
 5aa:	00000097          	auipc	ra,0x0
 5ae:	720080e7          	jalr	1824(ra) # cca <printf>
 5b2:	4785                	li	a5,1
 5b4:	00001717          	auipc	a4,0x1
 5b8:	d6f72a23          	sw	a5,-652(a4) # 1328 <failed>
 5bc:	bed1                	j	190 <main+0x154>
  if(r!=1) fail("Failed to read from 4\n");
 5be:	00001517          	auipc	a0,0x1
 5c2:	c0a50513          	addi	a0,a0,-1014 # 11c8 <malloc+0x440>
 5c6:	00000097          	auipc	ra,0x0
 5ca:	704080e7          	jalr	1796(ra) # cca <printf>
 5ce:	4785                	li	a5,1
 5d0:	00001717          	auipc	a4,0x1
 5d4:	d4f72c23          	sw	a5,-680(a4) # 1328 <failed>
 5d8:	be65                	j	190 <main+0x154>
  printf("test symlinks: ok\n");
 5da:	00001517          	auipc	a0,0x1
 5de:	c5650513          	addi	a0,a0,-938 # 1230 <malloc+0x4a8>
 5e2:	00000097          	auipc	ra,0x0
 5e6:	6e8080e7          	jalr	1768(ra) # cca <printf>
 5ea:	b65d                	j	190 <main+0x154>
    printf("FAILED: open failed");
 5ec:	00001517          	auipc	a0,0x1
 5f0:	c8450513          	addi	a0,a0,-892 # 1270 <malloc+0x4e8>
 5f4:	00000097          	auipc	ra,0x0
 5f8:	6d6080e7          	jalr	1750(ra) # cca <printf>
    exit(1);
 5fc:	4505                	li	a0,1
 5fe:	00000097          	auipc	ra,0x0
 602:	34c080e7          	jalr	844(ra) # 94a <exit>
      printf("FAILED: fork failed\n");
 606:	00001517          	auipc	a0,0x1
 60a:	c8250513          	addi	a0,a0,-894 # 1288 <malloc+0x500>
 60e:	00000097          	auipc	ra,0x0
 612:	6bc080e7          	jalr	1724(ra) # cca <printf>
      exit(1);
 616:	4505                	li	a0,1
 618:	00000097          	auipc	ra,0x0
 61c:	332080e7          	jalr	818(ra) # 94a <exit>
  int r, fd1 = -1, fd2 = -1;
 620:	06400913          	li	s2,100
      unsigned int x = (pid ? 1 : 97);
 624:	06100c13          	li	s8,97
        x = x * 1103515245 + 12345;
 628:	41c65a37          	lui	s4,0x41c65
 62c:	e6da0a1b          	addiw	s4,s4,-403
 630:	698d                	lui	s3,0x3
 632:	0399899b          	addiw	s3,s3,57
        if((x % 3) == 0) {
 636:	4b8d                	li	s7,3
          unlink("/testsymlink/y");
 638:	00001497          	auipc	s1,0x1
 63c:	8b848493          	addi	s1,s1,-1864 # ef0 <malloc+0x168>
          symlink("/testsymlink/z", "/testsymlink/y");
 640:	00001b17          	auipc	s6,0x1
 644:	8a0b0b13          	addi	s6,s6,-1888 # ee0 <malloc+0x158>
            if(st.type != T_SYMLINK) {
 648:	4a91                	li	s5,4
 64a:	a809                	j	65c <main+0x620>
          unlink("/testsymlink/y");
 64c:	8526                	mv	a0,s1
 64e:	00000097          	auipc	ra,0x0
 652:	34c080e7          	jalr	844(ra) # 99a <unlink>
      for(i = 0; i < 100; i++){
 656:	397d                	addiw	s2,s2,-1
 658:	04090c63          	beqz	s2,6b0 <main+0x674>
        x = x * 1103515245 + 12345;
 65c:	034c07bb          	mulw	a5,s8,s4
 660:	013787bb          	addw	a5,a5,s3
 664:	00078c1b          	sext.w	s8,a5
        if((x % 3) == 0) {
 668:	0377f7bb          	remuw	a5,a5,s7
 66c:	f3e5                	bnez	a5,64c <main+0x610>
          symlink("/testsymlink/z", "/testsymlink/y");
 66e:	85a6                	mv	a1,s1
 670:	855a                	mv	a0,s6
 672:	00000097          	auipc	ra,0x0
 676:	378080e7          	jalr	888(ra) # 9ea <symlink>
          if (stat_slink("/testsymlink/y", &st) == 0) {
 67a:	f9840593          	addi	a1,s0,-104
 67e:	8526                	mv	a0,s1
 680:	00000097          	auipc	ra,0x0
 684:	980080e7          	jalr	-1664(ra) # 0 <stat_slink>
 688:	f579                	bnez	a0,656 <main+0x61a>
            if(st.type != T_SYMLINK) {
 68a:	fa041583          	lh	a1,-96(s0)
 68e:	0005879b          	sext.w	a5,a1
 692:	fd5782e3          	beq	a5,s5,656 <main+0x61a>
              printf("FAILED: not a symbolic link\n", st.type);
 696:	00001517          	auipc	a0,0x1
 69a:	c0a50513          	addi	a0,a0,-1014 # 12a0 <malloc+0x518>
 69e:	00000097          	auipc	ra,0x0
 6a2:	62c080e7          	jalr	1580(ra) # cca <printf>
              exit(1);
 6a6:	4505                	li	a0,1
 6a8:	00000097          	auipc	ra,0x0
 6ac:	2a2080e7          	jalr	674(ra) # 94a <exit>
      exit(0);
 6b0:	4501                	li	a0,0
 6b2:	00000097          	auipc	ra,0x0
 6b6:	298080e7          	jalr	664(ra) # 94a <exit>
      printf("test concurrent symlinks: failed\n");
 6ba:	00001517          	auipc	a0,0x1
 6be:	c0650513          	addi	a0,a0,-1018 # 12c0 <malloc+0x538>
 6c2:	00000097          	auipc	ra,0x0
 6c6:	608080e7          	jalr	1544(ra) # cca <printf>
      exit(1);
 6ca:	4505                	li	a0,1
 6cc:	00000097          	auipc	ra,0x0
 6d0:	27e080e7          	jalr	638(ra) # 94a <exit>

00000000000006d4 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 6d4:	1141                	addi	sp,sp,-16
 6d6:	e422                	sd	s0,8(sp)
 6d8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 6da:	87aa                	mv	a5,a0
 6dc:	0585                	addi	a1,a1,1
 6de:	0785                	addi	a5,a5,1
 6e0:	fff5c703          	lbu	a4,-1(a1)
 6e4:	fee78fa3          	sb	a4,-1(a5) # 64635fff <__global_pointer$+0x646344de>
 6e8:	fb75                	bnez	a4,6dc <strcpy+0x8>
    ;
  return os;
}
 6ea:	6422                	ld	s0,8(sp)
 6ec:	0141                	addi	sp,sp,16
 6ee:	8082                	ret

00000000000006f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 6f0:	1141                	addi	sp,sp,-16
 6f2:	e422                	sd	s0,8(sp)
 6f4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 6f6:	00054783          	lbu	a5,0(a0)
 6fa:	cb91                	beqz	a5,70e <strcmp+0x1e>
 6fc:	0005c703          	lbu	a4,0(a1)
 700:	00f71763          	bne	a4,a5,70e <strcmp+0x1e>
    p++, q++;
 704:	0505                	addi	a0,a0,1
 706:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 708:	00054783          	lbu	a5,0(a0)
 70c:	fbe5                	bnez	a5,6fc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 70e:	0005c503          	lbu	a0,0(a1)
}
 712:	40a7853b          	subw	a0,a5,a0
 716:	6422                	ld	s0,8(sp)
 718:	0141                	addi	sp,sp,16
 71a:	8082                	ret

000000000000071c <strlen>:

uint
strlen(const char *s)
{
 71c:	1141                	addi	sp,sp,-16
 71e:	e422                	sd	s0,8(sp)
 720:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 722:	00054783          	lbu	a5,0(a0)
 726:	cf91                	beqz	a5,742 <strlen+0x26>
 728:	0505                	addi	a0,a0,1
 72a:	87aa                	mv	a5,a0
 72c:	4685                	li	a3,1
 72e:	9e89                	subw	a3,a3,a0
 730:	00f6853b          	addw	a0,a3,a5
 734:	0785                	addi	a5,a5,1
 736:	fff7c703          	lbu	a4,-1(a5)
 73a:	fb7d                	bnez	a4,730 <strlen+0x14>
    ;
  return n;
}
 73c:	6422                	ld	s0,8(sp)
 73e:	0141                	addi	sp,sp,16
 740:	8082                	ret
  for(n = 0; s[n]; n++)
 742:	4501                	li	a0,0
 744:	bfe5                	j	73c <strlen+0x20>

0000000000000746 <memset>:

void*
memset(void *dst, int c, uint n)
{
 746:	1141                	addi	sp,sp,-16
 748:	e422                	sd	s0,8(sp)
 74a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 74c:	ce09                	beqz	a2,766 <memset+0x20>
 74e:	87aa                	mv	a5,a0
 750:	fff6071b          	addiw	a4,a2,-1
 754:	1702                	slli	a4,a4,0x20
 756:	9301                	srli	a4,a4,0x20
 758:	0705                	addi	a4,a4,1
 75a:	972a                	add	a4,a4,a0
    cdst[i] = c;
 75c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 760:	0785                	addi	a5,a5,1
 762:	fee79de3          	bne	a5,a4,75c <memset+0x16>
  }
  return dst;
}
 766:	6422                	ld	s0,8(sp)
 768:	0141                	addi	sp,sp,16
 76a:	8082                	ret

000000000000076c <strchr>:

char*
strchr(const char *s, char c)
{
 76c:	1141                	addi	sp,sp,-16
 76e:	e422                	sd	s0,8(sp)
 770:	0800                	addi	s0,sp,16
  for(; *s; s++)
 772:	00054783          	lbu	a5,0(a0)
 776:	cb99                	beqz	a5,78c <strchr+0x20>
    if(*s == c)
 778:	00f58763          	beq	a1,a5,786 <strchr+0x1a>
  for(; *s; s++)
 77c:	0505                	addi	a0,a0,1
 77e:	00054783          	lbu	a5,0(a0)
 782:	fbfd                	bnez	a5,778 <strchr+0xc>
      return (char*)s;
  return 0;
 784:	4501                	li	a0,0
}
 786:	6422                	ld	s0,8(sp)
 788:	0141                	addi	sp,sp,16
 78a:	8082                	ret
  return 0;
 78c:	4501                	li	a0,0
 78e:	bfe5                	j	786 <strchr+0x1a>

0000000000000790 <gets>:

char*
gets(char *buf, int max)
{
 790:	711d                	addi	sp,sp,-96
 792:	ec86                	sd	ra,88(sp)
 794:	e8a2                	sd	s0,80(sp)
 796:	e4a6                	sd	s1,72(sp)
 798:	e0ca                	sd	s2,64(sp)
 79a:	fc4e                	sd	s3,56(sp)
 79c:	f852                	sd	s4,48(sp)
 79e:	f456                	sd	s5,40(sp)
 7a0:	f05a                	sd	s6,32(sp)
 7a2:	ec5e                	sd	s7,24(sp)
 7a4:	1080                	addi	s0,sp,96
 7a6:	8baa                	mv	s7,a0
 7a8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 7aa:	892a                	mv	s2,a0
 7ac:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 7ae:	4aa9                	li	s5,10
 7b0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 7b2:	89a6                	mv	s3,s1
 7b4:	2485                	addiw	s1,s1,1
 7b6:	0344d863          	bge	s1,s4,7e6 <gets+0x56>
    cc = read(0, &c, 1);
 7ba:	4605                	li	a2,1
 7bc:	faf40593          	addi	a1,s0,-81
 7c0:	4501                	li	a0,0
 7c2:	00000097          	auipc	ra,0x0
 7c6:	1a0080e7          	jalr	416(ra) # 962 <read>
    if(cc < 1)
 7ca:	00a05e63          	blez	a0,7e6 <gets+0x56>
    buf[i++] = c;
 7ce:	faf44783          	lbu	a5,-81(s0)
 7d2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 7d6:	01578763          	beq	a5,s5,7e4 <gets+0x54>
 7da:	0905                	addi	s2,s2,1
 7dc:	fd679be3          	bne	a5,s6,7b2 <gets+0x22>
  for(i=0; i+1 < max; ){
 7e0:	89a6                	mv	s3,s1
 7e2:	a011                	j	7e6 <gets+0x56>
 7e4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 7e6:	99de                	add	s3,s3,s7
 7e8:	00098023          	sb	zero,0(s3) # 3000 <__global_pointer$+0x14df>
  return buf;
}
 7ec:	855e                	mv	a0,s7
 7ee:	60e6                	ld	ra,88(sp)
 7f0:	6446                	ld	s0,80(sp)
 7f2:	64a6                	ld	s1,72(sp)
 7f4:	6906                	ld	s2,64(sp)
 7f6:	79e2                	ld	s3,56(sp)
 7f8:	7a42                	ld	s4,48(sp)
 7fa:	7aa2                	ld	s5,40(sp)
 7fc:	7b02                	ld	s6,32(sp)
 7fe:	6be2                	ld	s7,24(sp)
 800:	6125                	addi	sp,sp,96
 802:	8082                	ret

0000000000000804 <stat>:

int
stat(const char *n, struct stat *st)
{
 804:	1101                	addi	sp,sp,-32
 806:	ec06                	sd	ra,24(sp)
 808:	e822                	sd	s0,16(sp)
 80a:	e426                	sd	s1,8(sp)
 80c:	e04a                	sd	s2,0(sp)
 80e:	1000                	addi	s0,sp,32
 810:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 812:	4581                	li	a1,0
 814:	00000097          	auipc	ra,0x0
 818:	176080e7          	jalr	374(ra) # 98a <open>
  if(fd < 0)
 81c:	02054563          	bltz	a0,846 <stat+0x42>
 820:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 822:	85ca                	mv	a1,s2
 824:	00000097          	auipc	ra,0x0
 828:	17e080e7          	jalr	382(ra) # 9a2 <fstat>
 82c:	892a                	mv	s2,a0
  close(fd);
 82e:	8526                	mv	a0,s1
 830:	00000097          	auipc	ra,0x0
 834:	142080e7          	jalr	322(ra) # 972 <close>
  return r;
}
 838:	854a                	mv	a0,s2
 83a:	60e2                	ld	ra,24(sp)
 83c:	6442                	ld	s0,16(sp)
 83e:	64a2                	ld	s1,8(sp)
 840:	6902                	ld	s2,0(sp)
 842:	6105                	addi	sp,sp,32
 844:	8082                	ret
    return -1;
 846:	597d                	li	s2,-1
 848:	bfc5                	j	838 <stat+0x34>

000000000000084a <atoi>:

int
atoi(const char *s)
{
 84a:	1141                	addi	sp,sp,-16
 84c:	e422                	sd	s0,8(sp)
 84e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 850:	00054603          	lbu	a2,0(a0)
 854:	fd06079b          	addiw	a5,a2,-48
 858:	0ff7f793          	andi	a5,a5,255
 85c:	4725                	li	a4,9
 85e:	02f76963          	bltu	a4,a5,890 <atoi+0x46>
 862:	86aa                	mv	a3,a0
  n = 0;
 864:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 866:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 868:	0685                	addi	a3,a3,1
 86a:	0025179b          	slliw	a5,a0,0x2
 86e:	9fa9                	addw	a5,a5,a0
 870:	0017979b          	slliw	a5,a5,0x1
 874:	9fb1                	addw	a5,a5,a2
 876:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 87a:	0006c603          	lbu	a2,0(a3)
 87e:	fd06071b          	addiw	a4,a2,-48
 882:	0ff77713          	andi	a4,a4,255
 886:	fee5f1e3          	bgeu	a1,a4,868 <atoi+0x1e>
  return n;
}
 88a:	6422                	ld	s0,8(sp)
 88c:	0141                	addi	sp,sp,16
 88e:	8082                	ret
  n = 0;
 890:	4501                	li	a0,0
 892:	bfe5                	j	88a <atoi+0x40>

0000000000000894 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 894:	1141                	addi	sp,sp,-16
 896:	e422                	sd	s0,8(sp)
 898:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 89a:	02b57663          	bgeu	a0,a1,8c6 <memmove+0x32>
    while(n-- > 0)
 89e:	02c05163          	blez	a2,8c0 <memmove+0x2c>
 8a2:	fff6079b          	addiw	a5,a2,-1
 8a6:	1782                	slli	a5,a5,0x20
 8a8:	9381                	srli	a5,a5,0x20
 8aa:	0785                	addi	a5,a5,1
 8ac:	97aa                	add	a5,a5,a0
  dst = vdst;
 8ae:	872a                	mv	a4,a0
      *dst++ = *src++;
 8b0:	0585                	addi	a1,a1,1
 8b2:	0705                	addi	a4,a4,1
 8b4:	fff5c683          	lbu	a3,-1(a1)
 8b8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 8bc:	fee79ae3          	bne	a5,a4,8b0 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 8c0:	6422                	ld	s0,8(sp)
 8c2:	0141                	addi	sp,sp,16
 8c4:	8082                	ret
    dst += n;
 8c6:	00c50733          	add	a4,a0,a2
    src += n;
 8ca:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 8cc:	fec05ae3          	blez	a2,8c0 <memmove+0x2c>
 8d0:	fff6079b          	addiw	a5,a2,-1
 8d4:	1782                	slli	a5,a5,0x20
 8d6:	9381                	srli	a5,a5,0x20
 8d8:	fff7c793          	not	a5,a5
 8dc:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 8de:	15fd                	addi	a1,a1,-1
 8e0:	177d                	addi	a4,a4,-1
 8e2:	0005c683          	lbu	a3,0(a1)
 8e6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 8ea:	fee79ae3          	bne	a5,a4,8de <memmove+0x4a>
 8ee:	bfc9                	j	8c0 <memmove+0x2c>

00000000000008f0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 8f0:	1141                	addi	sp,sp,-16
 8f2:	e422                	sd	s0,8(sp)
 8f4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 8f6:	ca05                	beqz	a2,926 <memcmp+0x36>
 8f8:	fff6069b          	addiw	a3,a2,-1
 8fc:	1682                	slli	a3,a3,0x20
 8fe:	9281                	srli	a3,a3,0x20
 900:	0685                	addi	a3,a3,1
 902:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 904:	00054783          	lbu	a5,0(a0)
 908:	0005c703          	lbu	a4,0(a1)
 90c:	00e79863          	bne	a5,a4,91c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 910:	0505                	addi	a0,a0,1
    p2++;
 912:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 914:	fed518e3          	bne	a0,a3,904 <memcmp+0x14>
  }
  return 0;
 918:	4501                	li	a0,0
 91a:	a019                	j	920 <memcmp+0x30>
      return *p1 - *p2;
 91c:	40e7853b          	subw	a0,a5,a4
}
 920:	6422                	ld	s0,8(sp)
 922:	0141                	addi	sp,sp,16
 924:	8082                	ret
  return 0;
 926:	4501                	li	a0,0
 928:	bfe5                	j	920 <memcmp+0x30>

000000000000092a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 92a:	1141                	addi	sp,sp,-16
 92c:	e406                	sd	ra,8(sp)
 92e:	e022                	sd	s0,0(sp)
 930:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 932:	00000097          	auipc	ra,0x0
 936:	f62080e7          	jalr	-158(ra) # 894 <memmove>
}
 93a:	60a2                	ld	ra,8(sp)
 93c:	6402                	ld	s0,0(sp)
 93e:	0141                	addi	sp,sp,16
 940:	8082                	ret

0000000000000942 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 942:	4885                	li	a7,1
 ecall
 944:	00000073          	ecall
 ret
 948:	8082                	ret

000000000000094a <exit>:
.global exit
exit:
 li a7, SYS_exit
 94a:	4889                	li	a7,2
 ecall
 94c:	00000073          	ecall
 ret
 950:	8082                	ret

0000000000000952 <wait>:
.global wait
wait:
 li a7, SYS_wait
 952:	488d                	li	a7,3
 ecall
 954:	00000073          	ecall
 ret
 958:	8082                	ret

000000000000095a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 95a:	4891                	li	a7,4
 ecall
 95c:	00000073          	ecall
 ret
 960:	8082                	ret

0000000000000962 <read>:
.global read
read:
 li a7, SYS_read
 962:	4895                	li	a7,5
 ecall
 964:	00000073          	ecall
 ret
 968:	8082                	ret

000000000000096a <write>:
.global write
write:
 li a7, SYS_write
 96a:	48c1                	li	a7,16
 ecall
 96c:	00000073          	ecall
 ret
 970:	8082                	ret

0000000000000972 <close>:
.global close
close:
 li a7, SYS_close
 972:	48d5                	li	a7,21
 ecall
 974:	00000073          	ecall
 ret
 978:	8082                	ret

000000000000097a <kill>:
.global kill
kill:
 li a7, SYS_kill
 97a:	4899                	li	a7,6
 ecall
 97c:	00000073          	ecall
 ret
 980:	8082                	ret

0000000000000982 <exec>:
.global exec
exec:
 li a7, SYS_exec
 982:	489d                	li	a7,7
 ecall
 984:	00000073          	ecall
 ret
 988:	8082                	ret

000000000000098a <open>:
.global open
open:
 li a7, SYS_open
 98a:	48bd                	li	a7,15
 ecall
 98c:	00000073          	ecall
 ret
 990:	8082                	ret

0000000000000992 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 992:	48c5                	li	a7,17
 ecall
 994:	00000073          	ecall
 ret
 998:	8082                	ret

000000000000099a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 99a:	48c9                	li	a7,18
 ecall
 99c:	00000073          	ecall
 ret
 9a0:	8082                	ret

00000000000009a2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 9a2:	48a1                	li	a7,8
 ecall
 9a4:	00000073          	ecall
 ret
 9a8:	8082                	ret

00000000000009aa <link>:
.global link
link:
 li a7, SYS_link
 9aa:	48cd                	li	a7,19
 ecall
 9ac:	00000073          	ecall
 ret
 9b0:	8082                	ret

00000000000009b2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 9b2:	48d1                	li	a7,20
 ecall
 9b4:	00000073          	ecall
 ret
 9b8:	8082                	ret

00000000000009ba <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 9ba:	48a5                	li	a7,9
 ecall
 9bc:	00000073          	ecall
 ret
 9c0:	8082                	ret

00000000000009c2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 9c2:	48a9                	li	a7,10
 ecall
 9c4:	00000073          	ecall
 ret
 9c8:	8082                	ret

00000000000009ca <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 9ca:	48ad                	li	a7,11
 ecall
 9cc:	00000073          	ecall
 ret
 9d0:	8082                	ret

00000000000009d2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 9d2:	48b1                	li	a7,12
 ecall
 9d4:	00000073          	ecall
 ret
 9d8:	8082                	ret

00000000000009da <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 9da:	48b5                	li	a7,13
 ecall
 9dc:	00000073          	ecall
 ret
 9e0:	8082                	ret

00000000000009e2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 9e2:	48b9                	li	a7,14
 ecall
 9e4:	00000073          	ecall
 ret
 9e8:	8082                	ret

00000000000009ea <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 9ea:	48d9                	li	a7,22
 ecall
 9ec:	00000073          	ecall
 ret
 9f0:	8082                	ret

00000000000009f2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 9f2:	1101                	addi	sp,sp,-32
 9f4:	ec06                	sd	ra,24(sp)
 9f6:	e822                	sd	s0,16(sp)
 9f8:	1000                	addi	s0,sp,32
 9fa:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 9fe:	4605                	li	a2,1
 a00:	fef40593          	addi	a1,s0,-17
 a04:	00000097          	auipc	ra,0x0
 a08:	f66080e7          	jalr	-154(ra) # 96a <write>
}
 a0c:	60e2                	ld	ra,24(sp)
 a0e:	6442                	ld	s0,16(sp)
 a10:	6105                	addi	sp,sp,32
 a12:	8082                	ret

0000000000000a14 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 a14:	7139                	addi	sp,sp,-64
 a16:	fc06                	sd	ra,56(sp)
 a18:	f822                	sd	s0,48(sp)
 a1a:	f426                	sd	s1,40(sp)
 a1c:	f04a                	sd	s2,32(sp)
 a1e:	ec4e                	sd	s3,24(sp)
 a20:	0080                	addi	s0,sp,64
 a22:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 a24:	c299                	beqz	a3,a2a <printint+0x16>
 a26:	0805c863          	bltz	a1,ab6 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 a2a:	2581                	sext.w	a1,a1
  neg = 0;
 a2c:	4881                	li	a7,0
 a2e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 a32:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 a34:	2601                	sext.w	a2,a2
 a36:	00001517          	auipc	a0,0x1
 a3a:	8da50513          	addi	a0,a0,-1830 # 1310 <digits>
 a3e:	883a                	mv	a6,a4
 a40:	2705                	addiw	a4,a4,1
 a42:	02c5f7bb          	remuw	a5,a1,a2
 a46:	1782                	slli	a5,a5,0x20
 a48:	9381                	srli	a5,a5,0x20
 a4a:	97aa                	add	a5,a5,a0
 a4c:	0007c783          	lbu	a5,0(a5)
 a50:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 a54:	0005879b          	sext.w	a5,a1
 a58:	02c5d5bb          	divuw	a1,a1,a2
 a5c:	0685                	addi	a3,a3,1
 a5e:	fec7f0e3          	bgeu	a5,a2,a3e <printint+0x2a>
  if(neg)
 a62:	00088b63          	beqz	a7,a78 <printint+0x64>
    buf[i++] = '-';
 a66:	fd040793          	addi	a5,s0,-48
 a6a:	973e                	add	a4,a4,a5
 a6c:	02d00793          	li	a5,45
 a70:	fef70823          	sb	a5,-16(a4)
 a74:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 a78:	02e05863          	blez	a4,aa8 <printint+0x94>
 a7c:	fc040793          	addi	a5,s0,-64
 a80:	00e78933          	add	s2,a5,a4
 a84:	fff78993          	addi	s3,a5,-1
 a88:	99ba                	add	s3,s3,a4
 a8a:	377d                	addiw	a4,a4,-1
 a8c:	1702                	slli	a4,a4,0x20
 a8e:	9301                	srli	a4,a4,0x20
 a90:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 a94:	fff94583          	lbu	a1,-1(s2)
 a98:	8526                	mv	a0,s1
 a9a:	00000097          	auipc	ra,0x0
 a9e:	f58080e7          	jalr	-168(ra) # 9f2 <putc>
  while(--i >= 0)
 aa2:	197d                	addi	s2,s2,-1
 aa4:	ff3918e3          	bne	s2,s3,a94 <printint+0x80>
}
 aa8:	70e2                	ld	ra,56(sp)
 aaa:	7442                	ld	s0,48(sp)
 aac:	74a2                	ld	s1,40(sp)
 aae:	7902                	ld	s2,32(sp)
 ab0:	69e2                	ld	s3,24(sp)
 ab2:	6121                	addi	sp,sp,64
 ab4:	8082                	ret
    x = -xx;
 ab6:	40b005bb          	negw	a1,a1
    neg = 1;
 aba:	4885                	li	a7,1
    x = -xx;
 abc:	bf8d                	j	a2e <printint+0x1a>

0000000000000abe <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 abe:	7119                	addi	sp,sp,-128
 ac0:	fc86                	sd	ra,120(sp)
 ac2:	f8a2                	sd	s0,112(sp)
 ac4:	f4a6                	sd	s1,104(sp)
 ac6:	f0ca                	sd	s2,96(sp)
 ac8:	ecce                	sd	s3,88(sp)
 aca:	e8d2                	sd	s4,80(sp)
 acc:	e4d6                	sd	s5,72(sp)
 ace:	e0da                	sd	s6,64(sp)
 ad0:	fc5e                	sd	s7,56(sp)
 ad2:	f862                	sd	s8,48(sp)
 ad4:	f466                	sd	s9,40(sp)
 ad6:	f06a                	sd	s10,32(sp)
 ad8:	ec6e                	sd	s11,24(sp)
 ada:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 adc:	0005c903          	lbu	s2,0(a1)
 ae0:	18090f63          	beqz	s2,c7e <vprintf+0x1c0>
 ae4:	8aaa                	mv	s5,a0
 ae6:	8b32                	mv	s6,a2
 ae8:	00158493          	addi	s1,a1,1
  state = 0;
 aec:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 aee:	02500a13          	li	s4,37
      if(c == 'd'){
 af2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 af6:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 afa:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 afe:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 b02:	00001b97          	auipc	s7,0x1
 b06:	80eb8b93          	addi	s7,s7,-2034 # 1310 <digits>
 b0a:	a839                	j	b28 <vprintf+0x6a>
        putc(fd, c);
 b0c:	85ca                	mv	a1,s2
 b0e:	8556                	mv	a0,s5
 b10:	00000097          	auipc	ra,0x0
 b14:	ee2080e7          	jalr	-286(ra) # 9f2 <putc>
 b18:	a019                	j	b1e <vprintf+0x60>
    } else if(state == '%'){
 b1a:	01498f63          	beq	s3,s4,b38 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 b1e:	0485                	addi	s1,s1,1
 b20:	fff4c903          	lbu	s2,-1(s1)
 b24:	14090d63          	beqz	s2,c7e <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 b28:	0009079b          	sext.w	a5,s2
    if(state == 0){
 b2c:	fe0997e3          	bnez	s3,b1a <vprintf+0x5c>
      if(c == '%'){
 b30:	fd479ee3          	bne	a5,s4,b0c <vprintf+0x4e>
        state = '%';
 b34:	89be                	mv	s3,a5
 b36:	b7e5                	j	b1e <vprintf+0x60>
      if(c == 'd'){
 b38:	05878063          	beq	a5,s8,b78 <vprintf+0xba>
      } else if(c == 'l') {
 b3c:	05978c63          	beq	a5,s9,b94 <vprintf+0xd6>
      } else if(c == 'x') {
 b40:	07a78863          	beq	a5,s10,bb0 <vprintf+0xf2>
      } else if(c == 'p') {
 b44:	09b78463          	beq	a5,s11,bcc <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 b48:	07300713          	li	a4,115
 b4c:	0ce78663          	beq	a5,a4,c18 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 b50:	06300713          	li	a4,99
 b54:	0ee78e63          	beq	a5,a4,c50 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 b58:	11478863          	beq	a5,s4,c68 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 b5c:	85d2                	mv	a1,s4
 b5e:	8556                	mv	a0,s5
 b60:	00000097          	auipc	ra,0x0
 b64:	e92080e7          	jalr	-366(ra) # 9f2 <putc>
        putc(fd, c);
 b68:	85ca                	mv	a1,s2
 b6a:	8556                	mv	a0,s5
 b6c:	00000097          	auipc	ra,0x0
 b70:	e86080e7          	jalr	-378(ra) # 9f2 <putc>
      }
      state = 0;
 b74:	4981                	li	s3,0
 b76:	b765                	j	b1e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 b78:	008b0913          	addi	s2,s6,8
 b7c:	4685                	li	a3,1
 b7e:	4629                	li	a2,10
 b80:	000b2583          	lw	a1,0(s6)
 b84:	8556                	mv	a0,s5
 b86:	00000097          	auipc	ra,0x0
 b8a:	e8e080e7          	jalr	-370(ra) # a14 <printint>
 b8e:	8b4a                	mv	s6,s2
      state = 0;
 b90:	4981                	li	s3,0
 b92:	b771                	j	b1e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 b94:	008b0913          	addi	s2,s6,8
 b98:	4681                	li	a3,0
 b9a:	4629                	li	a2,10
 b9c:	000b2583          	lw	a1,0(s6)
 ba0:	8556                	mv	a0,s5
 ba2:	00000097          	auipc	ra,0x0
 ba6:	e72080e7          	jalr	-398(ra) # a14 <printint>
 baa:	8b4a                	mv	s6,s2
      state = 0;
 bac:	4981                	li	s3,0
 bae:	bf85                	j	b1e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 bb0:	008b0913          	addi	s2,s6,8
 bb4:	4681                	li	a3,0
 bb6:	4641                	li	a2,16
 bb8:	000b2583          	lw	a1,0(s6)
 bbc:	8556                	mv	a0,s5
 bbe:	00000097          	auipc	ra,0x0
 bc2:	e56080e7          	jalr	-426(ra) # a14 <printint>
 bc6:	8b4a                	mv	s6,s2
      state = 0;
 bc8:	4981                	li	s3,0
 bca:	bf91                	j	b1e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 bcc:	008b0793          	addi	a5,s6,8
 bd0:	f8f43423          	sd	a5,-120(s0)
 bd4:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 bd8:	03000593          	li	a1,48
 bdc:	8556                	mv	a0,s5
 bde:	00000097          	auipc	ra,0x0
 be2:	e14080e7          	jalr	-492(ra) # 9f2 <putc>
  putc(fd, 'x');
 be6:	85ea                	mv	a1,s10
 be8:	8556                	mv	a0,s5
 bea:	00000097          	auipc	ra,0x0
 bee:	e08080e7          	jalr	-504(ra) # 9f2 <putc>
 bf2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 bf4:	03c9d793          	srli	a5,s3,0x3c
 bf8:	97de                	add	a5,a5,s7
 bfa:	0007c583          	lbu	a1,0(a5)
 bfe:	8556                	mv	a0,s5
 c00:	00000097          	auipc	ra,0x0
 c04:	df2080e7          	jalr	-526(ra) # 9f2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 c08:	0992                	slli	s3,s3,0x4
 c0a:	397d                	addiw	s2,s2,-1
 c0c:	fe0914e3          	bnez	s2,bf4 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 c10:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 c14:	4981                	li	s3,0
 c16:	b721                	j	b1e <vprintf+0x60>
        s = va_arg(ap, char*);
 c18:	008b0993          	addi	s3,s6,8
 c1c:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 c20:	02090163          	beqz	s2,c42 <vprintf+0x184>
        while(*s != 0){
 c24:	00094583          	lbu	a1,0(s2)
 c28:	c9a1                	beqz	a1,c78 <vprintf+0x1ba>
          putc(fd, *s);
 c2a:	8556                	mv	a0,s5
 c2c:	00000097          	auipc	ra,0x0
 c30:	dc6080e7          	jalr	-570(ra) # 9f2 <putc>
          s++;
 c34:	0905                	addi	s2,s2,1
        while(*s != 0){
 c36:	00094583          	lbu	a1,0(s2)
 c3a:	f9e5                	bnez	a1,c2a <vprintf+0x16c>
        s = va_arg(ap, char*);
 c3c:	8b4e                	mv	s6,s3
      state = 0;
 c3e:	4981                	li	s3,0
 c40:	bdf9                	j	b1e <vprintf+0x60>
          s = "(null)";
 c42:	00000917          	auipc	s2,0x0
 c46:	6c690913          	addi	s2,s2,1734 # 1308 <malloc+0x580>
        while(*s != 0){
 c4a:	02800593          	li	a1,40
 c4e:	bff1                	j	c2a <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 c50:	008b0913          	addi	s2,s6,8
 c54:	000b4583          	lbu	a1,0(s6)
 c58:	8556                	mv	a0,s5
 c5a:	00000097          	auipc	ra,0x0
 c5e:	d98080e7          	jalr	-616(ra) # 9f2 <putc>
 c62:	8b4a                	mv	s6,s2
      state = 0;
 c64:	4981                	li	s3,0
 c66:	bd65                	j	b1e <vprintf+0x60>
        putc(fd, c);
 c68:	85d2                	mv	a1,s4
 c6a:	8556                	mv	a0,s5
 c6c:	00000097          	auipc	ra,0x0
 c70:	d86080e7          	jalr	-634(ra) # 9f2 <putc>
      state = 0;
 c74:	4981                	li	s3,0
 c76:	b565                	j	b1e <vprintf+0x60>
        s = va_arg(ap, char*);
 c78:	8b4e                	mv	s6,s3
      state = 0;
 c7a:	4981                	li	s3,0
 c7c:	b54d                	j	b1e <vprintf+0x60>
    }
  }
}
 c7e:	70e6                	ld	ra,120(sp)
 c80:	7446                	ld	s0,112(sp)
 c82:	74a6                	ld	s1,104(sp)
 c84:	7906                	ld	s2,96(sp)
 c86:	69e6                	ld	s3,88(sp)
 c88:	6a46                	ld	s4,80(sp)
 c8a:	6aa6                	ld	s5,72(sp)
 c8c:	6b06                	ld	s6,64(sp)
 c8e:	7be2                	ld	s7,56(sp)
 c90:	7c42                	ld	s8,48(sp)
 c92:	7ca2                	ld	s9,40(sp)
 c94:	7d02                	ld	s10,32(sp)
 c96:	6de2                	ld	s11,24(sp)
 c98:	6109                	addi	sp,sp,128
 c9a:	8082                	ret

0000000000000c9c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 c9c:	715d                	addi	sp,sp,-80
 c9e:	ec06                	sd	ra,24(sp)
 ca0:	e822                	sd	s0,16(sp)
 ca2:	1000                	addi	s0,sp,32
 ca4:	e010                	sd	a2,0(s0)
 ca6:	e414                	sd	a3,8(s0)
 ca8:	e818                	sd	a4,16(s0)
 caa:	ec1c                	sd	a5,24(s0)
 cac:	03043023          	sd	a6,32(s0)
 cb0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 cb4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 cb8:	8622                	mv	a2,s0
 cba:	00000097          	auipc	ra,0x0
 cbe:	e04080e7          	jalr	-508(ra) # abe <vprintf>
}
 cc2:	60e2                	ld	ra,24(sp)
 cc4:	6442                	ld	s0,16(sp)
 cc6:	6161                	addi	sp,sp,80
 cc8:	8082                	ret

0000000000000cca <printf>:

void
printf(const char *fmt, ...)
{
 cca:	711d                	addi	sp,sp,-96
 ccc:	ec06                	sd	ra,24(sp)
 cce:	e822                	sd	s0,16(sp)
 cd0:	1000                	addi	s0,sp,32
 cd2:	e40c                	sd	a1,8(s0)
 cd4:	e810                	sd	a2,16(s0)
 cd6:	ec14                	sd	a3,24(s0)
 cd8:	f018                	sd	a4,32(s0)
 cda:	f41c                	sd	a5,40(s0)
 cdc:	03043823          	sd	a6,48(s0)
 ce0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 ce4:	00840613          	addi	a2,s0,8
 ce8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 cec:	85aa                	mv	a1,a0
 cee:	4505                	li	a0,1
 cf0:	00000097          	auipc	ra,0x0
 cf4:	dce080e7          	jalr	-562(ra) # abe <vprintf>
}
 cf8:	60e2                	ld	ra,24(sp)
 cfa:	6442                	ld	s0,16(sp)
 cfc:	6125                	addi	sp,sp,96
 cfe:	8082                	ret

0000000000000d00 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 d00:	1141                	addi	sp,sp,-16
 d02:	e422                	sd	s0,8(sp)
 d04:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 d06:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d0a:	00000797          	auipc	a5,0x0
 d0e:	6267b783          	ld	a5,1574(a5) # 1330 <freep>
 d12:	a805                	j	d42 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 d14:	4618                	lw	a4,8(a2)
 d16:	9db9                	addw	a1,a1,a4
 d18:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 d1c:	6398                	ld	a4,0(a5)
 d1e:	6318                	ld	a4,0(a4)
 d20:	fee53823          	sd	a4,-16(a0)
 d24:	a091                	j	d68 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 d26:	ff852703          	lw	a4,-8(a0)
 d2a:	9e39                	addw	a2,a2,a4
 d2c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 d2e:	ff053703          	ld	a4,-16(a0)
 d32:	e398                	sd	a4,0(a5)
 d34:	a099                	j	d7a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d36:	6398                	ld	a4,0(a5)
 d38:	00e7e463          	bltu	a5,a4,d40 <free+0x40>
 d3c:	00e6ea63          	bltu	a3,a4,d50 <free+0x50>
{
 d40:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d42:	fed7fae3          	bgeu	a5,a3,d36 <free+0x36>
 d46:	6398                	ld	a4,0(a5)
 d48:	00e6e463          	bltu	a3,a4,d50 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d4c:	fee7eae3          	bltu	a5,a4,d40 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 d50:	ff852583          	lw	a1,-8(a0)
 d54:	6390                	ld	a2,0(a5)
 d56:	02059713          	slli	a4,a1,0x20
 d5a:	9301                	srli	a4,a4,0x20
 d5c:	0712                	slli	a4,a4,0x4
 d5e:	9736                	add	a4,a4,a3
 d60:	fae60ae3          	beq	a2,a4,d14 <free+0x14>
    bp->s.ptr = p->s.ptr;
 d64:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 d68:	4790                	lw	a2,8(a5)
 d6a:	02061713          	slli	a4,a2,0x20
 d6e:	9301                	srli	a4,a4,0x20
 d70:	0712                	slli	a4,a4,0x4
 d72:	973e                	add	a4,a4,a5
 d74:	fae689e3          	beq	a3,a4,d26 <free+0x26>
  } else
    p->s.ptr = bp;
 d78:	e394                	sd	a3,0(a5)
  freep = p;
 d7a:	00000717          	auipc	a4,0x0
 d7e:	5af73b23          	sd	a5,1462(a4) # 1330 <freep>
}
 d82:	6422                	ld	s0,8(sp)
 d84:	0141                	addi	sp,sp,16
 d86:	8082                	ret

0000000000000d88 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 d88:	7139                	addi	sp,sp,-64
 d8a:	fc06                	sd	ra,56(sp)
 d8c:	f822                	sd	s0,48(sp)
 d8e:	f426                	sd	s1,40(sp)
 d90:	f04a                	sd	s2,32(sp)
 d92:	ec4e                	sd	s3,24(sp)
 d94:	e852                	sd	s4,16(sp)
 d96:	e456                	sd	s5,8(sp)
 d98:	e05a                	sd	s6,0(sp)
 d9a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d9c:	02051493          	slli	s1,a0,0x20
 da0:	9081                	srli	s1,s1,0x20
 da2:	04bd                	addi	s1,s1,15
 da4:	8091                	srli	s1,s1,0x4
 da6:	0014899b          	addiw	s3,s1,1
 daa:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 dac:	00000517          	auipc	a0,0x0
 db0:	58453503          	ld	a0,1412(a0) # 1330 <freep>
 db4:	c515                	beqz	a0,de0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 db6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 db8:	4798                	lw	a4,8(a5)
 dba:	02977f63          	bgeu	a4,s1,df8 <malloc+0x70>
 dbe:	8a4e                	mv	s4,s3
 dc0:	0009871b          	sext.w	a4,s3
 dc4:	6685                	lui	a3,0x1
 dc6:	00d77363          	bgeu	a4,a3,dcc <malloc+0x44>
 dca:	6a05                	lui	s4,0x1
 dcc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 dd0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 dd4:	00000917          	auipc	s2,0x0
 dd8:	55c90913          	addi	s2,s2,1372 # 1330 <freep>
  if(p == (char*)-1)
 ddc:	5afd                	li	s5,-1
 dde:	a88d                	j	e50 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 de0:	00000797          	auipc	a5,0x0
 de4:	55878793          	addi	a5,a5,1368 # 1338 <base>
 de8:	00000717          	auipc	a4,0x0
 dec:	54f73423          	sd	a5,1352(a4) # 1330 <freep>
 df0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 df2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 df6:	b7e1                	j	dbe <malloc+0x36>
      if(p->s.size == nunits)
 df8:	02e48b63          	beq	s1,a4,e2e <malloc+0xa6>
        p->s.size -= nunits;
 dfc:	4137073b          	subw	a4,a4,s3
 e00:	c798                	sw	a4,8(a5)
        p += p->s.size;
 e02:	1702                	slli	a4,a4,0x20
 e04:	9301                	srli	a4,a4,0x20
 e06:	0712                	slli	a4,a4,0x4
 e08:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 e0a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 e0e:	00000717          	auipc	a4,0x0
 e12:	52a73123          	sd	a0,1314(a4) # 1330 <freep>
      return (void*)(p + 1);
 e16:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 e1a:	70e2                	ld	ra,56(sp)
 e1c:	7442                	ld	s0,48(sp)
 e1e:	74a2                	ld	s1,40(sp)
 e20:	7902                	ld	s2,32(sp)
 e22:	69e2                	ld	s3,24(sp)
 e24:	6a42                	ld	s4,16(sp)
 e26:	6aa2                	ld	s5,8(sp)
 e28:	6b02                	ld	s6,0(sp)
 e2a:	6121                	addi	sp,sp,64
 e2c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 e2e:	6398                	ld	a4,0(a5)
 e30:	e118                	sd	a4,0(a0)
 e32:	bff1                	j	e0e <malloc+0x86>
  hp->s.size = nu;
 e34:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 e38:	0541                	addi	a0,a0,16
 e3a:	00000097          	auipc	ra,0x0
 e3e:	ec6080e7          	jalr	-314(ra) # d00 <free>
  return freep;
 e42:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 e46:	d971                	beqz	a0,e1a <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e48:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 e4a:	4798                	lw	a4,8(a5)
 e4c:	fa9776e3          	bgeu	a4,s1,df8 <malloc+0x70>
    if(p == freep)
 e50:	00093703          	ld	a4,0(s2)
 e54:	853e                	mv	a0,a5
 e56:	fef719e3          	bne	a4,a5,e48 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 e5a:	8552                	mv	a0,s4
 e5c:	00000097          	auipc	ra,0x0
 e60:	b76080e7          	jalr	-1162(ra) # 9d2 <sbrk>
  if(p == (char*)-1)
 e64:	fd5518e3          	bne	a0,s5,e34 <malloc+0xac>
        return 0;
 e68:	4501                	li	a0,0
 e6a:	bf45                	j	e1a <malloc+0x92>
