
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
void kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

void
kern_init(void){
  100000:	f3 0f 1e fb          	endbr32 
  100004:	55                   	push   %ebp
  100005:	89 e5                	mov    %esp,%ebp
  100007:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  10000a:	b8 80 1d 11 00       	mov    $0x111d80,%eax
  10000f:	2d 16 0a 11 00       	sub    $0x110a16,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 0a 11 00 	movl   $0x110a16,(%esp)
  100027:	e8 26 2f 00 00       	call   102f52 <memset>

    cons_init();                // init the console
  10002c:	e8 16 16 00 00       	call   101647 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 80 37 10 00 	movl   $0x103780,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 9c 37 10 00 	movl   $0x10379c,(%esp)
  100046:	e8 49 02 00 00       	call   100294 <cprintf>

    print_kerninfo();
  10004b:	e8 07 09 00 00       	call   100957 <print_kerninfo>

    grade_backtrace();
  100050:	e8 9a 00 00 00       	call   1000ef <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 a7 2b 00 00       	call   102c01 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 3d 17 00 00       	call   10179c <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 e2 18 00 00       	call   101946 <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 63 0d 00 00       	call   100dcc <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 7a 18 00 00       	call   1018e8 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  10006e:	e8 87 01 00 00       	call   1001fa <lab1_switch_test>

    /* do nothing */
    while (1);
  100073:	eb fe                	jmp    100073 <kern_init+0x73>

00100075 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100075:	f3 0f 1e fb          	endbr32 
  100079:	55                   	push   %ebp
  10007a:	89 e5                	mov    %esp,%ebp
  10007c:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  10007f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100086:	00 
  100087:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10008e:	00 
  10008f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100096:	e8 1b 0d 00 00       	call   100db6 <mon_backtrace>
}
  10009b:	90                   	nop
  10009c:	c9                   	leave  
  10009d:	c3                   	ret    

0010009e <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  10009e:	f3 0f 1e fb          	endbr32 
  1000a2:	55                   	push   %ebp
  1000a3:	89 e5                	mov    %esp,%ebp
  1000a5:	53                   	push   %ebx
  1000a6:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000a9:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000af:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1000b5:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000b9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000bd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000c1:	89 04 24             	mov    %eax,(%esp)
  1000c4:	e8 ac ff ff ff       	call   100075 <grade_backtrace2>
}
  1000c9:	90                   	nop
  1000ca:	83 c4 14             	add    $0x14,%esp
  1000cd:	5b                   	pop    %ebx
  1000ce:	5d                   	pop    %ebp
  1000cf:	c3                   	ret    

001000d0 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000d0:	f3 0f 1e fb          	endbr32 
  1000d4:	55                   	push   %ebp
  1000d5:	89 e5                	mov    %esp,%ebp
  1000d7:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000da:	8b 45 10             	mov    0x10(%ebp),%eax
  1000dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1000e4:	89 04 24             	mov    %eax,(%esp)
  1000e7:	e8 b2 ff ff ff       	call   10009e <grade_backtrace1>
}
  1000ec:	90                   	nop
  1000ed:	c9                   	leave  
  1000ee:	c3                   	ret    

001000ef <grade_backtrace>:

void
grade_backtrace(void) {
  1000ef:	f3 0f 1e fb          	endbr32 
  1000f3:	55                   	push   %ebp
  1000f4:	89 e5                	mov    %esp,%ebp
  1000f6:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000f9:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000fe:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100105:	ff 
  100106:	89 44 24 04          	mov    %eax,0x4(%esp)
  10010a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100111:	e8 ba ff ff ff       	call   1000d0 <grade_backtrace0>
}
  100116:	90                   	nop
  100117:	c9                   	leave  
  100118:	c3                   	ret    

00100119 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100119:	f3 0f 1e fb          	endbr32 
  10011d:	55                   	push   %ebp
  10011e:	89 e5                	mov    %esp,%ebp
  100120:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100123:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100126:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100129:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10012c:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10012f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100133:	83 e0 03             	and    $0x3,%eax
  100136:	89 c2                	mov    %eax,%edx
  100138:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10013d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100141:	89 44 24 04          	mov    %eax,0x4(%esp)
  100145:	c7 04 24 a1 37 10 00 	movl   $0x1037a1,(%esp)
  10014c:	e8 43 01 00 00       	call   100294 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100151:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100155:	89 c2                	mov    %eax,%edx
  100157:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10015c:	89 54 24 08          	mov    %edx,0x8(%esp)
  100160:	89 44 24 04          	mov    %eax,0x4(%esp)
  100164:	c7 04 24 af 37 10 00 	movl   $0x1037af,(%esp)
  10016b:	e8 24 01 00 00       	call   100294 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100170:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100174:	89 c2                	mov    %eax,%edx
  100176:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10017b:	89 54 24 08          	mov    %edx,0x8(%esp)
  10017f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100183:	c7 04 24 bd 37 10 00 	movl   $0x1037bd,(%esp)
  10018a:	e8 05 01 00 00       	call   100294 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  10018f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100193:	89 c2                	mov    %eax,%edx
  100195:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10019a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10019e:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001a2:	c7 04 24 cb 37 10 00 	movl   $0x1037cb,(%esp)
  1001a9:	e8 e6 00 00 00       	call   100294 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001ae:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001b2:	89 c2                	mov    %eax,%edx
  1001b4:	a1 20 0a 11 00       	mov    0x110a20,%eax
  1001b9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001c1:	c7 04 24 d9 37 10 00 	movl   $0x1037d9,(%esp)
  1001c8:	e8 c7 00 00 00       	call   100294 <cprintf>
    round ++;
  1001cd:	a1 20 0a 11 00       	mov    0x110a20,%eax
  1001d2:	40                   	inc    %eax
  1001d3:	a3 20 0a 11 00       	mov    %eax,0x110a20
}
  1001d8:	90                   	nop
  1001d9:	c9                   	leave  
  1001da:	c3                   	ret    

001001db <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001db:	f3 0f 1e fb          	endbr32 
  1001df:	55                   	push   %ebp
  1001e0:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile (
  1001e2:	83 ec 08             	sub    $0x8,%esp
  1001e5:	cd 78                	int    $0x78
  1001e7:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  1001e9:	90                   	nop
  1001ea:	5d                   	pop    %ebp
  1001eb:	c3                   	ret    

001001ec <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001ec:	f3 0f 1e fb          	endbr32 
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile (
  1001f3:	cd 79                	int    $0x79
  1001f5:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  1001f7:	90                   	nop
  1001f8:	5d                   	pop    %ebp
  1001f9:	c3                   	ret    

001001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001fa:	f3 0f 1e fb          	endbr32 
  1001fe:	55                   	push   %ebp
  1001ff:	89 e5                	mov    %esp,%ebp
  100201:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100204:	e8 10 ff ff ff       	call   100119 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100209:	c7 04 24 e8 37 10 00 	movl   $0x1037e8,(%esp)
  100210:	e8 7f 00 00 00       	call   100294 <cprintf>
    lab1_switch_to_user();
  100215:	e8 c1 ff ff ff       	call   1001db <lab1_switch_to_user>
    lab1_print_cur_status();
  10021a:	e8 fa fe ff ff       	call   100119 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021f:	c7 04 24 08 38 10 00 	movl   $0x103808,(%esp)
  100226:	e8 69 00 00 00       	call   100294 <cprintf>
    lab1_switch_to_kernel();
  10022b:	e8 bc ff ff ff       	call   1001ec <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100230:	e8 e4 fe ff ff       	call   100119 <lab1_print_cur_status>
}
  100235:	90                   	nop
  100236:	c9                   	leave  
  100237:	c3                   	ret    

00100238 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100238:	f3 0f 1e fb          	endbr32 
  10023c:	55                   	push   %ebp
  10023d:	89 e5                	mov    %esp,%ebp
  10023f:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100242:	8b 45 08             	mov    0x8(%ebp),%eax
  100245:	89 04 24             	mov    %eax,(%esp)
  100248:	e8 2b 14 00 00       	call   101678 <cons_putc>
    (*cnt) ++;
  10024d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100250:	8b 00                	mov    (%eax),%eax
  100252:	8d 50 01             	lea    0x1(%eax),%edx
  100255:	8b 45 0c             	mov    0xc(%ebp),%eax
  100258:	89 10                	mov    %edx,(%eax)
}
  10025a:	90                   	nop
  10025b:	c9                   	leave  
  10025c:	c3                   	ret    

0010025d <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10025d:	f3 0f 1e fb          	endbr32 
  100261:	55                   	push   %ebp
  100262:	89 e5                	mov    %esp,%ebp
  100264:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100267:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10026e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100271:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100275:	8b 45 08             	mov    0x8(%ebp),%eax
  100278:	89 44 24 08          	mov    %eax,0x8(%esp)
  10027c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10027f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100283:	c7 04 24 38 02 10 00 	movl   $0x100238,(%esp)
  10028a:	e8 2f 30 00 00       	call   1032be <vprintfmt>
    return cnt;
  10028f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100292:	c9                   	leave  
  100293:	c3                   	ret    

00100294 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100294:	f3 0f 1e fb          	endbr32 
  100298:	55                   	push   %ebp
  100299:	89 e5                	mov    %esp,%ebp
  10029b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10029e:	8d 45 0c             	lea    0xc(%ebp),%eax
  1002a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  1002a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ae:	89 04 24             	mov    %eax,(%esp)
  1002b1:	e8 a7 ff ff ff       	call   10025d <vcprintf>
  1002b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002bc:	c9                   	leave  
  1002bd:	c3                   	ret    

001002be <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1002be:	f3 0f 1e fb          	endbr32 
  1002c2:	55                   	push   %ebp
  1002c3:	89 e5                	mov    %esp,%ebp
  1002c5:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1002cb:	89 04 24             	mov    %eax,(%esp)
  1002ce:	e8 a5 13 00 00       	call   101678 <cons_putc>
}
  1002d3:	90                   	nop
  1002d4:	c9                   	leave  
  1002d5:	c3                   	ret    

001002d6 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002d6:	f3 0f 1e fb          	endbr32 
  1002da:	55                   	push   %ebp
  1002db:	89 e5                	mov    %esp,%ebp
  1002dd:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002e7:	eb 13                	jmp    1002fc <cputs+0x26>
        cputch(c, &cnt);
  1002e9:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002ed:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002f0:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002f4:	89 04 24             	mov    %eax,(%esp)
  1002f7:	e8 3c ff ff ff       	call   100238 <cputch>
    while ((c = *str ++) != '\0') {
  1002fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ff:	8d 50 01             	lea    0x1(%eax),%edx
  100302:	89 55 08             	mov    %edx,0x8(%ebp)
  100305:	0f b6 00             	movzbl (%eax),%eax
  100308:	88 45 f7             	mov    %al,-0x9(%ebp)
  10030b:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  10030f:	75 d8                	jne    1002e9 <cputs+0x13>
    }
    cputch('\n', &cnt);
  100311:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100314:	89 44 24 04          	mov    %eax,0x4(%esp)
  100318:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  10031f:	e8 14 ff ff ff       	call   100238 <cputch>
    return cnt;
  100324:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100327:	c9                   	leave  
  100328:	c3                   	ret    

00100329 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  100329:	f3 0f 1e fb          	endbr32 
  10032d:	55                   	push   %ebp
  10032e:	89 e5                	mov    %esp,%ebp
  100330:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100333:	90                   	nop
  100334:	e8 6d 13 00 00       	call   1016a6 <cons_getc>
  100339:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10033c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100340:	74 f2                	je     100334 <getchar+0xb>
        /* do nothing */;
    return c;
  100342:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100345:	c9                   	leave  
  100346:	c3                   	ret    

00100347 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100347:	f3 0f 1e fb          	endbr32 
  10034b:	55                   	push   %ebp
  10034c:	89 e5                	mov    %esp,%ebp
  10034e:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100351:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100355:	74 13                	je     10036a <readline+0x23>
        cprintf("%s", prompt);
  100357:	8b 45 08             	mov    0x8(%ebp),%eax
  10035a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10035e:	c7 04 24 27 38 10 00 	movl   $0x103827,(%esp)
  100365:	e8 2a ff ff ff       	call   100294 <cprintf>
    }
    int i = 0, c;
  10036a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100371:	e8 b3 ff ff ff       	call   100329 <getchar>
  100376:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100379:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10037d:	79 07                	jns    100386 <readline+0x3f>
            return NULL;
  10037f:	b8 00 00 00 00       	mov    $0x0,%eax
  100384:	eb 78                	jmp    1003fe <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100386:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10038a:	7e 28                	jle    1003b4 <readline+0x6d>
  10038c:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100393:	7f 1f                	jg     1003b4 <readline+0x6d>
            cputchar(c);
  100395:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100398:	89 04 24             	mov    %eax,(%esp)
  10039b:	e8 1e ff ff ff       	call   1002be <cputchar>
            buf[i ++] = c;
  1003a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003a3:	8d 50 01             	lea    0x1(%eax),%edx
  1003a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1003a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1003ac:	88 90 40 0a 11 00    	mov    %dl,0x110a40(%eax)
  1003b2:	eb 45                	jmp    1003f9 <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
  1003b4:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1003b8:	75 16                	jne    1003d0 <readline+0x89>
  1003ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003be:	7e 10                	jle    1003d0 <readline+0x89>
            cputchar(c);
  1003c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003c3:	89 04 24             	mov    %eax,(%esp)
  1003c6:	e8 f3 fe ff ff       	call   1002be <cputchar>
            i --;
  1003cb:	ff 4d f4             	decl   -0xc(%ebp)
  1003ce:	eb 29                	jmp    1003f9 <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
  1003d0:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003d4:	74 06                	je     1003dc <readline+0x95>
  1003d6:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003da:	75 95                	jne    100371 <readline+0x2a>
            cputchar(c);
  1003dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003df:	89 04 24             	mov    %eax,(%esp)
  1003e2:	e8 d7 fe ff ff       	call   1002be <cputchar>
            buf[i] = '\0';
  1003e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003ea:	05 40 0a 11 00       	add    $0x110a40,%eax
  1003ef:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003f2:	b8 40 0a 11 00       	mov    $0x110a40,%eax
  1003f7:	eb 05                	jmp    1003fe <readline+0xb7>
        c = getchar();
  1003f9:	e9 73 ff ff ff       	jmp    100371 <readline+0x2a>
        }
    }
}
  1003fe:	c9                   	leave  
  1003ff:	c3                   	ret    

00100400 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100400:	f3 0f 1e fb          	endbr32 
  100404:	55                   	push   %ebp
  100405:	89 e5                	mov    %esp,%ebp
  100407:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  10040a:	a1 40 0e 11 00       	mov    0x110e40,%eax
  10040f:	85 c0                	test   %eax,%eax
  100411:	75 5b                	jne    10046e <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
  100413:	c7 05 40 0e 11 00 01 	movl   $0x1,0x110e40
  10041a:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  10041d:	8d 45 14             	lea    0x14(%ebp),%eax
  100420:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100423:	8b 45 0c             	mov    0xc(%ebp),%eax
  100426:	89 44 24 08          	mov    %eax,0x8(%esp)
  10042a:	8b 45 08             	mov    0x8(%ebp),%eax
  10042d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100431:	c7 04 24 2a 38 10 00 	movl   $0x10382a,(%esp)
  100438:	e8 57 fe ff ff       	call   100294 <cprintf>
    vcprintf(fmt, ap);
  10043d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100440:	89 44 24 04          	mov    %eax,0x4(%esp)
  100444:	8b 45 10             	mov    0x10(%ebp),%eax
  100447:	89 04 24             	mov    %eax,(%esp)
  10044a:	e8 0e fe ff ff       	call   10025d <vcprintf>
    cprintf("\n");
  10044f:	c7 04 24 46 38 10 00 	movl   $0x103846,(%esp)
  100456:	e8 39 fe ff ff       	call   100294 <cprintf>
    
    cprintf("stack trackback:\n");
  10045b:	c7 04 24 48 38 10 00 	movl   $0x103848,(%esp)
  100462:	e8 2d fe ff ff       	call   100294 <cprintf>
    print_stackframe();
  100467:	e8 3d 06 00 00       	call   100aa9 <print_stackframe>
  10046c:	eb 01                	jmp    10046f <__panic+0x6f>
        goto panic_dead;
  10046e:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  10046f:	e8 80 14 00 00       	call   1018f4 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100474:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10047b:	e8 5d 08 00 00       	call   100cdd <kmonitor>
  100480:	eb f2                	jmp    100474 <__panic+0x74>

00100482 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100482:	f3 0f 1e fb          	endbr32 
  100486:	55                   	push   %ebp
  100487:	89 e5                	mov    %esp,%ebp
  100489:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  10048c:	8d 45 14             	lea    0x14(%ebp),%eax
  10048f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100492:	8b 45 0c             	mov    0xc(%ebp),%eax
  100495:	89 44 24 08          	mov    %eax,0x8(%esp)
  100499:	8b 45 08             	mov    0x8(%ebp),%eax
  10049c:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004a0:	c7 04 24 5a 38 10 00 	movl   $0x10385a,(%esp)
  1004a7:	e8 e8 fd ff ff       	call   100294 <cprintf>
    vcprintf(fmt, ap);
  1004ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004b3:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b6:	89 04 24             	mov    %eax,(%esp)
  1004b9:	e8 9f fd ff ff       	call   10025d <vcprintf>
    cprintf("\n");
  1004be:	c7 04 24 46 38 10 00 	movl   $0x103846,(%esp)
  1004c5:	e8 ca fd ff ff       	call   100294 <cprintf>
    va_end(ap);
}
  1004ca:	90                   	nop
  1004cb:	c9                   	leave  
  1004cc:	c3                   	ret    

001004cd <is_kernel_panic>:

bool
is_kernel_panic(void) {
  1004cd:	f3 0f 1e fb          	endbr32 
  1004d1:	55                   	push   %ebp
  1004d2:	89 e5                	mov    %esp,%ebp
    return is_panic;
  1004d4:	a1 40 0e 11 00       	mov    0x110e40,%eax
}
  1004d9:	5d                   	pop    %ebp
  1004da:	c3                   	ret    

001004db <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1004db:	f3 0f 1e fb          	endbr32 
  1004df:	55                   	push   %ebp
  1004e0:	89 e5                	mov    %esp,%ebp
  1004e2:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1004e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e8:	8b 00                	mov    (%eax),%eax
  1004ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004ed:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f0:	8b 00                	mov    (%eax),%eax
  1004f2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004fc:	e9 ca 00 00 00       	jmp    1005cb <stab_binsearch+0xf0>
        int true_m = (l + r) / 2, m = true_m;
  100501:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100504:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100507:	01 d0                	add    %edx,%eax
  100509:	89 c2                	mov    %eax,%edx
  10050b:	c1 ea 1f             	shr    $0x1f,%edx
  10050e:	01 d0                	add    %edx,%eax
  100510:	d1 f8                	sar    %eax
  100512:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100515:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100518:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10051b:	eb 03                	jmp    100520 <stab_binsearch+0x45>
            m --;
  10051d:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  100520:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100523:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100526:	7c 1f                	jl     100547 <stab_binsearch+0x6c>
  100528:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10052b:	89 d0                	mov    %edx,%eax
  10052d:	01 c0                	add    %eax,%eax
  10052f:	01 d0                	add    %edx,%eax
  100531:	c1 e0 02             	shl    $0x2,%eax
  100534:	89 c2                	mov    %eax,%edx
  100536:	8b 45 08             	mov    0x8(%ebp),%eax
  100539:	01 d0                	add    %edx,%eax
  10053b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10053f:	0f b6 c0             	movzbl %al,%eax
  100542:	39 45 14             	cmp    %eax,0x14(%ebp)
  100545:	75 d6                	jne    10051d <stab_binsearch+0x42>
        }
        if (m < l) {    // no match in [l, m]
  100547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10054a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10054d:	7d 09                	jge    100558 <stab_binsearch+0x7d>
            l = true_m + 1;
  10054f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100552:	40                   	inc    %eax
  100553:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100556:	eb 73                	jmp    1005cb <stab_binsearch+0xf0>
        }

        // actual binary search
        any_matches = 1;
  100558:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10055f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100562:	89 d0                	mov    %edx,%eax
  100564:	01 c0                	add    %eax,%eax
  100566:	01 d0                	add    %edx,%eax
  100568:	c1 e0 02             	shl    $0x2,%eax
  10056b:	89 c2                	mov    %eax,%edx
  10056d:	8b 45 08             	mov    0x8(%ebp),%eax
  100570:	01 d0                	add    %edx,%eax
  100572:	8b 40 08             	mov    0x8(%eax),%eax
  100575:	39 45 18             	cmp    %eax,0x18(%ebp)
  100578:	76 11                	jbe    10058b <stab_binsearch+0xb0>
            *region_left = m;
  10057a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10057d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100580:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100582:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100585:	40                   	inc    %eax
  100586:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100589:	eb 40                	jmp    1005cb <stab_binsearch+0xf0>
        } else if (stabs[m].n_value > addr) {
  10058b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10058e:	89 d0                	mov    %edx,%eax
  100590:	01 c0                	add    %eax,%eax
  100592:	01 d0                	add    %edx,%eax
  100594:	c1 e0 02             	shl    $0x2,%eax
  100597:	89 c2                	mov    %eax,%edx
  100599:	8b 45 08             	mov    0x8(%ebp),%eax
  10059c:	01 d0                	add    %edx,%eax
  10059e:	8b 40 08             	mov    0x8(%eax),%eax
  1005a1:	39 45 18             	cmp    %eax,0x18(%ebp)
  1005a4:	73 14                	jae    1005ba <stab_binsearch+0xdf>
            *region_right = m - 1;
  1005a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005a9:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005ac:	8b 45 10             	mov    0x10(%ebp),%eax
  1005af:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1005b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005b4:	48                   	dec    %eax
  1005b5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1005b8:	eb 11                	jmp    1005cb <stab_binsearch+0xf0>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1005ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005c0:	89 10                	mov    %edx,(%eax)
            l = m;
  1005c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1005c8:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1005cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1005ce:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1005d1:	0f 8e 2a ff ff ff    	jle    100501 <stab_binsearch+0x26>
        }
    }

    if (!any_matches) {
  1005d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1005db:	75 0f                	jne    1005ec <stab_binsearch+0x111>
        *region_right = *region_left - 1;
  1005dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e0:	8b 00                	mov    (%eax),%eax
  1005e2:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005e5:	8b 45 10             	mov    0x10(%ebp),%eax
  1005e8:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1005ea:	eb 3e                	jmp    10062a <stab_binsearch+0x14f>
        l = *region_right;
  1005ec:	8b 45 10             	mov    0x10(%ebp),%eax
  1005ef:	8b 00                	mov    (%eax),%eax
  1005f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005f4:	eb 03                	jmp    1005f9 <stab_binsearch+0x11e>
  1005f6:	ff 4d fc             	decl   -0x4(%ebp)
  1005f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005fc:	8b 00                	mov    (%eax),%eax
  1005fe:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  100601:	7e 1f                	jle    100622 <stab_binsearch+0x147>
  100603:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100606:	89 d0                	mov    %edx,%eax
  100608:	01 c0                	add    %eax,%eax
  10060a:	01 d0                	add    %edx,%eax
  10060c:	c1 e0 02             	shl    $0x2,%eax
  10060f:	89 c2                	mov    %eax,%edx
  100611:	8b 45 08             	mov    0x8(%ebp),%eax
  100614:	01 d0                	add    %edx,%eax
  100616:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10061a:	0f b6 c0             	movzbl %al,%eax
  10061d:	39 45 14             	cmp    %eax,0x14(%ebp)
  100620:	75 d4                	jne    1005f6 <stab_binsearch+0x11b>
        *region_left = l;
  100622:	8b 45 0c             	mov    0xc(%ebp),%eax
  100625:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100628:	89 10                	mov    %edx,(%eax)
}
  10062a:	90                   	nop
  10062b:	c9                   	leave  
  10062c:	c3                   	ret    

0010062d <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10062d:	f3 0f 1e fb          	endbr32 
  100631:	55                   	push   %ebp
  100632:	89 e5                	mov    %esp,%ebp
  100634:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100637:	8b 45 0c             	mov    0xc(%ebp),%eax
  10063a:	c7 00 78 38 10 00    	movl   $0x103878,(%eax)
    info->eip_line = 0;
  100640:	8b 45 0c             	mov    0xc(%ebp),%eax
  100643:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10064a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10064d:	c7 40 08 78 38 10 00 	movl   $0x103878,0x8(%eax)
    info->eip_fn_namelen = 9;
  100654:	8b 45 0c             	mov    0xc(%ebp),%eax
  100657:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10065e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100661:	8b 55 08             	mov    0x8(%ebp),%edx
  100664:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100667:	8b 45 0c             	mov    0xc(%ebp),%eax
  10066a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100671:	c7 45 f4 ac 40 10 00 	movl   $0x1040ac,-0xc(%ebp)
    stab_end = __STAB_END__;
  100678:	c7 45 f0 14 cf 10 00 	movl   $0x10cf14,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10067f:	c7 45 ec 15 cf 10 00 	movl   $0x10cf15,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100686:	c7 45 e8 23 f0 10 00 	movl   $0x10f023,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10068d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100690:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100693:	76 0b                	jbe    1006a0 <debuginfo_eip+0x73>
  100695:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100698:	48                   	dec    %eax
  100699:	0f b6 00             	movzbl (%eax),%eax
  10069c:	84 c0                	test   %al,%al
  10069e:	74 0a                	je     1006aa <debuginfo_eip+0x7d>
        return -1;
  1006a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006a5:	e9 ab 02 00 00       	jmp    100955 <debuginfo_eip+0x328>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1006aa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1006b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1006b4:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1006b7:	c1 f8 02             	sar    $0x2,%eax
  1006ba:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1006c0:	48                   	dec    %eax
  1006c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1006c7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006cb:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1006d2:	00 
  1006d3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1006d6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006da:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1006dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006e4:	89 04 24             	mov    %eax,(%esp)
  1006e7:	e8 ef fd ff ff       	call   1004db <stab_binsearch>
    if (lfile == 0)
  1006ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006ef:	85 c0                	test   %eax,%eax
  1006f1:	75 0a                	jne    1006fd <debuginfo_eip+0xd0>
        return -1;
  1006f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006f8:	e9 58 02 00 00       	jmp    100955 <debuginfo_eip+0x328>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100700:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100703:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100706:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100709:	8b 45 08             	mov    0x8(%ebp),%eax
  10070c:	89 44 24 10          	mov    %eax,0x10(%esp)
  100710:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100717:	00 
  100718:	8d 45 d8             	lea    -0x28(%ebp),%eax
  10071b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10071f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100722:	89 44 24 04          	mov    %eax,0x4(%esp)
  100726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100729:	89 04 24             	mov    %eax,(%esp)
  10072c:	e8 aa fd ff ff       	call   1004db <stab_binsearch>

    if (lfun <= rfun) {
  100731:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100734:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100737:	39 c2                	cmp    %eax,%edx
  100739:	7f 78                	jg     1007b3 <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10073b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10073e:	89 c2                	mov    %eax,%edx
  100740:	89 d0                	mov    %edx,%eax
  100742:	01 c0                	add    %eax,%eax
  100744:	01 d0                	add    %edx,%eax
  100746:	c1 e0 02             	shl    $0x2,%eax
  100749:	89 c2                	mov    %eax,%edx
  10074b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10074e:	01 d0                	add    %edx,%eax
  100750:	8b 10                	mov    (%eax),%edx
  100752:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100755:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100758:	39 c2                	cmp    %eax,%edx
  10075a:	73 22                	jae    10077e <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10075c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10075f:	89 c2                	mov    %eax,%edx
  100761:	89 d0                	mov    %edx,%eax
  100763:	01 c0                	add    %eax,%eax
  100765:	01 d0                	add    %edx,%eax
  100767:	c1 e0 02             	shl    $0x2,%eax
  10076a:	89 c2                	mov    %eax,%edx
  10076c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10076f:	01 d0                	add    %edx,%eax
  100771:	8b 10                	mov    (%eax),%edx
  100773:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100776:	01 c2                	add    %eax,%edx
  100778:	8b 45 0c             	mov    0xc(%ebp),%eax
  10077b:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10077e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100781:	89 c2                	mov    %eax,%edx
  100783:	89 d0                	mov    %edx,%eax
  100785:	01 c0                	add    %eax,%eax
  100787:	01 d0                	add    %edx,%eax
  100789:	c1 e0 02             	shl    $0x2,%eax
  10078c:	89 c2                	mov    %eax,%edx
  10078e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100791:	01 d0                	add    %edx,%eax
  100793:	8b 50 08             	mov    0x8(%eax),%edx
  100796:	8b 45 0c             	mov    0xc(%ebp),%eax
  100799:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10079c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10079f:	8b 40 10             	mov    0x10(%eax),%eax
  1007a2:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1007a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007a8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1007ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007ae:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1007b1:	eb 15                	jmp    1007c8 <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1007b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007b6:	8b 55 08             	mov    0x8(%ebp),%edx
  1007b9:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1007bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1007c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1007c5:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1007c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007cb:	8b 40 08             	mov    0x8(%eax),%eax
  1007ce:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1007d5:	00 
  1007d6:	89 04 24             	mov    %eax,(%esp)
  1007d9:	e8 e8 25 00 00       	call   102dc6 <strfind>
  1007de:	8b 55 0c             	mov    0xc(%ebp),%edx
  1007e1:	8b 52 08             	mov    0x8(%edx),%edx
  1007e4:	29 d0                	sub    %edx,%eax
  1007e6:	89 c2                	mov    %eax,%edx
  1007e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007eb:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1007f1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007f5:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007fc:	00 
  1007fd:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100800:	89 44 24 08          	mov    %eax,0x8(%esp)
  100804:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100807:	89 44 24 04          	mov    %eax,0x4(%esp)
  10080b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10080e:	89 04 24             	mov    %eax,(%esp)
  100811:	e8 c5 fc ff ff       	call   1004db <stab_binsearch>
    if (lline <= rline) {
  100816:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100819:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10081c:	39 c2                	cmp    %eax,%edx
  10081e:	7f 23                	jg     100843 <debuginfo_eip+0x216>
        info->eip_line = stabs[rline].n_desc;
  100820:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100823:	89 c2                	mov    %eax,%edx
  100825:	89 d0                	mov    %edx,%eax
  100827:	01 c0                	add    %eax,%eax
  100829:	01 d0                	add    %edx,%eax
  10082b:	c1 e0 02             	shl    $0x2,%eax
  10082e:	89 c2                	mov    %eax,%edx
  100830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100833:	01 d0                	add    %edx,%eax
  100835:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100839:	89 c2                	mov    %eax,%edx
  10083b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10083e:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100841:	eb 11                	jmp    100854 <debuginfo_eip+0x227>
        return -1;
  100843:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100848:	e9 08 01 00 00       	jmp    100955 <debuginfo_eip+0x328>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10084d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100850:	48                   	dec    %eax
  100851:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100854:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100857:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10085a:	39 c2                	cmp    %eax,%edx
  10085c:	7c 56                	jl     1008b4 <debuginfo_eip+0x287>
           && stabs[lline].n_type != N_SOL
  10085e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100861:	89 c2                	mov    %eax,%edx
  100863:	89 d0                	mov    %edx,%eax
  100865:	01 c0                	add    %eax,%eax
  100867:	01 d0                	add    %edx,%eax
  100869:	c1 e0 02             	shl    $0x2,%eax
  10086c:	89 c2                	mov    %eax,%edx
  10086e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100871:	01 d0                	add    %edx,%eax
  100873:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100877:	3c 84                	cmp    $0x84,%al
  100879:	74 39                	je     1008b4 <debuginfo_eip+0x287>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10087b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10087e:	89 c2                	mov    %eax,%edx
  100880:	89 d0                	mov    %edx,%eax
  100882:	01 c0                	add    %eax,%eax
  100884:	01 d0                	add    %edx,%eax
  100886:	c1 e0 02             	shl    $0x2,%eax
  100889:	89 c2                	mov    %eax,%edx
  10088b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10088e:	01 d0                	add    %edx,%eax
  100890:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100894:	3c 64                	cmp    $0x64,%al
  100896:	75 b5                	jne    10084d <debuginfo_eip+0x220>
  100898:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10089b:	89 c2                	mov    %eax,%edx
  10089d:	89 d0                	mov    %edx,%eax
  10089f:	01 c0                	add    %eax,%eax
  1008a1:	01 d0                	add    %edx,%eax
  1008a3:	c1 e0 02             	shl    $0x2,%eax
  1008a6:	89 c2                	mov    %eax,%edx
  1008a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008ab:	01 d0                	add    %edx,%eax
  1008ad:	8b 40 08             	mov    0x8(%eax),%eax
  1008b0:	85 c0                	test   %eax,%eax
  1008b2:	74 99                	je     10084d <debuginfo_eip+0x220>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1008b4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1008ba:	39 c2                	cmp    %eax,%edx
  1008bc:	7c 42                	jl     100900 <debuginfo_eip+0x2d3>
  1008be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008c1:	89 c2                	mov    %eax,%edx
  1008c3:	89 d0                	mov    %edx,%eax
  1008c5:	01 c0                	add    %eax,%eax
  1008c7:	01 d0                	add    %edx,%eax
  1008c9:	c1 e0 02             	shl    $0x2,%eax
  1008cc:	89 c2                	mov    %eax,%edx
  1008ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008d1:	01 d0                	add    %edx,%eax
  1008d3:	8b 10                	mov    (%eax),%edx
  1008d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1008d8:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1008db:	39 c2                	cmp    %eax,%edx
  1008dd:	73 21                	jae    100900 <debuginfo_eip+0x2d3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1008df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008e2:	89 c2                	mov    %eax,%edx
  1008e4:	89 d0                	mov    %edx,%eax
  1008e6:	01 c0                	add    %eax,%eax
  1008e8:	01 d0                	add    %edx,%eax
  1008ea:	c1 e0 02             	shl    $0x2,%eax
  1008ed:	89 c2                	mov    %eax,%edx
  1008ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008f2:	01 d0                	add    %edx,%eax
  1008f4:	8b 10                	mov    (%eax),%edx
  1008f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008f9:	01 c2                	add    %eax,%edx
  1008fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008fe:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100900:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100903:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100906:	39 c2                	cmp    %eax,%edx
  100908:	7d 46                	jge    100950 <debuginfo_eip+0x323>
        for (lline = lfun + 1;
  10090a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10090d:	40                   	inc    %eax
  10090e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100911:	eb 16                	jmp    100929 <debuginfo_eip+0x2fc>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100913:	8b 45 0c             	mov    0xc(%ebp),%eax
  100916:	8b 40 14             	mov    0x14(%eax),%eax
  100919:	8d 50 01             	lea    0x1(%eax),%edx
  10091c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10091f:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100922:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100925:	40                   	inc    %eax
  100926:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100929:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10092c:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  10092f:	39 c2                	cmp    %eax,%edx
  100931:	7d 1d                	jge    100950 <debuginfo_eip+0x323>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100933:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100936:	89 c2                	mov    %eax,%edx
  100938:	89 d0                	mov    %edx,%eax
  10093a:	01 c0                	add    %eax,%eax
  10093c:	01 d0                	add    %edx,%eax
  10093e:	c1 e0 02             	shl    $0x2,%eax
  100941:	89 c2                	mov    %eax,%edx
  100943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100946:	01 d0                	add    %edx,%eax
  100948:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10094c:	3c a0                	cmp    $0xa0,%al
  10094e:	74 c3                	je     100913 <debuginfo_eip+0x2e6>
        }
    }
    return 0;
  100950:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100955:	c9                   	leave  
  100956:	c3                   	ret    

00100957 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100957:	f3 0f 1e fb          	endbr32 
  10095b:	55                   	push   %ebp
  10095c:	89 e5                	mov    %esp,%ebp
  10095e:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100961:	c7 04 24 82 38 10 00 	movl   $0x103882,(%esp)
  100968:	e8 27 f9 ff ff       	call   100294 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10096d:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  100974:	00 
  100975:	c7 04 24 9b 38 10 00 	movl   $0x10389b,(%esp)
  10097c:	e8 13 f9 ff ff       	call   100294 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100981:	c7 44 24 04 76 37 10 	movl   $0x103776,0x4(%esp)
  100988:	00 
  100989:	c7 04 24 b3 38 10 00 	movl   $0x1038b3,(%esp)
  100990:	e8 ff f8 ff ff       	call   100294 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100995:	c7 44 24 04 16 0a 11 	movl   $0x110a16,0x4(%esp)
  10099c:	00 
  10099d:	c7 04 24 cb 38 10 00 	movl   $0x1038cb,(%esp)
  1009a4:	e8 eb f8 ff ff       	call   100294 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1009a9:	c7 44 24 04 80 1d 11 	movl   $0x111d80,0x4(%esp)
  1009b0:	00 
  1009b1:	c7 04 24 e3 38 10 00 	movl   $0x1038e3,(%esp)
  1009b8:	e8 d7 f8 ff ff       	call   100294 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1009bd:	b8 80 1d 11 00       	mov    $0x111d80,%eax
  1009c2:	2d 00 00 10 00       	sub    $0x100000,%eax
  1009c7:	05 ff 03 00 00       	add    $0x3ff,%eax
  1009cc:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009d2:	85 c0                	test   %eax,%eax
  1009d4:	0f 48 c2             	cmovs  %edx,%eax
  1009d7:	c1 f8 0a             	sar    $0xa,%eax
  1009da:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009de:	c7 04 24 fc 38 10 00 	movl   $0x1038fc,(%esp)
  1009e5:	e8 aa f8 ff ff       	call   100294 <cprintf>
}
  1009ea:	90                   	nop
  1009eb:	c9                   	leave  
  1009ec:	c3                   	ret    

001009ed <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009ed:	f3 0f 1e fb          	endbr32 
  1009f1:	55                   	push   %ebp
  1009f2:	89 e5                	mov    %esp,%ebp
  1009f4:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009fa:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a01:	8b 45 08             	mov    0x8(%ebp),%eax
  100a04:	89 04 24             	mov    %eax,(%esp)
  100a07:	e8 21 fc ff ff       	call   10062d <debuginfo_eip>
  100a0c:	85 c0                	test   %eax,%eax
  100a0e:	74 15                	je     100a25 <print_debuginfo+0x38>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100a10:	8b 45 08             	mov    0x8(%ebp),%eax
  100a13:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a17:	c7 04 24 26 39 10 00 	movl   $0x103926,(%esp)
  100a1e:	e8 71 f8 ff ff       	call   100294 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100a23:	eb 6c                	jmp    100a91 <print_debuginfo+0xa4>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a2c:	eb 1b                	jmp    100a49 <print_debuginfo+0x5c>
            fnname[j] = info.eip_fn_name[j];
  100a2e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a34:	01 d0                	add    %edx,%eax
  100a36:	0f b6 10             	movzbl (%eax),%edx
  100a39:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a42:	01 c8                	add    %ecx,%eax
  100a44:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a46:	ff 45 f4             	incl   -0xc(%ebp)
  100a49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a4c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a4f:	7c dd                	jl     100a2e <print_debuginfo+0x41>
        fnname[j] = '\0';
  100a51:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a5a:	01 d0                	add    %edx,%eax
  100a5c:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a62:	8b 55 08             	mov    0x8(%ebp),%edx
  100a65:	89 d1                	mov    %edx,%ecx
  100a67:	29 c1                	sub    %eax,%ecx
  100a69:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a6f:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a73:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a79:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a7d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a81:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a85:	c7 04 24 42 39 10 00 	movl   $0x103942,(%esp)
  100a8c:	e8 03 f8 ff ff       	call   100294 <cprintf>
}
  100a91:	90                   	nop
  100a92:	c9                   	leave  
  100a93:	c3                   	ret    

00100a94 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a94:	f3 0f 1e fb          	endbr32 
  100a98:	55                   	push   %ebp
  100a99:	89 e5                	mov    %esp,%ebp
  100a9b:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a9e:	8b 45 04             	mov    0x4(%ebp),%eax
  100aa1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100aa4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100aa7:	c9                   	leave  
  100aa8:	c3                   	ret    

00100aa9 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100aa9:	f3 0f 1e fb          	endbr32 
  100aad:	55                   	push   %ebp
  100aae:	89 e5                	mov    %esp,%ebp
  100ab0:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100ab3:	89 e8                	mov    %ebp,%eax
  100ab5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100ab8:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
  100abb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100abe:	e8 d1 ff ff ff       	call   100a94 <read_eip>
  100ac3:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100ac6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100acd:	e9 84 00 00 00       	jmp    100b56 <print_stackframe+0xad>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  100ad2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ad5:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100adc:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ae0:	c7 04 24 54 39 10 00 	movl   $0x103954,(%esp)
  100ae7:	e8 a8 f7 ff ff       	call   100294 <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
  100aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aef:	83 c0 08             	add    $0x8,%eax
  100af2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
  100af5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100afc:	eb 24                	jmp    100b22 <print_stackframe+0x79>
            cprintf("0x%08x ", args[j]);
  100afe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b01:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100b0b:	01 d0                	add    %edx,%eax
  100b0d:	8b 00                	mov    (%eax),%eax
  100b0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b13:	c7 04 24 70 39 10 00 	movl   $0x103970,(%esp)
  100b1a:	e8 75 f7 ff ff       	call   100294 <cprintf>
        for (j = 0; j < 4; j ++) {
  100b1f:	ff 45 e8             	incl   -0x18(%ebp)
  100b22:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100b26:	7e d6                	jle    100afe <print_stackframe+0x55>
        }
        cprintf("\n");
  100b28:	c7 04 24 78 39 10 00 	movl   $0x103978,(%esp)
  100b2f:	e8 60 f7 ff ff       	call   100294 <cprintf>
        print_debuginfo(eip - 1);
  100b34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b37:	48                   	dec    %eax
  100b38:	89 04 24             	mov    %eax,(%esp)
  100b3b:	e8 ad fe ff ff       	call   1009ed <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
  100b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b43:	83 c0 04             	add    $0x4,%eax
  100b46:	8b 00                	mov    (%eax),%eax
  100b48:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b4e:	8b 00                	mov    (%eax),%eax
  100b50:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100b53:	ff 45 ec             	incl   -0x14(%ebp)
  100b56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b5a:	74 0a                	je     100b66 <print_stackframe+0xbd>
  100b5c:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b60:	0f 8e 6c ff ff ff    	jle    100ad2 <print_stackframe+0x29>
    }
}
  100b66:	90                   	nop
  100b67:	c9                   	leave  
  100b68:	c3                   	ret    

00100b69 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b69:	f3 0f 1e fb          	endbr32 
  100b6d:	55                   	push   %ebp
  100b6e:	89 e5                	mov    %esp,%ebp
  100b70:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b7a:	eb 0c                	jmp    100b88 <parse+0x1f>
            *buf ++ = '\0';
  100b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  100b7f:	8d 50 01             	lea    0x1(%eax),%edx
  100b82:	89 55 08             	mov    %edx,0x8(%ebp)
  100b85:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b88:	8b 45 08             	mov    0x8(%ebp),%eax
  100b8b:	0f b6 00             	movzbl (%eax),%eax
  100b8e:	84 c0                	test   %al,%al
  100b90:	74 1d                	je     100baf <parse+0x46>
  100b92:	8b 45 08             	mov    0x8(%ebp),%eax
  100b95:	0f b6 00             	movzbl (%eax),%eax
  100b98:	0f be c0             	movsbl %al,%eax
  100b9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b9f:	c7 04 24 fc 39 10 00 	movl   $0x1039fc,(%esp)
  100ba6:	e8 e5 21 00 00       	call   102d90 <strchr>
  100bab:	85 c0                	test   %eax,%eax
  100bad:	75 cd                	jne    100b7c <parse+0x13>
        }
        if (*buf == '\0') {
  100baf:	8b 45 08             	mov    0x8(%ebp),%eax
  100bb2:	0f b6 00             	movzbl (%eax),%eax
  100bb5:	84 c0                	test   %al,%al
  100bb7:	74 65                	je     100c1e <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100bb9:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100bbd:	75 14                	jne    100bd3 <parse+0x6a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100bbf:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100bc6:	00 
  100bc7:	c7 04 24 01 3a 10 00 	movl   $0x103a01,(%esp)
  100bce:	e8 c1 f6 ff ff       	call   100294 <cprintf>
        }
        argv[argc ++] = buf;
  100bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bd6:	8d 50 01             	lea    0x1(%eax),%edx
  100bd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100bdc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100be3:	8b 45 0c             	mov    0xc(%ebp),%eax
  100be6:	01 c2                	add    %eax,%edx
  100be8:	8b 45 08             	mov    0x8(%ebp),%eax
  100beb:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bed:	eb 03                	jmp    100bf2 <parse+0x89>
            buf ++;
  100bef:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  100bf5:	0f b6 00             	movzbl (%eax),%eax
  100bf8:	84 c0                	test   %al,%al
  100bfa:	74 8c                	je     100b88 <parse+0x1f>
  100bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  100bff:	0f b6 00             	movzbl (%eax),%eax
  100c02:	0f be c0             	movsbl %al,%eax
  100c05:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c09:	c7 04 24 fc 39 10 00 	movl   $0x1039fc,(%esp)
  100c10:	e8 7b 21 00 00       	call   102d90 <strchr>
  100c15:	85 c0                	test   %eax,%eax
  100c17:	74 d6                	je     100bef <parse+0x86>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100c19:	e9 6a ff ff ff       	jmp    100b88 <parse+0x1f>
            break;
  100c1e:	90                   	nop
        }
    }
    return argc;
  100c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100c22:	c9                   	leave  
  100c23:	c3                   	ret    

00100c24 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100c24:	f3 0f 1e fb          	endbr32 
  100c28:	55                   	push   %ebp
  100c29:	89 e5                	mov    %esp,%ebp
  100c2b:	53                   	push   %ebx
  100c2c:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100c2f:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c32:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c36:	8b 45 08             	mov    0x8(%ebp),%eax
  100c39:	89 04 24             	mov    %eax,(%esp)
  100c3c:	e8 28 ff ff ff       	call   100b69 <parse>
  100c41:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c48:	75 0a                	jne    100c54 <runcmd+0x30>
        return 0;
  100c4a:	b8 00 00 00 00       	mov    $0x0,%eax
  100c4f:	e9 83 00 00 00       	jmp    100cd7 <runcmd+0xb3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c5b:	eb 5a                	jmp    100cb7 <runcmd+0x93>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c5d:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c63:	89 d0                	mov    %edx,%eax
  100c65:	01 c0                	add    %eax,%eax
  100c67:	01 d0                	add    %edx,%eax
  100c69:	c1 e0 02             	shl    $0x2,%eax
  100c6c:	05 00 00 11 00       	add    $0x110000,%eax
  100c71:	8b 00                	mov    (%eax),%eax
  100c73:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c77:	89 04 24             	mov    %eax,(%esp)
  100c7a:	e8 6d 20 00 00       	call   102cec <strcmp>
  100c7f:	85 c0                	test   %eax,%eax
  100c81:	75 31                	jne    100cb4 <runcmd+0x90>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c86:	89 d0                	mov    %edx,%eax
  100c88:	01 c0                	add    %eax,%eax
  100c8a:	01 d0                	add    %edx,%eax
  100c8c:	c1 e0 02             	shl    $0x2,%eax
  100c8f:	05 08 00 11 00       	add    $0x110008,%eax
  100c94:	8b 10                	mov    (%eax),%edx
  100c96:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c99:	83 c0 04             	add    $0x4,%eax
  100c9c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c9f:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100ca2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100ca5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100ca9:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cad:	89 1c 24             	mov    %ebx,(%esp)
  100cb0:	ff d2                	call   *%edx
  100cb2:	eb 23                	jmp    100cd7 <runcmd+0xb3>
    for (i = 0; i < NCOMMANDS; i ++) {
  100cb4:	ff 45 f4             	incl   -0xc(%ebp)
  100cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cba:	83 f8 02             	cmp    $0x2,%eax
  100cbd:	76 9e                	jbe    100c5d <runcmd+0x39>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100cbf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100cc2:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cc6:	c7 04 24 1f 3a 10 00 	movl   $0x103a1f,(%esp)
  100ccd:	e8 c2 f5 ff ff       	call   100294 <cprintf>
    return 0;
  100cd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cd7:	83 c4 64             	add    $0x64,%esp
  100cda:	5b                   	pop    %ebx
  100cdb:	5d                   	pop    %ebp
  100cdc:	c3                   	ret    

00100cdd <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100cdd:	f3 0f 1e fb          	endbr32 
  100ce1:	55                   	push   %ebp
  100ce2:	89 e5                	mov    %esp,%ebp
  100ce4:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100ce7:	c7 04 24 38 3a 10 00 	movl   $0x103a38,(%esp)
  100cee:	e8 a1 f5 ff ff       	call   100294 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100cf3:	c7 04 24 60 3a 10 00 	movl   $0x103a60,(%esp)
  100cfa:	e8 95 f5 ff ff       	call   100294 <cprintf>

    if (tf != NULL) {
  100cff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100d03:	74 0b                	je     100d10 <kmonitor+0x33>
        print_trapframe(tf);
  100d05:	8b 45 08             	mov    0x8(%ebp),%eax
  100d08:	89 04 24             	mov    %eax,(%esp)
  100d0b:	e8 fb 0d 00 00       	call   101b0b <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100d10:	c7 04 24 85 3a 10 00 	movl   $0x103a85,(%esp)
  100d17:	e8 2b f6 ff ff       	call   100347 <readline>
  100d1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100d1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100d23:	74 eb                	je     100d10 <kmonitor+0x33>
            if (runcmd(buf, tf) < 0) {
  100d25:	8b 45 08             	mov    0x8(%ebp),%eax
  100d28:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d2f:	89 04 24             	mov    %eax,(%esp)
  100d32:	e8 ed fe ff ff       	call   100c24 <runcmd>
  100d37:	85 c0                	test   %eax,%eax
  100d39:	78 02                	js     100d3d <kmonitor+0x60>
        if ((buf = readline("K> ")) != NULL) {
  100d3b:	eb d3                	jmp    100d10 <kmonitor+0x33>
                break;
  100d3d:	90                   	nop
            }
        }
    }
}
  100d3e:	90                   	nop
  100d3f:	c9                   	leave  
  100d40:	c3                   	ret    

00100d41 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d41:	f3 0f 1e fb          	endbr32 
  100d45:	55                   	push   %ebp
  100d46:	89 e5                	mov    %esp,%ebp
  100d48:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d52:	eb 3d                	jmp    100d91 <mon_help+0x50>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d57:	89 d0                	mov    %edx,%eax
  100d59:	01 c0                	add    %eax,%eax
  100d5b:	01 d0                	add    %edx,%eax
  100d5d:	c1 e0 02             	shl    $0x2,%eax
  100d60:	05 04 00 11 00       	add    $0x110004,%eax
  100d65:	8b 08                	mov    (%eax),%ecx
  100d67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d6a:	89 d0                	mov    %edx,%eax
  100d6c:	01 c0                	add    %eax,%eax
  100d6e:	01 d0                	add    %edx,%eax
  100d70:	c1 e0 02             	shl    $0x2,%eax
  100d73:	05 00 00 11 00       	add    $0x110000,%eax
  100d78:	8b 00                	mov    (%eax),%eax
  100d7a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d82:	c7 04 24 89 3a 10 00 	movl   $0x103a89,(%esp)
  100d89:	e8 06 f5 ff ff       	call   100294 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100d8e:	ff 45 f4             	incl   -0xc(%ebp)
  100d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d94:	83 f8 02             	cmp    $0x2,%eax
  100d97:	76 bb                	jbe    100d54 <mon_help+0x13>
    }
    return 0;
  100d99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d9e:	c9                   	leave  
  100d9f:	c3                   	ret    

00100da0 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100da0:	f3 0f 1e fb          	endbr32 
  100da4:	55                   	push   %ebp
  100da5:	89 e5                	mov    %esp,%ebp
  100da7:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100daa:	e8 a8 fb ff ff       	call   100957 <print_kerninfo>
    return 0;
  100daf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100db4:	c9                   	leave  
  100db5:	c3                   	ret    

00100db6 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100db6:	f3 0f 1e fb          	endbr32 
  100dba:	55                   	push   %ebp
  100dbb:	89 e5                	mov    %esp,%ebp
  100dbd:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100dc0:	e8 e4 fc ff ff       	call   100aa9 <print_stackframe>
    return 0;
  100dc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100dca:	c9                   	leave  
  100dcb:	c3                   	ret    

00100dcc <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100dcc:	f3 0f 1e fb          	endbr32 
  100dd0:	55                   	push   %ebp
  100dd1:	89 e5                	mov    %esp,%ebp
  100dd3:	83 ec 28             	sub    $0x28,%esp
  100dd6:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100ddc:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100de0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100de4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100de8:	ee                   	out    %al,(%dx)
}
  100de9:	90                   	nop
  100dea:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100df0:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100df4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100df8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dfc:	ee                   	out    %al,(%dx)
}
  100dfd:	90                   	nop
  100dfe:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100e04:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e08:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100e0c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100e10:	ee                   	out    %al,(%dx)
}
  100e11:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100e12:	c7 05 08 19 11 00 00 	movl   $0x0,0x111908
  100e19:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e1c:	c7 04 24 92 3a 10 00 	movl   $0x103a92,(%esp)
  100e23:	e8 6c f4 ff ff       	call   100294 <cprintf>
    pic_enable(IRQ_TIMER);
  100e28:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e2f:	e8 31 09 00 00       	call   101765 <pic_enable>
}
  100e34:	90                   	nop
  100e35:	c9                   	leave  
  100e36:	c3                   	ret    

00100e37 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e37:	f3 0f 1e fb          	endbr32 
  100e3b:	55                   	push   %ebp
  100e3c:	89 e5                	mov    %esp,%ebp
  100e3e:	83 ec 10             	sub    $0x10,%esp
  100e41:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e47:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e4b:	89 c2                	mov    %eax,%edx
  100e4d:	ec                   	in     (%dx),%al
  100e4e:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e51:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e57:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e5b:	89 c2                	mov    %eax,%edx
  100e5d:	ec                   	in     (%dx),%al
  100e5e:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e61:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e67:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e6b:	89 c2                	mov    %eax,%edx
  100e6d:	ec                   	in     (%dx),%al
  100e6e:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e71:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100e77:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e7b:	89 c2                	mov    %eax,%edx
  100e7d:	ec                   	in     (%dx),%al
  100e7e:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e81:	90                   	nop
  100e82:	c9                   	leave  
  100e83:	c3                   	ret    

00100e84 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e84:	f3 0f 1e fb          	endbr32 
  100e88:	55                   	push   %ebp
  100e89:	89 e5                	mov    %esp,%ebp
  100e8b:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;
  100e8e:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e95:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e98:	0f b7 00             	movzwl (%eax),%eax
  100e9b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ea2:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100ea7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eaa:	0f b7 00             	movzwl (%eax),%eax
  100ead:	0f b7 c0             	movzwl %ax,%eax
  100eb0:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100eb5:	74 12                	je     100ec9 <cga_init+0x45>
        cp = (uint16_t*)MONO_BUF;
  100eb7:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100ebe:	66 c7 05 66 0e 11 00 	movw   $0x3b4,0x110e66
  100ec5:	b4 03 
  100ec7:	eb 13                	jmp    100edc <cga_init+0x58>
    } else {
        *cp = was;
  100ec9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ecc:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ed0:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100ed3:	66 c7 05 66 0e 11 00 	movw   $0x3d4,0x110e66
  100eda:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100edc:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100ee3:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100ee7:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100eeb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100eef:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100ef3:	ee                   	out    %al,(%dx)
}
  100ef4:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
  100ef5:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100efc:	40                   	inc    %eax
  100efd:	0f b7 c0             	movzwl %ax,%eax
  100f00:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f04:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100f08:	89 c2                	mov    %eax,%edx
  100f0a:	ec                   	in     (%dx),%al
  100f0b:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100f0e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f12:	0f b6 c0             	movzbl %al,%eax
  100f15:	c1 e0 08             	shl    $0x8,%eax
  100f18:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f1b:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100f22:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f26:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f2a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f2e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f32:	ee                   	out    %al,(%dx)
}
  100f33:	90                   	nop
    pos |= inb(addr_6845 + 1);
  100f34:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100f3b:	40                   	inc    %eax
  100f3c:	0f b7 c0             	movzwl %ax,%eax
  100f3f:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f43:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f47:	89 c2                	mov    %eax,%edx
  100f49:	ec                   	in     (%dx),%al
  100f4a:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100f4d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f51:	0f b6 c0             	movzbl %al,%eax
  100f54:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f57:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f5a:	a3 60 0e 11 00       	mov    %eax,0x110e60
    crt_pos = pos;
  100f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f62:	0f b7 c0             	movzwl %ax,%eax
  100f65:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
}
  100f6b:	90                   	nop
  100f6c:	c9                   	leave  
  100f6d:	c3                   	ret    

00100f6e <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f6e:	f3 0f 1e fb          	endbr32 
  100f72:	55                   	push   %ebp
  100f73:	89 e5                	mov    %esp,%ebp
  100f75:	83 ec 48             	sub    $0x48,%esp
  100f78:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100f7e:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f82:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100f86:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100f8a:	ee                   	out    %al,(%dx)
}
  100f8b:	90                   	nop
  100f8c:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f92:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f96:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100f9a:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f9e:	ee                   	out    %al,(%dx)
}
  100f9f:	90                   	nop
  100fa0:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100fa6:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100faa:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100fae:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100fb2:	ee                   	out    %al,(%dx)
}
  100fb3:	90                   	nop
  100fb4:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fba:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fbe:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fc2:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fc6:	ee                   	out    %al,(%dx)
}
  100fc7:	90                   	nop
  100fc8:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100fce:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fd2:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fd6:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fda:	ee                   	out    %al,(%dx)
}
  100fdb:	90                   	nop
  100fdc:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100fe2:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fe6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fea:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fee:	ee                   	out    %al,(%dx)
}
  100fef:	90                   	nop
  100ff0:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100ff6:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ffa:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ffe:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101002:	ee                   	out    %al,(%dx)
}
  101003:	90                   	nop
  101004:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10100a:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  10100e:	89 c2                	mov    %eax,%edx
  101010:	ec                   	in     (%dx),%al
  101011:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  101014:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  101018:	3c ff                	cmp    $0xff,%al
  10101a:	0f 95 c0             	setne  %al
  10101d:	0f b6 c0             	movzbl %al,%eax
  101020:	a3 68 0e 11 00       	mov    %eax,0x110e68
  101025:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10102b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10102f:	89 c2                	mov    %eax,%edx
  101031:	ec                   	in     (%dx),%al
  101032:	88 45 f1             	mov    %al,-0xf(%ebp)
  101035:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10103b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10103f:	89 c2                	mov    %eax,%edx
  101041:	ec                   	in     (%dx),%al
  101042:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101045:	a1 68 0e 11 00       	mov    0x110e68,%eax
  10104a:	85 c0                	test   %eax,%eax
  10104c:	74 0c                	je     10105a <serial_init+0xec>
        pic_enable(IRQ_COM1);
  10104e:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101055:	e8 0b 07 00 00       	call   101765 <pic_enable>
    }
}
  10105a:	90                   	nop
  10105b:	c9                   	leave  
  10105c:	c3                   	ret    

0010105d <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10105d:	f3 0f 1e fb          	endbr32 
  101061:	55                   	push   %ebp
  101062:	89 e5                	mov    %esp,%ebp
  101064:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101067:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10106e:	eb 08                	jmp    101078 <lpt_putc_sub+0x1b>
        delay();
  101070:	e8 c2 fd ff ff       	call   100e37 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101075:	ff 45 fc             	incl   -0x4(%ebp)
  101078:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  10107e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101082:	89 c2                	mov    %eax,%edx
  101084:	ec                   	in     (%dx),%al
  101085:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101088:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10108c:	84 c0                	test   %al,%al
  10108e:	78 09                	js     101099 <lpt_putc_sub+0x3c>
  101090:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101097:	7e d7                	jle    101070 <lpt_putc_sub+0x13>
    }
    outb(LPTPORT + 0, c);
  101099:	8b 45 08             	mov    0x8(%ebp),%eax
  10109c:	0f b6 c0             	movzbl %al,%eax
  10109f:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  1010a5:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010a8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010ac:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010b0:	ee                   	out    %al,(%dx)
}
  1010b1:	90                   	nop
  1010b2:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  1010b8:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010bc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010c0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010c4:	ee                   	out    %al,(%dx)
}
  1010c5:	90                   	nop
  1010c6:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  1010cc:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010d0:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1010d4:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1010d8:	ee                   	out    %al,(%dx)
}
  1010d9:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010da:	90                   	nop
  1010db:	c9                   	leave  
  1010dc:	c3                   	ret    

001010dd <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010dd:	f3 0f 1e fb          	endbr32 
  1010e1:	55                   	push   %ebp
  1010e2:	89 e5                	mov    %esp,%ebp
  1010e4:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010e7:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010eb:	74 0d                	je     1010fa <lpt_putc+0x1d>
        lpt_putc_sub(c);
  1010ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1010f0:	89 04 24             	mov    %eax,(%esp)
  1010f3:	e8 65 ff ff ff       	call   10105d <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  1010f8:	eb 24                	jmp    10111e <lpt_putc+0x41>
        lpt_putc_sub('\b');
  1010fa:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101101:	e8 57 ff ff ff       	call   10105d <lpt_putc_sub>
        lpt_putc_sub(' ');
  101106:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10110d:	e8 4b ff ff ff       	call   10105d <lpt_putc_sub>
        lpt_putc_sub('\b');
  101112:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101119:	e8 3f ff ff ff       	call   10105d <lpt_putc_sub>
}
  10111e:	90                   	nop
  10111f:	c9                   	leave  
  101120:	c3                   	ret    

00101121 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101121:	f3 0f 1e fb          	endbr32 
  101125:	55                   	push   %ebp
  101126:	89 e5                	mov    %esp,%ebp
  101128:	53                   	push   %ebx
  101129:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10112c:	8b 45 08             	mov    0x8(%ebp),%eax
  10112f:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101134:	85 c0                	test   %eax,%eax
  101136:	75 07                	jne    10113f <cga_putc+0x1e>
        c |= 0x0700;
  101138:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10113f:	8b 45 08             	mov    0x8(%ebp),%eax
  101142:	0f b6 c0             	movzbl %al,%eax
  101145:	83 f8 0d             	cmp    $0xd,%eax
  101148:	74 72                	je     1011bc <cga_putc+0x9b>
  10114a:	83 f8 0d             	cmp    $0xd,%eax
  10114d:	0f 8f a3 00 00 00    	jg     1011f6 <cga_putc+0xd5>
  101153:	83 f8 08             	cmp    $0x8,%eax
  101156:	74 0a                	je     101162 <cga_putc+0x41>
  101158:	83 f8 0a             	cmp    $0xa,%eax
  10115b:	74 4c                	je     1011a9 <cga_putc+0x88>
  10115d:	e9 94 00 00 00       	jmp    1011f6 <cga_putc+0xd5>
    case '\b':
        if (crt_pos > 0) {
  101162:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101169:	85 c0                	test   %eax,%eax
  10116b:	0f 84 af 00 00 00    	je     101220 <cga_putc+0xff>
            crt_pos --;
  101171:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101178:	48                   	dec    %eax
  101179:	0f b7 c0             	movzwl %ax,%eax
  10117c:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101182:	8b 45 08             	mov    0x8(%ebp),%eax
  101185:	98                   	cwtl   
  101186:	25 00 ff ff ff       	and    $0xffffff00,%eax
  10118b:	98                   	cwtl   
  10118c:	83 c8 20             	or     $0x20,%eax
  10118f:	98                   	cwtl   
  101190:	8b 15 60 0e 11 00    	mov    0x110e60,%edx
  101196:	0f b7 0d 64 0e 11 00 	movzwl 0x110e64,%ecx
  10119d:	01 c9                	add    %ecx,%ecx
  10119f:	01 ca                	add    %ecx,%edx
  1011a1:	0f b7 c0             	movzwl %ax,%eax
  1011a4:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1011a7:	eb 77                	jmp    101220 <cga_putc+0xff>
    case '\n':
        crt_pos += CRT_COLS;
  1011a9:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  1011b0:	83 c0 50             	add    $0x50,%eax
  1011b3:	0f b7 c0             	movzwl %ax,%eax
  1011b6:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1011bc:	0f b7 1d 64 0e 11 00 	movzwl 0x110e64,%ebx
  1011c3:	0f b7 0d 64 0e 11 00 	movzwl 0x110e64,%ecx
  1011ca:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  1011cf:	89 c8                	mov    %ecx,%eax
  1011d1:	f7 e2                	mul    %edx
  1011d3:	c1 ea 06             	shr    $0x6,%edx
  1011d6:	89 d0                	mov    %edx,%eax
  1011d8:	c1 e0 02             	shl    $0x2,%eax
  1011db:	01 d0                	add    %edx,%eax
  1011dd:	c1 e0 04             	shl    $0x4,%eax
  1011e0:	29 c1                	sub    %eax,%ecx
  1011e2:	89 c8                	mov    %ecx,%eax
  1011e4:	0f b7 c0             	movzwl %ax,%eax
  1011e7:	29 c3                	sub    %eax,%ebx
  1011e9:	89 d8                	mov    %ebx,%eax
  1011eb:	0f b7 c0             	movzwl %ax,%eax
  1011ee:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
        break;
  1011f4:	eb 2b                	jmp    101221 <cga_putc+0x100>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011f6:	8b 0d 60 0e 11 00    	mov    0x110e60,%ecx
  1011fc:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101203:	8d 50 01             	lea    0x1(%eax),%edx
  101206:	0f b7 d2             	movzwl %dx,%edx
  101209:	66 89 15 64 0e 11 00 	mov    %dx,0x110e64
  101210:	01 c0                	add    %eax,%eax
  101212:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101215:	8b 45 08             	mov    0x8(%ebp),%eax
  101218:	0f b7 c0             	movzwl %ax,%eax
  10121b:	66 89 02             	mov    %ax,(%edx)
        break;
  10121e:	eb 01                	jmp    101221 <cga_putc+0x100>
        break;
  101220:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101221:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101228:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  10122d:	76 5d                	jbe    10128c <cga_putc+0x16b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10122f:	a1 60 0e 11 00       	mov    0x110e60,%eax
  101234:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10123a:	a1 60 0e 11 00       	mov    0x110e60,%eax
  10123f:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101246:	00 
  101247:	89 54 24 04          	mov    %edx,0x4(%esp)
  10124b:	89 04 24             	mov    %eax,(%esp)
  10124e:	e8 42 1d 00 00       	call   102f95 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101253:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10125a:	eb 14                	jmp    101270 <cga_putc+0x14f>
            crt_buf[i] = 0x0700 | ' ';
  10125c:	a1 60 0e 11 00       	mov    0x110e60,%eax
  101261:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101264:	01 d2                	add    %edx,%edx
  101266:	01 d0                	add    %edx,%eax
  101268:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10126d:	ff 45 f4             	incl   -0xc(%ebp)
  101270:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101277:	7e e3                	jle    10125c <cga_putc+0x13b>
        }
        crt_pos -= CRT_COLS;
  101279:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101280:	83 e8 50             	sub    $0x50,%eax
  101283:	0f b7 c0             	movzwl %ax,%eax
  101286:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10128c:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  101293:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  101297:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10129b:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10129f:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012a3:	ee                   	out    %al,(%dx)
}
  1012a4:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  1012a5:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  1012ac:	c1 e8 08             	shr    $0x8,%eax
  1012af:	0f b7 c0             	movzwl %ax,%eax
  1012b2:	0f b6 c0             	movzbl %al,%eax
  1012b5:	0f b7 15 66 0e 11 00 	movzwl 0x110e66,%edx
  1012bc:	42                   	inc    %edx
  1012bd:	0f b7 d2             	movzwl %dx,%edx
  1012c0:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  1012c4:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012c7:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012cb:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012cf:	ee                   	out    %al,(%dx)
}
  1012d0:	90                   	nop
    outb(addr_6845, 15);
  1012d1:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  1012d8:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1012dc:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012e0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1012e4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1012e8:	ee                   	out    %al,(%dx)
}
  1012e9:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  1012ea:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  1012f1:	0f b6 c0             	movzbl %al,%eax
  1012f4:	0f b7 15 66 0e 11 00 	movzwl 0x110e66,%edx
  1012fb:	42                   	inc    %edx
  1012fc:	0f b7 d2             	movzwl %dx,%edx
  1012ff:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  101303:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101306:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10130a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10130e:	ee                   	out    %al,(%dx)
}
  10130f:	90                   	nop
}
  101310:	90                   	nop
  101311:	83 c4 34             	add    $0x34,%esp
  101314:	5b                   	pop    %ebx
  101315:	5d                   	pop    %ebp
  101316:	c3                   	ret    

00101317 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101317:	f3 0f 1e fb          	endbr32 
  10131b:	55                   	push   %ebp
  10131c:	89 e5                	mov    %esp,%ebp
  10131e:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101321:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101328:	eb 08                	jmp    101332 <serial_putc_sub+0x1b>
        delay();
  10132a:	e8 08 fb ff ff       	call   100e37 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10132f:	ff 45 fc             	incl   -0x4(%ebp)
  101332:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101338:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10133c:	89 c2                	mov    %eax,%edx
  10133e:	ec                   	in     (%dx),%al
  10133f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101342:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101346:	0f b6 c0             	movzbl %al,%eax
  101349:	83 e0 20             	and    $0x20,%eax
  10134c:	85 c0                	test   %eax,%eax
  10134e:	75 09                	jne    101359 <serial_putc_sub+0x42>
  101350:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101357:	7e d1                	jle    10132a <serial_putc_sub+0x13>
    }
    outb(COM1 + COM_TX, c);
  101359:	8b 45 08             	mov    0x8(%ebp),%eax
  10135c:	0f b6 c0             	movzbl %al,%eax
  10135f:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101365:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101368:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10136c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101370:	ee                   	out    %al,(%dx)
}
  101371:	90                   	nop
}
  101372:	90                   	nop
  101373:	c9                   	leave  
  101374:	c3                   	ret    

00101375 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101375:	f3 0f 1e fb          	endbr32 
  101379:	55                   	push   %ebp
  10137a:	89 e5                	mov    %esp,%ebp
  10137c:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10137f:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101383:	74 0d                	je     101392 <serial_putc+0x1d>
        serial_putc_sub(c);
  101385:	8b 45 08             	mov    0x8(%ebp),%eax
  101388:	89 04 24             	mov    %eax,(%esp)
  10138b:	e8 87 ff ff ff       	call   101317 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101390:	eb 24                	jmp    1013b6 <serial_putc+0x41>
        serial_putc_sub('\b');
  101392:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101399:	e8 79 ff ff ff       	call   101317 <serial_putc_sub>
        serial_putc_sub(' ');
  10139e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1013a5:	e8 6d ff ff ff       	call   101317 <serial_putc_sub>
        serial_putc_sub('\b');
  1013aa:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013b1:	e8 61 ff ff ff       	call   101317 <serial_putc_sub>
}
  1013b6:	90                   	nop
  1013b7:	c9                   	leave  
  1013b8:	c3                   	ret    

001013b9 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1013b9:	f3 0f 1e fb          	endbr32 
  1013bd:	55                   	push   %ebp
  1013be:	89 e5                	mov    %esp,%ebp
  1013c0:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1013c3:	eb 33                	jmp    1013f8 <cons_intr+0x3f>
        if (c != 0) {
  1013c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1013c9:	74 2d                	je     1013f8 <cons_intr+0x3f>
            cons.buf[cons.wpos ++] = c;
  1013cb:	a1 84 10 11 00       	mov    0x111084,%eax
  1013d0:	8d 50 01             	lea    0x1(%eax),%edx
  1013d3:	89 15 84 10 11 00    	mov    %edx,0x111084
  1013d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1013dc:	88 90 80 0e 11 00    	mov    %dl,0x110e80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1013e2:	a1 84 10 11 00       	mov    0x111084,%eax
  1013e7:	3d 00 02 00 00       	cmp    $0x200,%eax
  1013ec:	75 0a                	jne    1013f8 <cons_intr+0x3f>
                cons.wpos = 0;
  1013ee:	c7 05 84 10 11 00 00 	movl   $0x0,0x111084
  1013f5:	00 00 00 
    while ((c = (*proc)()) != -1) {
  1013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1013fb:	ff d0                	call   *%eax
  1013fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101400:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101404:	75 bf                	jne    1013c5 <cons_intr+0xc>
            }
        }
    }
}
  101406:	90                   	nop
  101407:	90                   	nop
  101408:	c9                   	leave  
  101409:	c3                   	ret    

0010140a <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10140a:	f3 0f 1e fb          	endbr32 
  10140e:	55                   	push   %ebp
  10140f:	89 e5                	mov    %esp,%ebp
  101411:	83 ec 10             	sub    $0x10,%esp
  101414:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10141a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10141e:	89 c2                	mov    %eax,%edx
  101420:	ec                   	in     (%dx),%al
  101421:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101424:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101428:	0f b6 c0             	movzbl %al,%eax
  10142b:	83 e0 01             	and    $0x1,%eax
  10142e:	85 c0                	test   %eax,%eax
  101430:	75 07                	jne    101439 <serial_proc_data+0x2f>
        return -1;
  101432:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101437:	eb 2a                	jmp    101463 <serial_proc_data+0x59>
  101439:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10143f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101443:	89 c2                	mov    %eax,%edx
  101445:	ec                   	in     (%dx),%al
  101446:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101449:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10144d:	0f b6 c0             	movzbl %al,%eax
  101450:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101453:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101457:	75 07                	jne    101460 <serial_proc_data+0x56>
        c = '\b';
  101459:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101460:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101463:	c9                   	leave  
  101464:	c3                   	ret    

00101465 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101465:	f3 0f 1e fb          	endbr32 
  101469:	55                   	push   %ebp
  10146a:	89 e5                	mov    %esp,%ebp
  10146c:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10146f:	a1 68 0e 11 00       	mov    0x110e68,%eax
  101474:	85 c0                	test   %eax,%eax
  101476:	74 0c                	je     101484 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  101478:	c7 04 24 0a 14 10 00 	movl   $0x10140a,(%esp)
  10147f:	e8 35 ff ff ff       	call   1013b9 <cons_intr>
    }
}
  101484:	90                   	nop
  101485:	c9                   	leave  
  101486:	c3                   	ret    

00101487 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101487:	f3 0f 1e fb          	endbr32 
  10148b:	55                   	push   %ebp
  10148c:	89 e5                	mov    %esp,%ebp
  10148e:	83 ec 38             	sub    $0x38,%esp
  101491:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101497:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10149a:	89 c2                	mov    %eax,%edx
  10149c:	ec                   	in     (%dx),%al
  10149d:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1014a0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1014a4:	0f b6 c0             	movzbl %al,%eax
  1014a7:	83 e0 01             	and    $0x1,%eax
  1014aa:	85 c0                	test   %eax,%eax
  1014ac:	75 0a                	jne    1014b8 <kbd_proc_data+0x31>
        return -1;
  1014ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1014b3:	e9 56 01 00 00       	jmp    10160e <kbd_proc_data+0x187>
  1014b8:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1014be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1014c1:	89 c2                	mov    %eax,%edx
  1014c3:	ec                   	in     (%dx),%al
  1014c4:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1014c7:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1014cb:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1014ce:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1014d2:	75 17                	jne    1014eb <kbd_proc_data+0x64>
        // E0 escape character
        shift |= E0ESC;
  1014d4:	a1 88 10 11 00       	mov    0x111088,%eax
  1014d9:	83 c8 40             	or     $0x40,%eax
  1014dc:	a3 88 10 11 00       	mov    %eax,0x111088
        return 0;
  1014e1:	b8 00 00 00 00       	mov    $0x0,%eax
  1014e6:	e9 23 01 00 00       	jmp    10160e <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  1014eb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ef:	84 c0                	test   %al,%al
  1014f1:	79 45                	jns    101538 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1014f3:	a1 88 10 11 00       	mov    0x111088,%eax
  1014f8:	83 e0 40             	and    $0x40,%eax
  1014fb:	85 c0                	test   %eax,%eax
  1014fd:	75 08                	jne    101507 <kbd_proc_data+0x80>
  1014ff:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101503:	24 7f                	and    $0x7f,%al
  101505:	eb 04                	jmp    10150b <kbd_proc_data+0x84>
  101507:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10150b:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10150e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101512:	0f b6 80 40 00 11 00 	movzbl 0x110040(%eax),%eax
  101519:	0c 40                	or     $0x40,%al
  10151b:	0f b6 c0             	movzbl %al,%eax
  10151e:	f7 d0                	not    %eax
  101520:	89 c2                	mov    %eax,%edx
  101522:	a1 88 10 11 00       	mov    0x111088,%eax
  101527:	21 d0                	and    %edx,%eax
  101529:	a3 88 10 11 00       	mov    %eax,0x111088
        return 0;
  10152e:	b8 00 00 00 00       	mov    $0x0,%eax
  101533:	e9 d6 00 00 00       	jmp    10160e <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101538:	a1 88 10 11 00       	mov    0x111088,%eax
  10153d:	83 e0 40             	and    $0x40,%eax
  101540:	85 c0                	test   %eax,%eax
  101542:	74 11                	je     101555 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101544:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101548:	a1 88 10 11 00       	mov    0x111088,%eax
  10154d:	83 e0 bf             	and    $0xffffffbf,%eax
  101550:	a3 88 10 11 00       	mov    %eax,0x111088
    }

    shift |= shiftcode[data];
  101555:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101559:	0f b6 80 40 00 11 00 	movzbl 0x110040(%eax),%eax
  101560:	0f b6 d0             	movzbl %al,%edx
  101563:	a1 88 10 11 00       	mov    0x111088,%eax
  101568:	09 d0                	or     %edx,%eax
  10156a:	a3 88 10 11 00       	mov    %eax,0x111088
    shift ^= togglecode[data];
  10156f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101573:	0f b6 80 40 01 11 00 	movzbl 0x110140(%eax),%eax
  10157a:	0f b6 d0             	movzbl %al,%edx
  10157d:	a1 88 10 11 00       	mov    0x111088,%eax
  101582:	31 d0                	xor    %edx,%eax
  101584:	a3 88 10 11 00       	mov    %eax,0x111088

    c = charcode[shift & (CTL | SHIFT)][data];
  101589:	a1 88 10 11 00       	mov    0x111088,%eax
  10158e:	83 e0 03             	and    $0x3,%eax
  101591:	8b 14 85 40 05 11 00 	mov    0x110540(,%eax,4),%edx
  101598:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10159c:	01 d0                	add    %edx,%eax
  10159e:	0f b6 00             	movzbl (%eax),%eax
  1015a1:	0f b6 c0             	movzbl %al,%eax
  1015a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1015a7:	a1 88 10 11 00       	mov    0x111088,%eax
  1015ac:	83 e0 08             	and    $0x8,%eax
  1015af:	85 c0                	test   %eax,%eax
  1015b1:	74 22                	je     1015d5 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1015b3:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1015b7:	7e 0c                	jle    1015c5 <kbd_proc_data+0x13e>
  1015b9:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1015bd:	7f 06                	jg     1015c5 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1015bf:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1015c3:	eb 10                	jmp    1015d5 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1015c5:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1015c9:	7e 0a                	jle    1015d5 <kbd_proc_data+0x14e>
  1015cb:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1015cf:	7f 04                	jg     1015d5 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1015d1:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1015d5:	a1 88 10 11 00       	mov    0x111088,%eax
  1015da:	f7 d0                	not    %eax
  1015dc:	83 e0 06             	and    $0x6,%eax
  1015df:	85 c0                	test   %eax,%eax
  1015e1:	75 28                	jne    10160b <kbd_proc_data+0x184>
  1015e3:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1015ea:	75 1f                	jne    10160b <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  1015ec:	c7 04 24 ad 3a 10 00 	movl   $0x103aad,(%esp)
  1015f3:	e8 9c ec ff ff       	call   100294 <cprintf>
  1015f8:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1015fe:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101602:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101606:	8b 55 e8             	mov    -0x18(%ebp),%edx
  101609:	ee                   	out    %al,(%dx)
}
  10160a:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10160b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10160e:	c9                   	leave  
  10160f:	c3                   	ret    

00101610 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101610:	f3 0f 1e fb          	endbr32 
  101614:	55                   	push   %ebp
  101615:	89 e5                	mov    %esp,%ebp
  101617:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  10161a:	c7 04 24 87 14 10 00 	movl   $0x101487,(%esp)
  101621:	e8 93 fd ff ff       	call   1013b9 <cons_intr>
}
  101626:	90                   	nop
  101627:	c9                   	leave  
  101628:	c3                   	ret    

00101629 <kbd_init>:

static void
kbd_init(void) {
  101629:	f3 0f 1e fb          	endbr32 
  10162d:	55                   	push   %ebp
  10162e:	89 e5                	mov    %esp,%ebp
  101630:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101633:	e8 d8 ff ff ff       	call   101610 <kbd_intr>
    pic_enable(IRQ_KBD);
  101638:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10163f:	e8 21 01 00 00       	call   101765 <pic_enable>
}
  101644:	90                   	nop
  101645:	c9                   	leave  
  101646:	c3                   	ret    

00101647 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101647:	f3 0f 1e fb          	endbr32 
  10164b:	55                   	push   %ebp
  10164c:	89 e5                	mov    %esp,%ebp
  10164e:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101651:	e8 2e f8 ff ff       	call   100e84 <cga_init>
    serial_init();
  101656:	e8 13 f9 ff ff       	call   100f6e <serial_init>
    kbd_init();
  10165b:	e8 c9 ff ff ff       	call   101629 <kbd_init>
    if (!serial_exists) {
  101660:	a1 68 0e 11 00       	mov    0x110e68,%eax
  101665:	85 c0                	test   %eax,%eax
  101667:	75 0c                	jne    101675 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  101669:	c7 04 24 b9 3a 10 00 	movl   $0x103ab9,(%esp)
  101670:	e8 1f ec ff ff       	call   100294 <cprintf>
    }
}
  101675:	90                   	nop
  101676:	c9                   	leave  
  101677:	c3                   	ret    

00101678 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101678:	f3 0f 1e fb          	endbr32 
  10167c:	55                   	push   %ebp
  10167d:	89 e5                	mov    %esp,%ebp
  10167f:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  101682:	8b 45 08             	mov    0x8(%ebp),%eax
  101685:	89 04 24             	mov    %eax,(%esp)
  101688:	e8 50 fa ff ff       	call   1010dd <lpt_putc>
    cga_putc(c);
  10168d:	8b 45 08             	mov    0x8(%ebp),%eax
  101690:	89 04 24             	mov    %eax,(%esp)
  101693:	e8 89 fa ff ff       	call   101121 <cga_putc>
    serial_putc(c);
  101698:	8b 45 08             	mov    0x8(%ebp),%eax
  10169b:	89 04 24             	mov    %eax,(%esp)
  10169e:	e8 d2 fc ff ff       	call   101375 <serial_putc>
}
  1016a3:	90                   	nop
  1016a4:	c9                   	leave  
  1016a5:	c3                   	ret    

001016a6 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1016a6:	f3 0f 1e fb          	endbr32 
  1016aa:	55                   	push   %ebp
  1016ab:	89 e5                	mov    %esp,%ebp
  1016ad:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1016b0:	e8 b0 fd ff ff       	call   101465 <serial_intr>
    kbd_intr();
  1016b5:	e8 56 ff ff ff       	call   101610 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1016ba:	8b 15 80 10 11 00    	mov    0x111080,%edx
  1016c0:	a1 84 10 11 00       	mov    0x111084,%eax
  1016c5:	39 c2                	cmp    %eax,%edx
  1016c7:	74 36                	je     1016ff <cons_getc+0x59>
        c = cons.buf[cons.rpos ++];
  1016c9:	a1 80 10 11 00       	mov    0x111080,%eax
  1016ce:	8d 50 01             	lea    0x1(%eax),%edx
  1016d1:	89 15 80 10 11 00    	mov    %edx,0x111080
  1016d7:	0f b6 80 80 0e 11 00 	movzbl 0x110e80(%eax),%eax
  1016de:	0f b6 c0             	movzbl %al,%eax
  1016e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1016e4:	a1 80 10 11 00       	mov    0x111080,%eax
  1016e9:	3d 00 02 00 00       	cmp    $0x200,%eax
  1016ee:	75 0a                	jne    1016fa <cons_getc+0x54>
            cons.rpos = 0;
  1016f0:	c7 05 80 10 11 00 00 	movl   $0x0,0x111080
  1016f7:	00 00 00 
        }
        return c;
  1016fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1016fd:	eb 05                	jmp    101704 <cons_getc+0x5e>
    }
    return 0;
  1016ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101704:	c9                   	leave  
  101705:	c3                   	ret    

00101706 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101706:	f3 0f 1e fb          	endbr32 
  10170a:	55                   	push   %ebp
  10170b:	89 e5                	mov    %esp,%ebp
  10170d:	83 ec 14             	sub    $0x14,%esp
  101710:	8b 45 08             	mov    0x8(%ebp),%eax
  101713:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101717:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10171a:	66 a3 50 05 11 00    	mov    %ax,0x110550
    if (did_init) {
  101720:	a1 8c 10 11 00       	mov    0x11108c,%eax
  101725:	85 c0                	test   %eax,%eax
  101727:	74 39                	je     101762 <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
  101729:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10172c:	0f b6 c0             	movzbl %al,%eax
  10172f:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101735:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101738:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10173c:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101740:	ee                   	out    %al,(%dx)
}
  101741:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  101742:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101746:	c1 e8 08             	shr    $0x8,%eax
  101749:	0f b7 c0             	movzwl %ax,%eax
  10174c:	0f b6 c0             	movzbl %al,%eax
  10174f:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101755:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101758:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10175c:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101760:	ee                   	out    %al,(%dx)
}
  101761:	90                   	nop
    }
}
  101762:	90                   	nop
  101763:	c9                   	leave  
  101764:	c3                   	ret    

00101765 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101765:	f3 0f 1e fb          	endbr32 
  101769:	55                   	push   %ebp
  10176a:	89 e5                	mov    %esp,%ebp
  10176c:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10176f:	8b 45 08             	mov    0x8(%ebp),%eax
  101772:	ba 01 00 00 00       	mov    $0x1,%edx
  101777:	88 c1                	mov    %al,%cl
  101779:	d3 e2                	shl    %cl,%edx
  10177b:	89 d0                	mov    %edx,%eax
  10177d:	98                   	cwtl   
  10177e:	f7 d0                	not    %eax
  101780:	0f bf d0             	movswl %ax,%edx
  101783:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  10178a:	98                   	cwtl   
  10178b:	21 d0                	and    %edx,%eax
  10178d:	98                   	cwtl   
  10178e:	0f b7 c0             	movzwl %ax,%eax
  101791:	89 04 24             	mov    %eax,(%esp)
  101794:	e8 6d ff ff ff       	call   101706 <pic_setmask>
}
  101799:	90                   	nop
  10179a:	c9                   	leave  
  10179b:	c3                   	ret    

0010179c <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10179c:	f3 0f 1e fb          	endbr32 
  1017a0:	55                   	push   %ebp
  1017a1:	89 e5                	mov    %esp,%ebp
  1017a3:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1017a6:	c7 05 8c 10 11 00 01 	movl   $0x1,0x11108c
  1017ad:	00 00 00 
  1017b0:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1017b6:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017ba:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017be:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017c2:	ee                   	out    %al,(%dx)
}
  1017c3:	90                   	nop
  1017c4:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  1017ca:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017ce:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017d2:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017d6:	ee                   	out    %al,(%dx)
}
  1017d7:	90                   	nop
  1017d8:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1017de:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017e2:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1017e6:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017ea:	ee                   	out    %al,(%dx)
}
  1017eb:	90                   	nop
  1017ec:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  1017f2:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017f6:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1017fa:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1017fe:	ee                   	out    %al,(%dx)
}
  1017ff:	90                   	nop
  101800:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101806:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10180a:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10180e:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101812:	ee                   	out    %al,(%dx)
}
  101813:	90                   	nop
  101814:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  10181a:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10181e:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101822:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101826:	ee                   	out    %al,(%dx)
}
  101827:	90                   	nop
  101828:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  10182e:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101832:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101836:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10183a:	ee                   	out    %al,(%dx)
}
  10183b:	90                   	nop
  10183c:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  101842:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101846:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10184a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10184e:	ee                   	out    %al,(%dx)
}
  10184f:	90                   	nop
  101850:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101856:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10185a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10185e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101862:	ee                   	out    %al,(%dx)
}
  101863:	90                   	nop
  101864:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  10186a:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10186e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101872:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101876:	ee                   	out    %al,(%dx)
}
  101877:	90                   	nop
  101878:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  10187e:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101882:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101886:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10188a:	ee                   	out    %al,(%dx)
}
  10188b:	90                   	nop
  10188c:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101892:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101896:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10189a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10189e:	ee                   	out    %al,(%dx)
}
  10189f:	90                   	nop
  1018a0:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  1018a6:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1018aa:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1018ae:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1018b2:	ee                   	out    %al,(%dx)
}
  1018b3:	90                   	nop
  1018b4:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1018ba:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1018be:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1018c2:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1018c6:	ee                   	out    %al,(%dx)
}
  1018c7:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1018c8:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  1018cf:	3d ff ff 00 00       	cmp    $0xffff,%eax
  1018d4:	74 0f                	je     1018e5 <pic_init+0x149>
        pic_setmask(irq_mask);
  1018d6:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  1018dd:	89 04 24             	mov    %eax,(%esp)
  1018e0:	e8 21 fe ff ff       	call   101706 <pic_setmask>
    }
}
  1018e5:	90                   	nop
  1018e6:	c9                   	leave  
  1018e7:	c3                   	ret    

001018e8 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1018e8:	f3 0f 1e fb          	endbr32 
  1018ec:	55                   	push   %ebp
  1018ed:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1018ef:	fb                   	sti    
}
  1018f0:	90                   	nop
    sti();
}
  1018f1:	90                   	nop
  1018f2:	5d                   	pop    %ebp
  1018f3:	c3                   	ret    

001018f4 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1018f4:	f3 0f 1e fb          	endbr32 
  1018f8:	55                   	push   %ebp
  1018f9:	89 e5                	mov    %esp,%ebp

static inline void
cli(void) {
    asm volatile ("cli");
  1018fb:	fa                   	cli    
}
  1018fc:	90                   	nop
    cli();
}
  1018fd:	90                   	nop
  1018fe:	5d                   	pop    %ebp
  1018ff:	c3                   	ret    

00101900 <print_ticks>:
#include <console.h>
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks() {
  101900:	f3 0f 1e fb          	endbr32 
  101904:	55                   	push   %ebp
  101905:	89 e5                	mov    %esp,%ebp
  101907:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10190a:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101911:	00 
  101912:	c7 04 24 e0 3a 10 00 	movl   $0x103ae0,(%esp)
  101919:	e8 76 e9 ff ff       	call   100294 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  10191e:	c7 04 24 ea 3a 10 00 	movl   $0x103aea,(%esp)
  101925:	e8 6a e9 ff ff       	call   100294 <cprintf>
    panic("EOT: kernel seems ok.");
  10192a:	c7 44 24 08 f8 3a 10 	movl   $0x103af8,0x8(%esp)
  101931:	00 
  101932:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  101939:	00 
  10193a:	c7 04 24 0e 3b 10 00 	movl   $0x103b0e,(%esp)
  101941:	e8 ba ea ff ff       	call   100400 <__panic>

00101946 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101946:	f3 0f 1e fb          	endbr32 
  10194a:	55                   	push   %ebp
  10194b:	89 e5                	mov    %esp,%ebp
  10194d:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101950:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101957:	e9 c4 00 00 00       	jmp    101a20 <idt_init+0xda>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  10195c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10195f:	8b 04 85 e0 05 11 00 	mov    0x1105e0(,%eax,4),%eax
  101966:	0f b7 d0             	movzwl %ax,%edx
  101969:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10196c:	66 89 14 c5 a0 10 11 	mov    %dx,0x1110a0(,%eax,8)
  101973:	00 
  101974:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101977:	66 c7 04 c5 a2 10 11 	movw   $0x8,0x1110a2(,%eax,8)
  10197e:	00 08 00 
  101981:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101984:	0f b6 14 c5 a4 10 11 	movzbl 0x1110a4(,%eax,8),%edx
  10198b:	00 
  10198c:	80 e2 e0             	and    $0xe0,%dl
  10198f:	88 14 c5 a4 10 11 00 	mov    %dl,0x1110a4(,%eax,8)
  101996:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101999:	0f b6 14 c5 a4 10 11 	movzbl 0x1110a4(,%eax,8),%edx
  1019a0:	00 
  1019a1:	80 e2 1f             	and    $0x1f,%dl
  1019a4:	88 14 c5 a4 10 11 00 	mov    %dl,0x1110a4(,%eax,8)
  1019ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019ae:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1019b5:	00 
  1019b6:	80 e2 f0             	and    $0xf0,%dl
  1019b9:	80 ca 0e             	or     $0xe,%dl
  1019bc:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  1019c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019c6:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1019cd:	00 
  1019ce:	80 e2 ef             	and    $0xef,%dl
  1019d1:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  1019d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019db:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1019e2:	00 
  1019e3:	80 e2 9f             	and    $0x9f,%dl
  1019e6:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  1019ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019f0:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1019f7:	00 
  1019f8:	80 ca 80             	or     $0x80,%dl
  1019fb:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  101a02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a05:	8b 04 85 e0 05 11 00 	mov    0x1105e0(,%eax,4),%eax
  101a0c:	c1 e8 10             	shr    $0x10,%eax
  101a0f:	0f b7 d0             	movzwl %ax,%edx
  101a12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a15:	66 89 14 c5 a6 10 11 	mov    %dx,0x1110a6(,%eax,8)
  101a1c:	00 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101a1d:	ff 45 fc             	incl   -0x4(%ebp)
  101a20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a23:	3d ff 00 00 00       	cmp    $0xff,%eax
  101a28:	0f 86 2e ff ff ff    	jbe    10195c <idt_init+0x16>
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101a2e:	a1 c4 07 11 00       	mov    0x1107c4,%eax
  101a33:	0f b7 c0             	movzwl %ax,%eax
  101a36:	66 a3 68 14 11 00    	mov    %ax,0x111468
  101a3c:	66 c7 05 6a 14 11 00 	movw   $0x8,0x11146a
  101a43:	08 00 
  101a45:	0f b6 05 6c 14 11 00 	movzbl 0x11146c,%eax
  101a4c:	24 e0                	and    $0xe0,%al
  101a4e:	a2 6c 14 11 00       	mov    %al,0x11146c
  101a53:	0f b6 05 6c 14 11 00 	movzbl 0x11146c,%eax
  101a5a:	24 1f                	and    $0x1f,%al
  101a5c:	a2 6c 14 11 00       	mov    %al,0x11146c
  101a61:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101a68:	24 f0                	and    $0xf0,%al
  101a6a:	0c 0e                	or     $0xe,%al
  101a6c:	a2 6d 14 11 00       	mov    %al,0x11146d
  101a71:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101a78:	24 ef                	and    $0xef,%al
  101a7a:	a2 6d 14 11 00       	mov    %al,0x11146d
  101a7f:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101a86:	0c 60                	or     $0x60,%al
  101a88:	a2 6d 14 11 00       	mov    %al,0x11146d
  101a8d:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101a94:	0c 80                	or     $0x80,%al
  101a96:	a2 6d 14 11 00       	mov    %al,0x11146d
  101a9b:	a1 c4 07 11 00       	mov    0x1107c4,%eax
  101aa0:	c1 e8 10             	shr    $0x10,%eax
  101aa3:	0f b7 c0             	movzwl %ax,%eax
  101aa6:	66 a3 6e 14 11 00    	mov    %ax,0x11146e
  101aac:	c7 45 f8 60 05 11 00 	movl   $0x110560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  101ab3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101ab6:	0f 01 18             	lidtl  (%eax)
}
  101ab9:	90                   	nop
	// load the IDT
    lidt(&idt_pd);
}
  101aba:	90                   	nop
  101abb:	c9                   	leave  
  101abc:	c3                   	ret    

00101abd <trapname>:

static const char *
trapname(int trapno) {
  101abd:	f3 0f 1e fb          	endbr32 
  101ac1:	55                   	push   %ebp
  101ac2:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac7:	83 f8 13             	cmp    $0x13,%eax
  101aca:	77 0c                	ja     101ad8 <trapname+0x1b>
        return excnames[trapno];
  101acc:	8b 45 08             	mov    0x8(%ebp),%eax
  101acf:	8b 04 85 60 3e 10 00 	mov    0x103e60(,%eax,4),%eax
  101ad6:	eb 18                	jmp    101af0 <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101ad8:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101adc:	7e 0d                	jle    101aeb <trapname+0x2e>
  101ade:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101ae2:	7f 07                	jg     101aeb <trapname+0x2e>
        return "Hardware Interrupt";
  101ae4:	b8 1f 3b 10 00       	mov    $0x103b1f,%eax
  101ae9:	eb 05                	jmp    101af0 <trapname+0x33>
    }
    return "(unknown trap)";
  101aeb:	b8 32 3b 10 00       	mov    $0x103b32,%eax
}
  101af0:	5d                   	pop    %ebp
  101af1:	c3                   	ret    

00101af2 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101af2:	f3 0f 1e fb          	endbr32 
  101af6:	55                   	push   %ebp
  101af7:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101af9:	8b 45 08             	mov    0x8(%ebp),%eax
  101afc:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b00:	83 f8 08             	cmp    $0x8,%eax
  101b03:	0f 94 c0             	sete   %al
  101b06:	0f b6 c0             	movzbl %al,%eax
}
  101b09:	5d                   	pop    %ebp
  101b0a:	c3                   	ret    

00101b0b <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101b0b:	f3 0f 1e fb          	endbr32 
  101b0f:	55                   	push   %ebp
  101b10:	89 e5                	mov    %esp,%ebp
  101b12:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101b15:	8b 45 08             	mov    0x8(%ebp),%eax
  101b18:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b1c:	c7 04 24 73 3b 10 00 	movl   $0x103b73,(%esp)
  101b23:	e8 6c e7 ff ff       	call   100294 <cprintf>
    print_regs(&tf->tf_regs);
  101b28:	8b 45 08             	mov    0x8(%ebp),%eax
  101b2b:	89 04 24             	mov    %eax,(%esp)
  101b2e:	e8 8d 01 00 00       	call   101cc0 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101b33:	8b 45 08             	mov    0x8(%ebp),%eax
  101b36:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b3e:	c7 04 24 84 3b 10 00 	movl   $0x103b84,(%esp)
  101b45:	e8 4a e7 ff ff       	call   100294 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4d:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101b51:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b55:	c7 04 24 97 3b 10 00 	movl   $0x103b97,(%esp)
  101b5c:	e8 33 e7 ff ff       	call   100294 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101b61:	8b 45 08             	mov    0x8(%ebp),%eax
  101b64:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b68:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b6c:	c7 04 24 aa 3b 10 00 	movl   $0x103baa,(%esp)
  101b73:	e8 1c e7 ff ff       	call   100294 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b78:	8b 45 08             	mov    0x8(%ebp),%eax
  101b7b:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b83:	c7 04 24 bd 3b 10 00 	movl   $0x103bbd,(%esp)
  101b8a:	e8 05 e7 ff ff       	call   100294 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b92:	8b 40 30             	mov    0x30(%eax),%eax
  101b95:	89 04 24             	mov    %eax,(%esp)
  101b98:	e8 20 ff ff ff       	call   101abd <trapname>
  101b9d:	8b 55 08             	mov    0x8(%ebp),%edx
  101ba0:	8b 52 30             	mov    0x30(%edx),%edx
  101ba3:	89 44 24 08          	mov    %eax,0x8(%esp)
  101ba7:	89 54 24 04          	mov    %edx,0x4(%esp)
  101bab:	c7 04 24 d0 3b 10 00 	movl   $0x103bd0,(%esp)
  101bb2:	e8 dd e6 ff ff       	call   100294 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  101bba:	8b 40 34             	mov    0x34(%eax),%eax
  101bbd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc1:	c7 04 24 e2 3b 10 00 	movl   $0x103be2,(%esp)
  101bc8:	e8 c7 e6 ff ff       	call   100294 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd0:	8b 40 38             	mov    0x38(%eax),%eax
  101bd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd7:	c7 04 24 f1 3b 10 00 	movl   $0x103bf1,(%esp)
  101bde:	e8 b1 e6 ff ff       	call   100294 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101be3:	8b 45 08             	mov    0x8(%ebp),%eax
  101be6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101bea:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bee:	c7 04 24 00 3c 10 00 	movl   $0x103c00,(%esp)
  101bf5:	e8 9a e6 ff ff       	call   100294 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfd:	8b 40 40             	mov    0x40(%eax),%eax
  101c00:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c04:	c7 04 24 13 3c 10 00 	movl   $0x103c13,(%esp)
  101c0b:	e8 84 e6 ff ff       	call   100294 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c10:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101c17:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101c1e:	eb 3d                	jmp    101c5d <print_trapframe+0x152>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101c20:	8b 45 08             	mov    0x8(%ebp),%eax
  101c23:	8b 50 40             	mov    0x40(%eax),%edx
  101c26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101c29:	21 d0                	and    %edx,%eax
  101c2b:	85 c0                	test   %eax,%eax
  101c2d:	74 28                	je     101c57 <print_trapframe+0x14c>
  101c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c32:	8b 04 85 80 05 11 00 	mov    0x110580(,%eax,4),%eax
  101c39:	85 c0                	test   %eax,%eax
  101c3b:	74 1a                	je     101c57 <print_trapframe+0x14c>
            cprintf("%s,", IA32flags[i]);
  101c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c40:	8b 04 85 80 05 11 00 	mov    0x110580(,%eax,4),%eax
  101c47:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c4b:	c7 04 24 22 3c 10 00 	movl   $0x103c22,(%esp)
  101c52:	e8 3d e6 ff ff       	call   100294 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c57:	ff 45 f4             	incl   -0xc(%ebp)
  101c5a:	d1 65 f0             	shll   -0x10(%ebp)
  101c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c60:	83 f8 17             	cmp    $0x17,%eax
  101c63:	76 bb                	jbe    101c20 <print_trapframe+0x115>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101c65:	8b 45 08             	mov    0x8(%ebp),%eax
  101c68:	8b 40 40             	mov    0x40(%eax),%eax
  101c6b:	c1 e8 0c             	shr    $0xc,%eax
  101c6e:	83 e0 03             	and    $0x3,%eax
  101c71:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c75:	c7 04 24 26 3c 10 00 	movl   $0x103c26,(%esp)
  101c7c:	e8 13 e6 ff ff       	call   100294 <cprintf>

    if (!trap_in_kernel(tf)) {
  101c81:	8b 45 08             	mov    0x8(%ebp),%eax
  101c84:	89 04 24             	mov    %eax,(%esp)
  101c87:	e8 66 fe ff ff       	call   101af2 <trap_in_kernel>
  101c8c:	85 c0                	test   %eax,%eax
  101c8e:	75 2d                	jne    101cbd <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c90:	8b 45 08             	mov    0x8(%ebp),%eax
  101c93:	8b 40 44             	mov    0x44(%eax),%eax
  101c96:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c9a:	c7 04 24 2f 3c 10 00 	movl   $0x103c2f,(%esp)
  101ca1:	e8 ee e5 ff ff       	call   100294 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca9:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101cad:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cb1:	c7 04 24 3e 3c 10 00 	movl   $0x103c3e,(%esp)
  101cb8:	e8 d7 e5 ff ff       	call   100294 <cprintf>
    }
}
  101cbd:	90                   	nop
  101cbe:	c9                   	leave  
  101cbf:	c3                   	ret    

00101cc0 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101cc0:	f3 0f 1e fb          	endbr32 
  101cc4:	55                   	push   %ebp
  101cc5:	89 e5                	mov    %esp,%ebp
  101cc7:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101cca:	8b 45 08             	mov    0x8(%ebp),%eax
  101ccd:	8b 00                	mov    (%eax),%eax
  101ccf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd3:	c7 04 24 51 3c 10 00 	movl   $0x103c51,(%esp)
  101cda:	e8 b5 e5 ff ff       	call   100294 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce2:	8b 40 04             	mov    0x4(%eax),%eax
  101ce5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ce9:	c7 04 24 60 3c 10 00 	movl   $0x103c60,(%esp)
  101cf0:	e8 9f e5 ff ff       	call   100294 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf8:	8b 40 08             	mov    0x8(%eax),%eax
  101cfb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cff:	c7 04 24 6f 3c 10 00 	movl   $0x103c6f,(%esp)
  101d06:	e8 89 e5 ff ff       	call   100294 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  101d0e:	8b 40 0c             	mov    0xc(%eax),%eax
  101d11:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d15:	c7 04 24 7e 3c 10 00 	movl   $0x103c7e,(%esp)
  101d1c:	e8 73 e5 ff ff       	call   100294 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101d21:	8b 45 08             	mov    0x8(%ebp),%eax
  101d24:	8b 40 10             	mov    0x10(%eax),%eax
  101d27:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d2b:	c7 04 24 8d 3c 10 00 	movl   $0x103c8d,(%esp)
  101d32:	e8 5d e5 ff ff       	call   100294 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d37:	8b 45 08             	mov    0x8(%ebp),%eax
  101d3a:	8b 40 14             	mov    0x14(%eax),%eax
  101d3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d41:	c7 04 24 9c 3c 10 00 	movl   $0x103c9c,(%esp)
  101d48:	e8 47 e5 ff ff       	call   100294 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  101d50:	8b 40 18             	mov    0x18(%eax),%eax
  101d53:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d57:	c7 04 24 ab 3c 10 00 	movl   $0x103cab,(%esp)
  101d5e:	e8 31 e5 ff ff       	call   100294 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d63:	8b 45 08             	mov    0x8(%ebp),%eax
  101d66:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d69:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d6d:	c7 04 24 ba 3c 10 00 	movl   $0x103cba,(%esp)
  101d74:	e8 1b e5 ff ff       	call   100294 <cprintf>
}
  101d79:	90                   	nop
  101d7a:	c9                   	leave  
  101d7b:	c3                   	ret    

00101d7c <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d7c:	f3 0f 1e fb          	endbr32 
  101d80:	55                   	push   %ebp
  101d81:	89 e5                	mov    %esp,%ebp
  101d83:	57                   	push   %edi
  101d84:	56                   	push   %esi
  101d85:	53                   	push   %ebx
  101d86:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
  101d89:	8b 45 08             	mov    0x8(%ebp),%eax
  101d8c:	8b 40 30             	mov    0x30(%eax),%eax
  101d8f:	83 f8 79             	cmp    $0x79,%eax
  101d92:	0f 84 c6 01 00 00    	je     101f5e <trap_dispatch+0x1e2>
  101d98:	83 f8 79             	cmp    $0x79,%eax
  101d9b:	0f 87 3a 02 00 00    	ja     101fdb <trap_dispatch+0x25f>
  101da1:	83 f8 78             	cmp    $0x78,%eax
  101da4:	0f 84 d0 00 00 00    	je     101e7a <trap_dispatch+0xfe>
  101daa:	83 f8 78             	cmp    $0x78,%eax
  101dad:	0f 87 28 02 00 00    	ja     101fdb <trap_dispatch+0x25f>
  101db3:	83 f8 2f             	cmp    $0x2f,%eax
  101db6:	0f 87 1f 02 00 00    	ja     101fdb <trap_dispatch+0x25f>
  101dbc:	83 f8 2e             	cmp    $0x2e,%eax
  101dbf:	0f 83 4b 02 00 00    	jae    102010 <trap_dispatch+0x294>
  101dc5:	83 f8 24             	cmp    $0x24,%eax
  101dc8:	74 5e                	je     101e28 <trap_dispatch+0xac>
  101dca:	83 f8 24             	cmp    $0x24,%eax
  101dcd:	0f 87 08 02 00 00    	ja     101fdb <trap_dispatch+0x25f>
  101dd3:	83 f8 20             	cmp    $0x20,%eax
  101dd6:	74 0a                	je     101de2 <trap_dispatch+0x66>
  101dd8:	83 f8 21             	cmp    $0x21,%eax
  101ddb:	74 74                	je     101e51 <trap_dispatch+0xd5>
  101ddd:	e9 f9 01 00 00       	jmp    101fdb <trap_dispatch+0x25f>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101de2:	a1 08 19 11 00       	mov    0x111908,%eax
  101de7:	40                   	inc    %eax
  101de8:	a3 08 19 11 00       	mov    %eax,0x111908
        if (ticks % TICK_NUM == 0) {
  101ded:	8b 0d 08 19 11 00    	mov    0x111908,%ecx
  101df3:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101df8:	89 c8                	mov    %ecx,%eax
  101dfa:	f7 e2                	mul    %edx
  101dfc:	c1 ea 05             	shr    $0x5,%edx
  101dff:	89 d0                	mov    %edx,%eax
  101e01:	c1 e0 02             	shl    $0x2,%eax
  101e04:	01 d0                	add    %edx,%eax
  101e06:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101e0d:	01 d0                	add    %edx,%eax
  101e0f:	c1 e0 02             	shl    $0x2,%eax
  101e12:	29 c1                	sub    %eax,%ecx
  101e14:	89 ca                	mov    %ecx,%edx
  101e16:	85 d2                	test   %edx,%edx
  101e18:	0f 85 f5 01 00 00    	jne    102013 <trap_dispatch+0x297>
            print_ticks();
  101e1e:	e8 dd fa ff ff       	call   101900 <print_ticks>
        }
        break;
  101e23:	e9 eb 01 00 00       	jmp    102013 <trap_dispatch+0x297>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101e28:	e8 79 f8 ff ff       	call   1016a6 <cons_getc>
  101e2d:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101e30:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101e34:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101e38:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e40:	c7 04 24 c9 3c 10 00 	movl   $0x103cc9,(%esp)
  101e47:	e8 48 e4 ff ff       	call   100294 <cprintf>
        break;
  101e4c:	e9 c9 01 00 00       	jmp    10201a <trap_dispatch+0x29e>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101e51:	e8 50 f8 ff ff       	call   1016a6 <cons_getc>
  101e56:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101e59:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101e5d:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101e61:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e65:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e69:	c7 04 24 db 3c 10 00 	movl   $0x103cdb,(%esp)
  101e70:	e8 1f e4 ff ff       	call   100294 <cprintf>
        break;
  101e75:	e9 a0 01 00 00       	jmp    10201a <trap_dispatch+0x29e>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
  101e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e7d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e81:	83 f8 1b             	cmp    $0x1b,%eax
  101e84:	0f 84 8c 01 00 00    	je     102016 <trap_dispatch+0x29a>
            switchk2u = *tf;
  101e8a:	8b 55 08             	mov    0x8(%ebp),%edx
  101e8d:	b8 20 19 11 00       	mov    $0x111920,%eax
  101e92:	bb 4c 00 00 00       	mov    $0x4c,%ebx
  101e97:	89 c1                	mov    %eax,%ecx
  101e99:	83 e1 01             	and    $0x1,%ecx
  101e9c:	85 c9                	test   %ecx,%ecx
  101e9e:	74 0c                	je     101eac <trap_dispatch+0x130>
  101ea0:	0f b6 0a             	movzbl (%edx),%ecx
  101ea3:	88 08                	mov    %cl,(%eax)
  101ea5:	8d 40 01             	lea    0x1(%eax),%eax
  101ea8:	8d 52 01             	lea    0x1(%edx),%edx
  101eab:	4b                   	dec    %ebx
  101eac:	89 c1                	mov    %eax,%ecx
  101eae:	83 e1 02             	and    $0x2,%ecx
  101eb1:	85 c9                	test   %ecx,%ecx
  101eb3:	74 0f                	je     101ec4 <trap_dispatch+0x148>
  101eb5:	0f b7 0a             	movzwl (%edx),%ecx
  101eb8:	66 89 08             	mov    %cx,(%eax)
  101ebb:	8d 40 02             	lea    0x2(%eax),%eax
  101ebe:	8d 52 02             	lea    0x2(%edx),%edx
  101ec1:	83 eb 02             	sub    $0x2,%ebx
  101ec4:	89 df                	mov    %ebx,%edi
  101ec6:	83 e7 fc             	and    $0xfffffffc,%edi
  101ec9:	b9 00 00 00 00       	mov    $0x0,%ecx
  101ece:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
  101ed1:	89 34 08             	mov    %esi,(%eax,%ecx,1)
  101ed4:	83 c1 04             	add    $0x4,%ecx
  101ed7:	39 f9                	cmp    %edi,%ecx
  101ed9:	72 f3                	jb     101ece <trap_dispatch+0x152>
  101edb:	01 c8                	add    %ecx,%eax
  101edd:	01 ca                	add    %ecx,%edx
  101edf:	b9 00 00 00 00       	mov    $0x0,%ecx
  101ee4:	89 de                	mov    %ebx,%esi
  101ee6:	83 e6 02             	and    $0x2,%esi
  101ee9:	85 f6                	test   %esi,%esi
  101eeb:	74 0b                	je     101ef8 <trap_dispatch+0x17c>
  101eed:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
  101ef1:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
  101ef5:	83 c1 02             	add    $0x2,%ecx
  101ef8:	83 e3 01             	and    $0x1,%ebx
  101efb:	85 db                	test   %ebx,%ebx
  101efd:	74 07                	je     101f06 <trap_dispatch+0x18a>
  101eff:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  101f03:	88 14 08             	mov    %dl,(%eax,%ecx,1)
            switchk2u.tf_cs = USER_CS;
  101f06:	66 c7 05 5c 19 11 00 	movw   $0x1b,0x11195c
  101f0d:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101f0f:	66 c7 05 68 19 11 00 	movw   $0x23,0x111968
  101f16:	23 00 
  101f18:	0f b7 05 68 19 11 00 	movzwl 0x111968,%eax
  101f1f:	66 a3 48 19 11 00    	mov    %ax,0x111948
  101f25:	0f b7 05 48 19 11 00 	movzwl 0x111948,%eax
  101f2c:	66 a3 4c 19 11 00    	mov    %ax,0x11194c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101f32:	8b 45 08             	mov    0x8(%ebp),%eax
  101f35:	83 c0 44             	add    $0x44,%eax
  101f38:	a3 64 19 11 00       	mov    %eax,0x111964
		
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101f3d:	a1 60 19 11 00       	mov    0x111960,%eax
  101f42:	0d 00 30 00 00       	or     $0x3000,%eax
  101f47:	a3 60 19 11 00       	mov    %eax,0x111960
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f4f:	83 e8 04             	sub    $0x4,%eax
  101f52:	ba 20 19 11 00       	mov    $0x111920,%edx
  101f57:	89 10                	mov    %edx,(%eax)
        }
        break;
  101f59:	e9 b8 00 00 00       	jmp    102016 <trap_dispatch+0x29a>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  101f61:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f65:	83 f8 08             	cmp    $0x8,%eax
  101f68:	0f 84 ab 00 00 00    	je     102019 <trap_dispatch+0x29d>
            tf->tf_cs = KERNEL_CS;
  101f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  101f71:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101f77:	8b 45 08             	mov    0x8(%ebp),%eax
  101f7a:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101f80:	8b 45 08             	mov    0x8(%ebp),%eax
  101f83:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101f87:	8b 45 08             	mov    0x8(%ebp),%eax
  101f8a:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  101f91:	8b 40 40             	mov    0x40(%eax),%eax
  101f94:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101f99:	89 c2                	mov    %eax,%edx
  101f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  101f9e:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  101fa4:	8b 40 44             	mov    0x44(%eax),%eax
  101fa7:	83 e8 44             	sub    $0x44,%eax
  101faa:	a3 6c 19 11 00       	mov    %eax,0x11196c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101faf:	a1 6c 19 11 00       	mov    0x11196c,%eax
  101fb4:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101fbb:	00 
  101fbc:	8b 55 08             	mov    0x8(%ebp),%edx
  101fbf:	89 54 24 04          	mov    %edx,0x4(%esp)
  101fc3:	89 04 24             	mov    %eax,(%esp)
  101fc6:	e8 ca 0f 00 00       	call   102f95 <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101fcb:	8b 15 6c 19 11 00    	mov    0x11196c,%edx
  101fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  101fd4:	83 e8 04             	sub    $0x4,%eax
  101fd7:	89 10                	mov    %edx,(%eax)
        }
        break;
  101fd9:	eb 3e                	jmp    102019 <trap_dispatch+0x29d>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  101fde:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101fe2:	83 e0 03             	and    $0x3,%eax
  101fe5:	85 c0                	test   %eax,%eax
  101fe7:	75 31                	jne    10201a <trap_dispatch+0x29e>
            print_trapframe(tf);
  101fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  101fec:	89 04 24             	mov    %eax,(%esp)
  101fef:	e8 17 fb ff ff       	call   101b0b <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101ff4:	c7 44 24 08 ea 3c 10 	movl   $0x103cea,0x8(%esp)
  101ffb:	00 
  101ffc:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
  102003:	00 
  102004:	c7 04 24 0e 3b 10 00 	movl   $0x103b0e,(%esp)
  10200b:	e8 f0 e3 ff ff       	call   100400 <__panic>
        break;
  102010:	90                   	nop
  102011:	eb 07                	jmp    10201a <trap_dispatch+0x29e>
        break;
  102013:	90                   	nop
  102014:	eb 04                	jmp    10201a <trap_dispatch+0x29e>
        break;
  102016:	90                   	nop
  102017:	eb 01                	jmp    10201a <trap_dispatch+0x29e>
        break;
  102019:	90                   	nop
        }
    }
}
  10201a:	90                   	nop
  10201b:	83 c4 2c             	add    $0x2c,%esp
  10201e:	5b                   	pop    %ebx
  10201f:	5e                   	pop    %esi
  102020:	5f                   	pop    %edi
  102021:	5d                   	pop    %ebp
  102022:	c3                   	ret    

00102023 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  102023:	f3 0f 1e fb          	endbr32 
  102027:	55                   	push   %ebp
  102028:	89 e5                	mov    %esp,%ebp
  10202a:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  10202d:	8b 45 08             	mov    0x8(%ebp),%eax
  102030:	89 04 24             	mov    %eax,(%esp)
  102033:	e8 44 fd ff ff       	call   101d7c <trap_dispatch>
}
  102038:	90                   	nop
  102039:	c9                   	leave  
  10203a:	c3                   	ret    

0010203b <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  10203b:	6a 00                	push   $0x0
  pushl $0
  10203d:	6a 00                	push   $0x0
  jmp __alltraps
  10203f:	e9 67 0a 00 00       	jmp    102aab <__alltraps>

00102044 <vector1>:
.globl vector1
vector1:
  pushl $0
  102044:	6a 00                	push   $0x0
  pushl $1
  102046:	6a 01                	push   $0x1
  jmp __alltraps
  102048:	e9 5e 0a 00 00       	jmp    102aab <__alltraps>

0010204d <vector2>:
.globl vector2
vector2:
  pushl $0
  10204d:	6a 00                	push   $0x0
  pushl $2
  10204f:	6a 02                	push   $0x2
  jmp __alltraps
  102051:	e9 55 0a 00 00       	jmp    102aab <__alltraps>

00102056 <vector3>:
.globl vector3
vector3:
  pushl $0
  102056:	6a 00                	push   $0x0
  pushl $3
  102058:	6a 03                	push   $0x3
  jmp __alltraps
  10205a:	e9 4c 0a 00 00       	jmp    102aab <__alltraps>

0010205f <vector4>:
.globl vector4
vector4:
  pushl $0
  10205f:	6a 00                	push   $0x0
  pushl $4
  102061:	6a 04                	push   $0x4
  jmp __alltraps
  102063:	e9 43 0a 00 00       	jmp    102aab <__alltraps>

00102068 <vector5>:
.globl vector5
vector5:
  pushl $0
  102068:	6a 00                	push   $0x0
  pushl $5
  10206a:	6a 05                	push   $0x5
  jmp __alltraps
  10206c:	e9 3a 0a 00 00       	jmp    102aab <__alltraps>

00102071 <vector6>:
.globl vector6
vector6:
  pushl $0
  102071:	6a 00                	push   $0x0
  pushl $6
  102073:	6a 06                	push   $0x6
  jmp __alltraps
  102075:	e9 31 0a 00 00       	jmp    102aab <__alltraps>

0010207a <vector7>:
.globl vector7
vector7:
  pushl $0
  10207a:	6a 00                	push   $0x0
  pushl $7
  10207c:	6a 07                	push   $0x7
  jmp __alltraps
  10207e:	e9 28 0a 00 00       	jmp    102aab <__alltraps>

00102083 <vector8>:
.globl vector8
vector8:
  pushl $8
  102083:	6a 08                	push   $0x8
  jmp __alltraps
  102085:	e9 21 0a 00 00       	jmp    102aab <__alltraps>

0010208a <vector9>:
.globl vector9
vector9:
  pushl $9
  10208a:	6a 09                	push   $0x9
  jmp __alltraps
  10208c:	e9 1a 0a 00 00       	jmp    102aab <__alltraps>

00102091 <vector10>:
.globl vector10
vector10:
  pushl $10
  102091:	6a 0a                	push   $0xa
  jmp __alltraps
  102093:	e9 13 0a 00 00       	jmp    102aab <__alltraps>

00102098 <vector11>:
.globl vector11
vector11:
  pushl $11
  102098:	6a 0b                	push   $0xb
  jmp __alltraps
  10209a:	e9 0c 0a 00 00       	jmp    102aab <__alltraps>

0010209f <vector12>:
.globl vector12
vector12:
  pushl $12
  10209f:	6a 0c                	push   $0xc
  jmp __alltraps
  1020a1:	e9 05 0a 00 00       	jmp    102aab <__alltraps>

001020a6 <vector13>:
.globl vector13
vector13:
  pushl $13
  1020a6:	6a 0d                	push   $0xd
  jmp __alltraps
  1020a8:	e9 fe 09 00 00       	jmp    102aab <__alltraps>

001020ad <vector14>:
.globl vector14
vector14:
  pushl $14
  1020ad:	6a 0e                	push   $0xe
  jmp __alltraps
  1020af:	e9 f7 09 00 00       	jmp    102aab <__alltraps>

001020b4 <vector15>:
.globl vector15
vector15:
  pushl $0
  1020b4:	6a 00                	push   $0x0
  pushl $15
  1020b6:	6a 0f                	push   $0xf
  jmp __alltraps
  1020b8:	e9 ee 09 00 00       	jmp    102aab <__alltraps>

001020bd <vector16>:
.globl vector16
vector16:
  pushl $0
  1020bd:	6a 00                	push   $0x0
  pushl $16
  1020bf:	6a 10                	push   $0x10
  jmp __alltraps
  1020c1:	e9 e5 09 00 00       	jmp    102aab <__alltraps>

001020c6 <vector17>:
.globl vector17
vector17:
  pushl $17
  1020c6:	6a 11                	push   $0x11
  jmp __alltraps
  1020c8:	e9 de 09 00 00       	jmp    102aab <__alltraps>

001020cd <vector18>:
.globl vector18
vector18:
  pushl $0
  1020cd:	6a 00                	push   $0x0
  pushl $18
  1020cf:	6a 12                	push   $0x12
  jmp __alltraps
  1020d1:	e9 d5 09 00 00       	jmp    102aab <__alltraps>

001020d6 <vector19>:
.globl vector19
vector19:
  pushl $0
  1020d6:	6a 00                	push   $0x0
  pushl $19
  1020d8:	6a 13                	push   $0x13
  jmp __alltraps
  1020da:	e9 cc 09 00 00       	jmp    102aab <__alltraps>

001020df <vector20>:
.globl vector20
vector20:
  pushl $0
  1020df:	6a 00                	push   $0x0
  pushl $20
  1020e1:	6a 14                	push   $0x14
  jmp __alltraps
  1020e3:	e9 c3 09 00 00       	jmp    102aab <__alltraps>

001020e8 <vector21>:
.globl vector21
vector21:
  pushl $0
  1020e8:	6a 00                	push   $0x0
  pushl $21
  1020ea:	6a 15                	push   $0x15
  jmp __alltraps
  1020ec:	e9 ba 09 00 00       	jmp    102aab <__alltraps>

001020f1 <vector22>:
.globl vector22
vector22:
  pushl $0
  1020f1:	6a 00                	push   $0x0
  pushl $22
  1020f3:	6a 16                	push   $0x16
  jmp __alltraps
  1020f5:	e9 b1 09 00 00       	jmp    102aab <__alltraps>

001020fa <vector23>:
.globl vector23
vector23:
  pushl $0
  1020fa:	6a 00                	push   $0x0
  pushl $23
  1020fc:	6a 17                	push   $0x17
  jmp __alltraps
  1020fe:	e9 a8 09 00 00       	jmp    102aab <__alltraps>

00102103 <vector24>:
.globl vector24
vector24:
  pushl $0
  102103:	6a 00                	push   $0x0
  pushl $24
  102105:	6a 18                	push   $0x18
  jmp __alltraps
  102107:	e9 9f 09 00 00       	jmp    102aab <__alltraps>

0010210c <vector25>:
.globl vector25
vector25:
  pushl $0
  10210c:	6a 00                	push   $0x0
  pushl $25
  10210e:	6a 19                	push   $0x19
  jmp __alltraps
  102110:	e9 96 09 00 00       	jmp    102aab <__alltraps>

00102115 <vector26>:
.globl vector26
vector26:
  pushl $0
  102115:	6a 00                	push   $0x0
  pushl $26
  102117:	6a 1a                	push   $0x1a
  jmp __alltraps
  102119:	e9 8d 09 00 00       	jmp    102aab <__alltraps>

0010211e <vector27>:
.globl vector27
vector27:
  pushl $0
  10211e:	6a 00                	push   $0x0
  pushl $27
  102120:	6a 1b                	push   $0x1b
  jmp __alltraps
  102122:	e9 84 09 00 00       	jmp    102aab <__alltraps>

00102127 <vector28>:
.globl vector28
vector28:
  pushl $0
  102127:	6a 00                	push   $0x0
  pushl $28
  102129:	6a 1c                	push   $0x1c
  jmp __alltraps
  10212b:	e9 7b 09 00 00       	jmp    102aab <__alltraps>

00102130 <vector29>:
.globl vector29
vector29:
  pushl $0
  102130:	6a 00                	push   $0x0
  pushl $29
  102132:	6a 1d                	push   $0x1d
  jmp __alltraps
  102134:	e9 72 09 00 00       	jmp    102aab <__alltraps>

00102139 <vector30>:
.globl vector30
vector30:
  pushl $0
  102139:	6a 00                	push   $0x0
  pushl $30
  10213b:	6a 1e                	push   $0x1e
  jmp __alltraps
  10213d:	e9 69 09 00 00       	jmp    102aab <__alltraps>

00102142 <vector31>:
.globl vector31
vector31:
  pushl $0
  102142:	6a 00                	push   $0x0
  pushl $31
  102144:	6a 1f                	push   $0x1f
  jmp __alltraps
  102146:	e9 60 09 00 00       	jmp    102aab <__alltraps>

0010214b <vector32>:
.globl vector32
vector32:
  pushl $0
  10214b:	6a 00                	push   $0x0
  pushl $32
  10214d:	6a 20                	push   $0x20
  jmp __alltraps
  10214f:	e9 57 09 00 00       	jmp    102aab <__alltraps>

00102154 <vector33>:
.globl vector33
vector33:
  pushl $0
  102154:	6a 00                	push   $0x0
  pushl $33
  102156:	6a 21                	push   $0x21
  jmp __alltraps
  102158:	e9 4e 09 00 00       	jmp    102aab <__alltraps>

0010215d <vector34>:
.globl vector34
vector34:
  pushl $0
  10215d:	6a 00                	push   $0x0
  pushl $34
  10215f:	6a 22                	push   $0x22
  jmp __alltraps
  102161:	e9 45 09 00 00       	jmp    102aab <__alltraps>

00102166 <vector35>:
.globl vector35
vector35:
  pushl $0
  102166:	6a 00                	push   $0x0
  pushl $35
  102168:	6a 23                	push   $0x23
  jmp __alltraps
  10216a:	e9 3c 09 00 00       	jmp    102aab <__alltraps>

0010216f <vector36>:
.globl vector36
vector36:
  pushl $0
  10216f:	6a 00                	push   $0x0
  pushl $36
  102171:	6a 24                	push   $0x24
  jmp __alltraps
  102173:	e9 33 09 00 00       	jmp    102aab <__alltraps>

00102178 <vector37>:
.globl vector37
vector37:
  pushl $0
  102178:	6a 00                	push   $0x0
  pushl $37
  10217a:	6a 25                	push   $0x25
  jmp __alltraps
  10217c:	e9 2a 09 00 00       	jmp    102aab <__alltraps>

00102181 <vector38>:
.globl vector38
vector38:
  pushl $0
  102181:	6a 00                	push   $0x0
  pushl $38
  102183:	6a 26                	push   $0x26
  jmp __alltraps
  102185:	e9 21 09 00 00       	jmp    102aab <__alltraps>

0010218a <vector39>:
.globl vector39
vector39:
  pushl $0
  10218a:	6a 00                	push   $0x0
  pushl $39
  10218c:	6a 27                	push   $0x27
  jmp __alltraps
  10218e:	e9 18 09 00 00       	jmp    102aab <__alltraps>

00102193 <vector40>:
.globl vector40
vector40:
  pushl $0
  102193:	6a 00                	push   $0x0
  pushl $40
  102195:	6a 28                	push   $0x28
  jmp __alltraps
  102197:	e9 0f 09 00 00       	jmp    102aab <__alltraps>

0010219c <vector41>:
.globl vector41
vector41:
  pushl $0
  10219c:	6a 00                	push   $0x0
  pushl $41
  10219e:	6a 29                	push   $0x29
  jmp __alltraps
  1021a0:	e9 06 09 00 00       	jmp    102aab <__alltraps>

001021a5 <vector42>:
.globl vector42
vector42:
  pushl $0
  1021a5:	6a 00                	push   $0x0
  pushl $42
  1021a7:	6a 2a                	push   $0x2a
  jmp __alltraps
  1021a9:	e9 fd 08 00 00       	jmp    102aab <__alltraps>

001021ae <vector43>:
.globl vector43
vector43:
  pushl $0
  1021ae:	6a 00                	push   $0x0
  pushl $43
  1021b0:	6a 2b                	push   $0x2b
  jmp __alltraps
  1021b2:	e9 f4 08 00 00       	jmp    102aab <__alltraps>

001021b7 <vector44>:
.globl vector44
vector44:
  pushl $0
  1021b7:	6a 00                	push   $0x0
  pushl $44
  1021b9:	6a 2c                	push   $0x2c
  jmp __alltraps
  1021bb:	e9 eb 08 00 00       	jmp    102aab <__alltraps>

001021c0 <vector45>:
.globl vector45
vector45:
  pushl $0
  1021c0:	6a 00                	push   $0x0
  pushl $45
  1021c2:	6a 2d                	push   $0x2d
  jmp __alltraps
  1021c4:	e9 e2 08 00 00       	jmp    102aab <__alltraps>

001021c9 <vector46>:
.globl vector46
vector46:
  pushl $0
  1021c9:	6a 00                	push   $0x0
  pushl $46
  1021cb:	6a 2e                	push   $0x2e
  jmp __alltraps
  1021cd:	e9 d9 08 00 00       	jmp    102aab <__alltraps>

001021d2 <vector47>:
.globl vector47
vector47:
  pushl $0
  1021d2:	6a 00                	push   $0x0
  pushl $47
  1021d4:	6a 2f                	push   $0x2f
  jmp __alltraps
  1021d6:	e9 d0 08 00 00       	jmp    102aab <__alltraps>

001021db <vector48>:
.globl vector48
vector48:
  pushl $0
  1021db:	6a 00                	push   $0x0
  pushl $48
  1021dd:	6a 30                	push   $0x30
  jmp __alltraps
  1021df:	e9 c7 08 00 00       	jmp    102aab <__alltraps>

001021e4 <vector49>:
.globl vector49
vector49:
  pushl $0
  1021e4:	6a 00                	push   $0x0
  pushl $49
  1021e6:	6a 31                	push   $0x31
  jmp __alltraps
  1021e8:	e9 be 08 00 00       	jmp    102aab <__alltraps>

001021ed <vector50>:
.globl vector50
vector50:
  pushl $0
  1021ed:	6a 00                	push   $0x0
  pushl $50
  1021ef:	6a 32                	push   $0x32
  jmp __alltraps
  1021f1:	e9 b5 08 00 00       	jmp    102aab <__alltraps>

001021f6 <vector51>:
.globl vector51
vector51:
  pushl $0
  1021f6:	6a 00                	push   $0x0
  pushl $51
  1021f8:	6a 33                	push   $0x33
  jmp __alltraps
  1021fa:	e9 ac 08 00 00       	jmp    102aab <__alltraps>

001021ff <vector52>:
.globl vector52
vector52:
  pushl $0
  1021ff:	6a 00                	push   $0x0
  pushl $52
  102201:	6a 34                	push   $0x34
  jmp __alltraps
  102203:	e9 a3 08 00 00       	jmp    102aab <__alltraps>

00102208 <vector53>:
.globl vector53
vector53:
  pushl $0
  102208:	6a 00                	push   $0x0
  pushl $53
  10220a:	6a 35                	push   $0x35
  jmp __alltraps
  10220c:	e9 9a 08 00 00       	jmp    102aab <__alltraps>

00102211 <vector54>:
.globl vector54
vector54:
  pushl $0
  102211:	6a 00                	push   $0x0
  pushl $54
  102213:	6a 36                	push   $0x36
  jmp __alltraps
  102215:	e9 91 08 00 00       	jmp    102aab <__alltraps>

0010221a <vector55>:
.globl vector55
vector55:
  pushl $0
  10221a:	6a 00                	push   $0x0
  pushl $55
  10221c:	6a 37                	push   $0x37
  jmp __alltraps
  10221e:	e9 88 08 00 00       	jmp    102aab <__alltraps>

00102223 <vector56>:
.globl vector56
vector56:
  pushl $0
  102223:	6a 00                	push   $0x0
  pushl $56
  102225:	6a 38                	push   $0x38
  jmp __alltraps
  102227:	e9 7f 08 00 00       	jmp    102aab <__alltraps>

0010222c <vector57>:
.globl vector57
vector57:
  pushl $0
  10222c:	6a 00                	push   $0x0
  pushl $57
  10222e:	6a 39                	push   $0x39
  jmp __alltraps
  102230:	e9 76 08 00 00       	jmp    102aab <__alltraps>

00102235 <vector58>:
.globl vector58
vector58:
  pushl $0
  102235:	6a 00                	push   $0x0
  pushl $58
  102237:	6a 3a                	push   $0x3a
  jmp __alltraps
  102239:	e9 6d 08 00 00       	jmp    102aab <__alltraps>

0010223e <vector59>:
.globl vector59
vector59:
  pushl $0
  10223e:	6a 00                	push   $0x0
  pushl $59
  102240:	6a 3b                	push   $0x3b
  jmp __alltraps
  102242:	e9 64 08 00 00       	jmp    102aab <__alltraps>

00102247 <vector60>:
.globl vector60
vector60:
  pushl $0
  102247:	6a 00                	push   $0x0
  pushl $60
  102249:	6a 3c                	push   $0x3c
  jmp __alltraps
  10224b:	e9 5b 08 00 00       	jmp    102aab <__alltraps>

00102250 <vector61>:
.globl vector61
vector61:
  pushl $0
  102250:	6a 00                	push   $0x0
  pushl $61
  102252:	6a 3d                	push   $0x3d
  jmp __alltraps
  102254:	e9 52 08 00 00       	jmp    102aab <__alltraps>

00102259 <vector62>:
.globl vector62
vector62:
  pushl $0
  102259:	6a 00                	push   $0x0
  pushl $62
  10225b:	6a 3e                	push   $0x3e
  jmp __alltraps
  10225d:	e9 49 08 00 00       	jmp    102aab <__alltraps>

00102262 <vector63>:
.globl vector63
vector63:
  pushl $0
  102262:	6a 00                	push   $0x0
  pushl $63
  102264:	6a 3f                	push   $0x3f
  jmp __alltraps
  102266:	e9 40 08 00 00       	jmp    102aab <__alltraps>

0010226b <vector64>:
.globl vector64
vector64:
  pushl $0
  10226b:	6a 00                	push   $0x0
  pushl $64
  10226d:	6a 40                	push   $0x40
  jmp __alltraps
  10226f:	e9 37 08 00 00       	jmp    102aab <__alltraps>

00102274 <vector65>:
.globl vector65
vector65:
  pushl $0
  102274:	6a 00                	push   $0x0
  pushl $65
  102276:	6a 41                	push   $0x41
  jmp __alltraps
  102278:	e9 2e 08 00 00       	jmp    102aab <__alltraps>

0010227d <vector66>:
.globl vector66
vector66:
  pushl $0
  10227d:	6a 00                	push   $0x0
  pushl $66
  10227f:	6a 42                	push   $0x42
  jmp __alltraps
  102281:	e9 25 08 00 00       	jmp    102aab <__alltraps>

00102286 <vector67>:
.globl vector67
vector67:
  pushl $0
  102286:	6a 00                	push   $0x0
  pushl $67
  102288:	6a 43                	push   $0x43
  jmp __alltraps
  10228a:	e9 1c 08 00 00       	jmp    102aab <__alltraps>

0010228f <vector68>:
.globl vector68
vector68:
  pushl $0
  10228f:	6a 00                	push   $0x0
  pushl $68
  102291:	6a 44                	push   $0x44
  jmp __alltraps
  102293:	e9 13 08 00 00       	jmp    102aab <__alltraps>

00102298 <vector69>:
.globl vector69
vector69:
  pushl $0
  102298:	6a 00                	push   $0x0
  pushl $69
  10229a:	6a 45                	push   $0x45
  jmp __alltraps
  10229c:	e9 0a 08 00 00       	jmp    102aab <__alltraps>

001022a1 <vector70>:
.globl vector70
vector70:
  pushl $0
  1022a1:	6a 00                	push   $0x0
  pushl $70
  1022a3:	6a 46                	push   $0x46
  jmp __alltraps
  1022a5:	e9 01 08 00 00       	jmp    102aab <__alltraps>

001022aa <vector71>:
.globl vector71
vector71:
  pushl $0
  1022aa:	6a 00                	push   $0x0
  pushl $71
  1022ac:	6a 47                	push   $0x47
  jmp __alltraps
  1022ae:	e9 f8 07 00 00       	jmp    102aab <__alltraps>

001022b3 <vector72>:
.globl vector72
vector72:
  pushl $0
  1022b3:	6a 00                	push   $0x0
  pushl $72
  1022b5:	6a 48                	push   $0x48
  jmp __alltraps
  1022b7:	e9 ef 07 00 00       	jmp    102aab <__alltraps>

001022bc <vector73>:
.globl vector73
vector73:
  pushl $0
  1022bc:	6a 00                	push   $0x0
  pushl $73
  1022be:	6a 49                	push   $0x49
  jmp __alltraps
  1022c0:	e9 e6 07 00 00       	jmp    102aab <__alltraps>

001022c5 <vector74>:
.globl vector74
vector74:
  pushl $0
  1022c5:	6a 00                	push   $0x0
  pushl $74
  1022c7:	6a 4a                	push   $0x4a
  jmp __alltraps
  1022c9:	e9 dd 07 00 00       	jmp    102aab <__alltraps>

001022ce <vector75>:
.globl vector75
vector75:
  pushl $0
  1022ce:	6a 00                	push   $0x0
  pushl $75
  1022d0:	6a 4b                	push   $0x4b
  jmp __alltraps
  1022d2:	e9 d4 07 00 00       	jmp    102aab <__alltraps>

001022d7 <vector76>:
.globl vector76
vector76:
  pushl $0
  1022d7:	6a 00                	push   $0x0
  pushl $76
  1022d9:	6a 4c                	push   $0x4c
  jmp __alltraps
  1022db:	e9 cb 07 00 00       	jmp    102aab <__alltraps>

001022e0 <vector77>:
.globl vector77
vector77:
  pushl $0
  1022e0:	6a 00                	push   $0x0
  pushl $77
  1022e2:	6a 4d                	push   $0x4d
  jmp __alltraps
  1022e4:	e9 c2 07 00 00       	jmp    102aab <__alltraps>

001022e9 <vector78>:
.globl vector78
vector78:
  pushl $0
  1022e9:	6a 00                	push   $0x0
  pushl $78
  1022eb:	6a 4e                	push   $0x4e
  jmp __alltraps
  1022ed:	e9 b9 07 00 00       	jmp    102aab <__alltraps>

001022f2 <vector79>:
.globl vector79
vector79:
  pushl $0
  1022f2:	6a 00                	push   $0x0
  pushl $79
  1022f4:	6a 4f                	push   $0x4f
  jmp __alltraps
  1022f6:	e9 b0 07 00 00       	jmp    102aab <__alltraps>

001022fb <vector80>:
.globl vector80
vector80:
  pushl $0
  1022fb:	6a 00                	push   $0x0
  pushl $80
  1022fd:	6a 50                	push   $0x50
  jmp __alltraps
  1022ff:	e9 a7 07 00 00       	jmp    102aab <__alltraps>

00102304 <vector81>:
.globl vector81
vector81:
  pushl $0
  102304:	6a 00                	push   $0x0
  pushl $81
  102306:	6a 51                	push   $0x51
  jmp __alltraps
  102308:	e9 9e 07 00 00       	jmp    102aab <__alltraps>

0010230d <vector82>:
.globl vector82
vector82:
  pushl $0
  10230d:	6a 00                	push   $0x0
  pushl $82
  10230f:	6a 52                	push   $0x52
  jmp __alltraps
  102311:	e9 95 07 00 00       	jmp    102aab <__alltraps>

00102316 <vector83>:
.globl vector83
vector83:
  pushl $0
  102316:	6a 00                	push   $0x0
  pushl $83
  102318:	6a 53                	push   $0x53
  jmp __alltraps
  10231a:	e9 8c 07 00 00       	jmp    102aab <__alltraps>

0010231f <vector84>:
.globl vector84
vector84:
  pushl $0
  10231f:	6a 00                	push   $0x0
  pushl $84
  102321:	6a 54                	push   $0x54
  jmp __alltraps
  102323:	e9 83 07 00 00       	jmp    102aab <__alltraps>

00102328 <vector85>:
.globl vector85
vector85:
  pushl $0
  102328:	6a 00                	push   $0x0
  pushl $85
  10232a:	6a 55                	push   $0x55
  jmp __alltraps
  10232c:	e9 7a 07 00 00       	jmp    102aab <__alltraps>

00102331 <vector86>:
.globl vector86
vector86:
  pushl $0
  102331:	6a 00                	push   $0x0
  pushl $86
  102333:	6a 56                	push   $0x56
  jmp __alltraps
  102335:	e9 71 07 00 00       	jmp    102aab <__alltraps>

0010233a <vector87>:
.globl vector87
vector87:
  pushl $0
  10233a:	6a 00                	push   $0x0
  pushl $87
  10233c:	6a 57                	push   $0x57
  jmp __alltraps
  10233e:	e9 68 07 00 00       	jmp    102aab <__alltraps>

00102343 <vector88>:
.globl vector88
vector88:
  pushl $0
  102343:	6a 00                	push   $0x0
  pushl $88
  102345:	6a 58                	push   $0x58
  jmp __alltraps
  102347:	e9 5f 07 00 00       	jmp    102aab <__alltraps>

0010234c <vector89>:
.globl vector89
vector89:
  pushl $0
  10234c:	6a 00                	push   $0x0
  pushl $89
  10234e:	6a 59                	push   $0x59
  jmp __alltraps
  102350:	e9 56 07 00 00       	jmp    102aab <__alltraps>

00102355 <vector90>:
.globl vector90
vector90:
  pushl $0
  102355:	6a 00                	push   $0x0
  pushl $90
  102357:	6a 5a                	push   $0x5a
  jmp __alltraps
  102359:	e9 4d 07 00 00       	jmp    102aab <__alltraps>

0010235e <vector91>:
.globl vector91
vector91:
  pushl $0
  10235e:	6a 00                	push   $0x0
  pushl $91
  102360:	6a 5b                	push   $0x5b
  jmp __alltraps
  102362:	e9 44 07 00 00       	jmp    102aab <__alltraps>

00102367 <vector92>:
.globl vector92
vector92:
  pushl $0
  102367:	6a 00                	push   $0x0
  pushl $92
  102369:	6a 5c                	push   $0x5c
  jmp __alltraps
  10236b:	e9 3b 07 00 00       	jmp    102aab <__alltraps>

00102370 <vector93>:
.globl vector93
vector93:
  pushl $0
  102370:	6a 00                	push   $0x0
  pushl $93
  102372:	6a 5d                	push   $0x5d
  jmp __alltraps
  102374:	e9 32 07 00 00       	jmp    102aab <__alltraps>

00102379 <vector94>:
.globl vector94
vector94:
  pushl $0
  102379:	6a 00                	push   $0x0
  pushl $94
  10237b:	6a 5e                	push   $0x5e
  jmp __alltraps
  10237d:	e9 29 07 00 00       	jmp    102aab <__alltraps>

00102382 <vector95>:
.globl vector95
vector95:
  pushl $0
  102382:	6a 00                	push   $0x0
  pushl $95
  102384:	6a 5f                	push   $0x5f
  jmp __alltraps
  102386:	e9 20 07 00 00       	jmp    102aab <__alltraps>

0010238b <vector96>:
.globl vector96
vector96:
  pushl $0
  10238b:	6a 00                	push   $0x0
  pushl $96
  10238d:	6a 60                	push   $0x60
  jmp __alltraps
  10238f:	e9 17 07 00 00       	jmp    102aab <__alltraps>

00102394 <vector97>:
.globl vector97
vector97:
  pushl $0
  102394:	6a 00                	push   $0x0
  pushl $97
  102396:	6a 61                	push   $0x61
  jmp __alltraps
  102398:	e9 0e 07 00 00       	jmp    102aab <__alltraps>

0010239d <vector98>:
.globl vector98
vector98:
  pushl $0
  10239d:	6a 00                	push   $0x0
  pushl $98
  10239f:	6a 62                	push   $0x62
  jmp __alltraps
  1023a1:	e9 05 07 00 00       	jmp    102aab <__alltraps>

001023a6 <vector99>:
.globl vector99
vector99:
  pushl $0
  1023a6:	6a 00                	push   $0x0
  pushl $99
  1023a8:	6a 63                	push   $0x63
  jmp __alltraps
  1023aa:	e9 fc 06 00 00       	jmp    102aab <__alltraps>

001023af <vector100>:
.globl vector100
vector100:
  pushl $0
  1023af:	6a 00                	push   $0x0
  pushl $100
  1023b1:	6a 64                	push   $0x64
  jmp __alltraps
  1023b3:	e9 f3 06 00 00       	jmp    102aab <__alltraps>

001023b8 <vector101>:
.globl vector101
vector101:
  pushl $0
  1023b8:	6a 00                	push   $0x0
  pushl $101
  1023ba:	6a 65                	push   $0x65
  jmp __alltraps
  1023bc:	e9 ea 06 00 00       	jmp    102aab <__alltraps>

001023c1 <vector102>:
.globl vector102
vector102:
  pushl $0
  1023c1:	6a 00                	push   $0x0
  pushl $102
  1023c3:	6a 66                	push   $0x66
  jmp __alltraps
  1023c5:	e9 e1 06 00 00       	jmp    102aab <__alltraps>

001023ca <vector103>:
.globl vector103
vector103:
  pushl $0
  1023ca:	6a 00                	push   $0x0
  pushl $103
  1023cc:	6a 67                	push   $0x67
  jmp __alltraps
  1023ce:	e9 d8 06 00 00       	jmp    102aab <__alltraps>

001023d3 <vector104>:
.globl vector104
vector104:
  pushl $0
  1023d3:	6a 00                	push   $0x0
  pushl $104
  1023d5:	6a 68                	push   $0x68
  jmp __alltraps
  1023d7:	e9 cf 06 00 00       	jmp    102aab <__alltraps>

001023dc <vector105>:
.globl vector105
vector105:
  pushl $0
  1023dc:	6a 00                	push   $0x0
  pushl $105
  1023de:	6a 69                	push   $0x69
  jmp __alltraps
  1023e0:	e9 c6 06 00 00       	jmp    102aab <__alltraps>

001023e5 <vector106>:
.globl vector106
vector106:
  pushl $0
  1023e5:	6a 00                	push   $0x0
  pushl $106
  1023e7:	6a 6a                	push   $0x6a
  jmp __alltraps
  1023e9:	e9 bd 06 00 00       	jmp    102aab <__alltraps>

001023ee <vector107>:
.globl vector107
vector107:
  pushl $0
  1023ee:	6a 00                	push   $0x0
  pushl $107
  1023f0:	6a 6b                	push   $0x6b
  jmp __alltraps
  1023f2:	e9 b4 06 00 00       	jmp    102aab <__alltraps>

001023f7 <vector108>:
.globl vector108
vector108:
  pushl $0
  1023f7:	6a 00                	push   $0x0
  pushl $108
  1023f9:	6a 6c                	push   $0x6c
  jmp __alltraps
  1023fb:	e9 ab 06 00 00       	jmp    102aab <__alltraps>

00102400 <vector109>:
.globl vector109
vector109:
  pushl $0
  102400:	6a 00                	push   $0x0
  pushl $109
  102402:	6a 6d                	push   $0x6d
  jmp __alltraps
  102404:	e9 a2 06 00 00       	jmp    102aab <__alltraps>

00102409 <vector110>:
.globl vector110
vector110:
  pushl $0
  102409:	6a 00                	push   $0x0
  pushl $110
  10240b:	6a 6e                	push   $0x6e
  jmp __alltraps
  10240d:	e9 99 06 00 00       	jmp    102aab <__alltraps>

00102412 <vector111>:
.globl vector111
vector111:
  pushl $0
  102412:	6a 00                	push   $0x0
  pushl $111
  102414:	6a 6f                	push   $0x6f
  jmp __alltraps
  102416:	e9 90 06 00 00       	jmp    102aab <__alltraps>

0010241b <vector112>:
.globl vector112
vector112:
  pushl $0
  10241b:	6a 00                	push   $0x0
  pushl $112
  10241d:	6a 70                	push   $0x70
  jmp __alltraps
  10241f:	e9 87 06 00 00       	jmp    102aab <__alltraps>

00102424 <vector113>:
.globl vector113
vector113:
  pushl $0
  102424:	6a 00                	push   $0x0
  pushl $113
  102426:	6a 71                	push   $0x71
  jmp __alltraps
  102428:	e9 7e 06 00 00       	jmp    102aab <__alltraps>

0010242d <vector114>:
.globl vector114
vector114:
  pushl $0
  10242d:	6a 00                	push   $0x0
  pushl $114
  10242f:	6a 72                	push   $0x72
  jmp __alltraps
  102431:	e9 75 06 00 00       	jmp    102aab <__alltraps>

00102436 <vector115>:
.globl vector115
vector115:
  pushl $0
  102436:	6a 00                	push   $0x0
  pushl $115
  102438:	6a 73                	push   $0x73
  jmp __alltraps
  10243a:	e9 6c 06 00 00       	jmp    102aab <__alltraps>

0010243f <vector116>:
.globl vector116
vector116:
  pushl $0
  10243f:	6a 00                	push   $0x0
  pushl $116
  102441:	6a 74                	push   $0x74
  jmp __alltraps
  102443:	e9 63 06 00 00       	jmp    102aab <__alltraps>

00102448 <vector117>:
.globl vector117
vector117:
  pushl $0
  102448:	6a 00                	push   $0x0
  pushl $117
  10244a:	6a 75                	push   $0x75
  jmp __alltraps
  10244c:	e9 5a 06 00 00       	jmp    102aab <__alltraps>

00102451 <vector118>:
.globl vector118
vector118:
  pushl $0
  102451:	6a 00                	push   $0x0
  pushl $118
  102453:	6a 76                	push   $0x76
  jmp __alltraps
  102455:	e9 51 06 00 00       	jmp    102aab <__alltraps>

0010245a <vector119>:
.globl vector119
vector119:
  pushl $0
  10245a:	6a 00                	push   $0x0
  pushl $119
  10245c:	6a 77                	push   $0x77
  jmp __alltraps
  10245e:	e9 48 06 00 00       	jmp    102aab <__alltraps>

00102463 <vector120>:
.globl vector120
vector120:
  pushl $0
  102463:	6a 00                	push   $0x0
  pushl $120
  102465:	6a 78                	push   $0x78
  jmp __alltraps
  102467:	e9 3f 06 00 00       	jmp    102aab <__alltraps>

0010246c <vector121>:
.globl vector121
vector121:
  pushl $0
  10246c:	6a 00                	push   $0x0
  pushl $121
  10246e:	6a 79                	push   $0x79
  jmp __alltraps
  102470:	e9 36 06 00 00       	jmp    102aab <__alltraps>

00102475 <vector122>:
.globl vector122
vector122:
  pushl $0
  102475:	6a 00                	push   $0x0
  pushl $122
  102477:	6a 7a                	push   $0x7a
  jmp __alltraps
  102479:	e9 2d 06 00 00       	jmp    102aab <__alltraps>

0010247e <vector123>:
.globl vector123
vector123:
  pushl $0
  10247e:	6a 00                	push   $0x0
  pushl $123
  102480:	6a 7b                	push   $0x7b
  jmp __alltraps
  102482:	e9 24 06 00 00       	jmp    102aab <__alltraps>

00102487 <vector124>:
.globl vector124
vector124:
  pushl $0
  102487:	6a 00                	push   $0x0
  pushl $124
  102489:	6a 7c                	push   $0x7c
  jmp __alltraps
  10248b:	e9 1b 06 00 00       	jmp    102aab <__alltraps>

00102490 <vector125>:
.globl vector125
vector125:
  pushl $0
  102490:	6a 00                	push   $0x0
  pushl $125
  102492:	6a 7d                	push   $0x7d
  jmp __alltraps
  102494:	e9 12 06 00 00       	jmp    102aab <__alltraps>

00102499 <vector126>:
.globl vector126
vector126:
  pushl $0
  102499:	6a 00                	push   $0x0
  pushl $126
  10249b:	6a 7e                	push   $0x7e
  jmp __alltraps
  10249d:	e9 09 06 00 00       	jmp    102aab <__alltraps>

001024a2 <vector127>:
.globl vector127
vector127:
  pushl $0
  1024a2:	6a 00                	push   $0x0
  pushl $127
  1024a4:	6a 7f                	push   $0x7f
  jmp __alltraps
  1024a6:	e9 00 06 00 00       	jmp    102aab <__alltraps>

001024ab <vector128>:
.globl vector128
vector128:
  pushl $0
  1024ab:	6a 00                	push   $0x0
  pushl $128
  1024ad:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1024b2:	e9 f4 05 00 00       	jmp    102aab <__alltraps>

001024b7 <vector129>:
.globl vector129
vector129:
  pushl $0
  1024b7:	6a 00                	push   $0x0
  pushl $129
  1024b9:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1024be:	e9 e8 05 00 00       	jmp    102aab <__alltraps>

001024c3 <vector130>:
.globl vector130
vector130:
  pushl $0
  1024c3:	6a 00                	push   $0x0
  pushl $130
  1024c5:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1024ca:	e9 dc 05 00 00       	jmp    102aab <__alltraps>

001024cf <vector131>:
.globl vector131
vector131:
  pushl $0
  1024cf:	6a 00                	push   $0x0
  pushl $131
  1024d1:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1024d6:	e9 d0 05 00 00       	jmp    102aab <__alltraps>

001024db <vector132>:
.globl vector132
vector132:
  pushl $0
  1024db:	6a 00                	push   $0x0
  pushl $132
  1024dd:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1024e2:	e9 c4 05 00 00       	jmp    102aab <__alltraps>

001024e7 <vector133>:
.globl vector133
vector133:
  pushl $0
  1024e7:	6a 00                	push   $0x0
  pushl $133
  1024e9:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1024ee:	e9 b8 05 00 00       	jmp    102aab <__alltraps>

001024f3 <vector134>:
.globl vector134
vector134:
  pushl $0
  1024f3:	6a 00                	push   $0x0
  pushl $134
  1024f5:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1024fa:	e9 ac 05 00 00       	jmp    102aab <__alltraps>

001024ff <vector135>:
.globl vector135
vector135:
  pushl $0
  1024ff:	6a 00                	push   $0x0
  pushl $135
  102501:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102506:	e9 a0 05 00 00       	jmp    102aab <__alltraps>

0010250b <vector136>:
.globl vector136
vector136:
  pushl $0
  10250b:	6a 00                	push   $0x0
  pushl $136
  10250d:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102512:	e9 94 05 00 00       	jmp    102aab <__alltraps>

00102517 <vector137>:
.globl vector137
vector137:
  pushl $0
  102517:	6a 00                	push   $0x0
  pushl $137
  102519:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10251e:	e9 88 05 00 00       	jmp    102aab <__alltraps>

00102523 <vector138>:
.globl vector138
vector138:
  pushl $0
  102523:	6a 00                	push   $0x0
  pushl $138
  102525:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10252a:	e9 7c 05 00 00       	jmp    102aab <__alltraps>

0010252f <vector139>:
.globl vector139
vector139:
  pushl $0
  10252f:	6a 00                	push   $0x0
  pushl $139
  102531:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102536:	e9 70 05 00 00       	jmp    102aab <__alltraps>

0010253b <vector140>:
.globl vector140
vector140:
  pushl $0
  10253b:	6a 00                	push   $0x0
  pushl $140
  10253d:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102542:	e9 64 05 00 00       	jmp    102aab <__alltraps>

00102547 <vector141>:
.globl vector141
vector141:
  pushl $0
  102547:	6a 00                	push   $0x0
  pushl $141
  102549:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10254e:	e9 58 05 00 00       	jmp    102aab <__alltraps>

00102553 <vector142>:
.globl vector142
vector142:
  pushl $0
  102553:	6a 00                	push   $0x0
  pushl $142
  102555:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10255a:	e9 4c 05 00 00       	jmp    102aab <__alltraps>

0010255f <vector143>:
.globl vector143
vector143:
  pushl $0
  10255f:	6a 00                	push   $0x0
  pushl $143
  102561:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102566:	e9 40 05 00 00       	jmp    102aab <__alltraps>

0010256b <vector144>:
.globl vector144
vector144:
  pushl $0
  10256b:	6a 00                	push   $0x0
  pushl $144
  10256d:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102572:	e9 34 05 00 00       	jmp    102aab <__alltraps>

00102577 <vector145>:
.globl vector145
vector145:
  pushl $0
  102577:	6a 00                	push   $0x0
  pushl $145
  102579:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10257e:	e9 28 05 00 00       	jmp    102aab <__alltraps>

00102583 <vector146>:
.globl vector146
vector146:
  pushl $0
  102583:	6a 00                	push   $0x0
  pushl $146
  102585:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10258a:	e9 1c 05 00 00       	jmp    102aab <__alltraps>

0010258f <vector147>:
.globl vector147
vector147:
  pushl $0
  10258f:	6a 00                	push   $0x0
  pushl $147
  102591:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102596:	e9 10 05 00 00       	jmp    102aab <__alltraps>

0010259b <vector148>:
.globl vector148
vector148:
  pushl $0
  10259b:	6a 00                	push   $0x0
  pushl $148
  10259d:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1025a2:	e9 04 05 00 00       	jmp    102aab <__alltraps>

001025a7 <vector149>:
.globl vector149
vector149:
  pushl $0
  1025a7:	6a 00                	push   $0x0
  pushl $149
  1025a9:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1025ae:	e9 f8 04 00 00       	jmp    102aab <__alltraps>

001025b3 <vector150>:
.globl vector150
vector150:
  pushl $0
  1025b3:	6a 00                	push   $0x0
  pushl $150
  1025b5:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1025ba:	e9 ec 04 00 00       	jmp    102aab <__alltraps>

001025bf <vector151>:
.globl vector151
vector151:
  pushl $0
  1025bf:	6a 00                	push   $0x0
  pushl $151
  1025c1:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1025c6:	e9 e0 04 00 00       	jmp    102aab <__alltraps>

001025cb <vector152>:
.globl vector152
vector152:
  pushl $0
  1025cb:	6a 00                	push   $0x0
  pushl $152
  1025cd:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1025d2:	e9 d4 04 00 00       	jmp    102aab <__alltraps>

001025d7 <vector153>:
.globl vector153
vector153:
  pushl $0
  1025d7:	6a 00                	push   $0x0
  pushl $153
  1025d9:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1025de:	e9 c8 04 00 00       	jmp    102aab <__alltraps>

001025e3 <vector154>:
.globl vector154
vector154:
  pushl $0
  1025e3:	6a 00                	push   $0x0
  pushl $154
  1025e5:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1025ea:	e9 bc 04 00 00       	jmp    102aab <__alltraps>

001025ef <vector155>:
.globl vector155
vector155:
  pushl $0
  1025ef:	6a 00                	push   $0x0
  pushl $155
  1025f1:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1025f6:	e9 b0 04 00 00       	jmp    102aab <__alltraps>

001025fb <vector156>:
.globl vector156
vector156:
  pushl $0
  1025fb:	6a 00                	push   $0x0
  pushl $156
  1025fd:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102602:	e9 a4 04 00 00       	jmp    102aab <__alltraps>

00102607 <vector157>:
.globl vector157
vector157:
  pushl $0
  102607:	6a 00                	push   $0x0
  pushl $157
  102609:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10260e:	e9 98 04 00 00       	jmp    102aab <__alltraps>

00102613 <vector158>:
.globl vector158
vector158:
  pushl $0
  102613:	6a 00                	push   $0x0
  pushl $158
  102615:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10261a:	e9 8c 04 00 00       	jmp    102aab <__alltraps>

0010261f <vector159>:
.globl vector159
vector159:
  pushl $0
  10261f:	6a 00                	push   $0x0
  pushl $159
  102621:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102626:	e9 80 04 00 00       	jmp    102aab <__alltraps>

0010262b <vector160>:
.globl vector160
vector160:
  pushl $0
  10262b:	6a 00                	push   $0x0
  pushl $160
  10262d:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102632:	e9 74 04 00 00       	jmp    102aab <__alltraps>

00102637 <vector161>:
.globl vector161
vector161:
  pushl $0
  102637:	6a 00                	push   $0x0
  pushl $161
  102639:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10263e:	e9 68 04 00 00       	jmp    102aab <__alltraps>

00102643 <vector162>:
.globl vector162
vector162:
  pushl $0
  102643:	6a 00                	push   $0x0
  pushl $162
  102645:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10264a:	e9 5c 04 00 00       	jmp    102aab <__alltraps>

0010264f <vector163>:
.globl vector163
vector163:
  pushl $0
  10264f:	6a 00                	push   $0x0
  pushl $163
  102651:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102656:	e9 50 04 00 00       	jmp    102aab <__alltraps>

0010265b <vector164>:
.globl vector164
vector164:
  pushl $0
  10265b:	6a 00                	push   $0x0
  pushl $164
  10265d:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102662:	e9 44 04 00 00       	jmp    102aab <__alltraps>

00102667 <vector165>:
.globl vector165
vector165:
  pushl $0
  102667:	6a 00                	push   $0x0
  pushl $165
  102669:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10266e:	e9 38 04 00 00       	jmp    102aab <__alltraps>

00102673 <vector166>:
.globl vector166
vector166:
  pushl $0
  102673:	6a 00                	push   $0x0
  pushl $166
  102675:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10267a:	e9 2c 04 00 00       	jmp    102aab <__alltraps>

0010267f <vector167>:
.globl vector167
vector167:
  pushl $0
  10267f:	6a 00                	push   $0x0
  pushl $167
  102681:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102686:	e9 20 04 00 00       	jmp    102aab <__alltraps>

0010268b <vector168>:
.globl vector168
vector168:
  pushl $0
  10268b:	6a 00                	push   $0x0
  pushl $168
  10268d:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102692:	e9 14 04 00 00       	jmp    102aab <__alltraps>

00102697 <vector169>:
.globl vector169
vector169:
  pushl $0
  102697:	6a 00                	push   $0x0
  pushl $169
  102699:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10269e:	e9 08 04 00 00       	jmp    102aab <__alltraps>

001026a3 <vector170>:
.globl vector170
vector170:
  pushl $0
  1026a3:	6a 00                	push   $0x0
  pushl $170
  1026a5:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1026aa:	e9 fc 03 00 00       	jmp    102aab <__alltraps>

001026af <vector171>:
.globl vector171
vector171:
  pushl $0
  1026af:	6a 00                	push   $0x0
  pushl $171
  1026b1:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1026b6:	e9 f0 03 00 00       	jmp    102aab <__alltraps>

001026bb <vector172>:
.globl vector172
vector172:
  pushl $0
  1026bb:	6a 00                	push   $0x0
  pushl $172
  1026bd:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1026c2:	e9 e4 03 00 00       	jmp    102aab <__alltraps>

001026c7 <vector173>:
.globl vector173
vector173:
  pushl $0
  1026c7:	6a 00                	push   $0x0
  pushl $173
  1026c9:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1026ce:	e9 d8 03 00 00       	jmp    102aab <__alltraps>

001026d3 <vector174>:
.globl vector174
vector174:
  pushl $0
  1026d3:	6a 00                	push   $0x0
  pushl $174
  1026d5:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1026da:	e9 cc 03 00 00       	jmp    102aab <__alltraps>

001026df <vector175>:
.globl vector175
vector175:
  pushl $0
  1026df:	6a 00                	push   $0x0
  pushl $175
  1026e1:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1026e6:	e9 c0 03 00 00       	jmp    102aab <__alltraps>

001026eb <vector176>:
.globl vector176
vector176:
  pushl $0
  1026eb:	6a 00                	push   $0x0
  pushl $176
  1026ed:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1026f2:	e9 b4 03 00 00       	jmp    102aab <__alltraps>

001026f7 <vector177>:
.globl vector177
vector177:
  pushl $0
  1026f7:	6a 00                	push   $0x0
  pushl $177
  1026f9:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1026fe:	e9 a8 03 00 00       	jmp    102aab <__alltraps>

00102703 <vector178>:
.globl vector178
vector178:
  pushl $0
  102703:	6a 00                	push   $0x0
  pushl $178
  102705:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10270a:	e9 9c 03 00 00       	jmp    102aab <__alltraps>

0010270f <vector179>:
.globl vector179
vector179:
  pushl $0
  10270f:	6a 00                	push   $0x0
  pushl $179
  102711:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102716:	e9 90 03 00 00       	jmp    102aab <__alltraps>

0010271b <vector180>:
.globl vector180
vector180:
  pushl $0
  10271b:	6a 00                	push   $0x0
  pushl $180
  10271d:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102722:	e9 84 03 00 00       	jmp    102aab <__alltraps>

00102727 <vector181>:
.globl vector181
vector181:
  pushl $0
  102727:	6a 00                	push   $0x0
  pushl $181
  102729:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10272e:	e9 78 03 00 00       	jmp    102aab <__alltraps>

00102733 <vector182>:
.globl vector182
vector182:
  pushl $0
  102733:	6a 00                	push   $0x0
  pushl $182
  102735:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10273a:	e9 6c 03 00 00       	jmp    102aab <__alltraps>

0010273f <vector183>:
.globl vector183
vector183:
  pushl $0
  10273f:	6a 00                	push   $0x0
  pushl $183
  102741:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102746:	e9 60 03 00 00       	jmp    102aab <__alltraps>

0010274b <vector184>:
.globl vector184
vector184:
  pushl $0
  10274b:	6a 00                	push   $0x0
  pushl $184
  10274d:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102752:	e9 54 03 00 00       	jmp    102aab <__alltraps>

00102757 <vector185>:
.globl vector185
vector185:
  pushl $0
  102757:	6a 00                	push   $0x0
  pushl $185
  102759:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10275e:	e9 48 03 00 00       	jmp    102aab <__alltraps>

00102763 <vector186>:
.globl vector186
vector186:
  pushl $0
  102763:	6a 00                	push   $0x0
  pushl $186
  102765:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10276a:	e9 3c 03 00 00       	jmp    102aab <__alltraps>

0010276f <vector187>:
.globl vector187
vector187:
  pushl $0
  10276f:	6a 00                	push   $0x0
  pushl $187
  102771:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102776:	e9 30 03 00 00       	jmp    102aab <__alltraps>

0010277b <vector188>:
.globl vector188
vector188:
  pushl $0
  10277b:	6a 00                	push   $0x0
  pushl $188
  10277d:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102782:	e9 24 03 00 00       	jmp    102aab <__alltraps>

00102787 <vector189>:
.globl vector189
vector189:
  pushl $0
  102787:	6a 00                	push   $0x0
  pushl $189
  102789:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  10278e:	e9 18 03 00 00       	jmp    102aab <__alltraps>

00102793 <vector190>:
.globl vector190
vector190:
  pushl $0
  102793:	6a 00                	push   $0x0
  pushl $190
  102795:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10279a:	e9 0c 03 00 00       	jmp    102aab <__alltraps>

0010279f <vector191>:
.globl vector191
vector191:
  pushl $0
  10279f:	6a 00                	push   $0x0
  pushl $191
  1027a1:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1027a6:	e9 00 03 00 00       	jmp    102aab <__alltraps>

001027ab <vector192>:
.globl vector192
vector192:
  pushl $0
  1027ab:	6a 00                	push   $0x0
  pushl $192
  1027ad:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1027b2:	e9 f4 02 00 00       	jmp    102aab <__alltraps>

001027b7 <vector193>:
.globl vector193
vector193:
  pushl $0
  1027b7:	6a 00                	push   $0x0
  pushl $193
  1027b9:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1027be:	e9 e8 02 00 00       	jmp    102aab <__alltraps>

001027c3 <vector194>:
.globl vector194
vector194:
  pushl $0
  1027c3:	6a 00                	push   $0x0
  pushl $194
  1027c5:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1027ca:	e9 dc 02 00 00       	jmp    102aab <__alltraps>

001027cf <vector195>:
.globl vector195
vector195:
  pushl $0
  1027cf:	6a 00                	push   $0x0
  pushl $195
  1027d1:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1027d6:	e9 d0 02 00 00       	jmp    102aab <__alltraps>

001027db <vector196>:
.globl vector196
vector196:
  pushl $0
  1027db:	6a 00                	push   $0x0
  pushl $196
  1027dd:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1027e2:	e9 c4 02 00 00       	jmp    102aab <__alltraps>

001027e7 <vector197>:
.globl vector197
vector197:
  pushl $0
  1027e7:	6a 00                	push   $0x0
  pushl $197
  1027e9:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1027ee:	e9 b8 02 00 00       	jmp    102aab <__alltraps>

001027f3 <vector198>:
.globl vector198
vector198:
  pushl $0
  1027f3:	6a 00                	push   $0x0
  pushl $198
  1027f5:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1027fa:	e9 ac 02 00 00       	jmp    102aab <__alltraps>

001027ff <vector199>:
.globl vector199
vector199:
  pushl $0
  1027ff:	6a 00                	push   $0x0
  pushl $199
  102801:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102806:	e9 a0 02 00 00       	jmp    102aab <__alltraps>

0010280b <vector200>:
.globl vector200
vector200:
  pushl $0
  10280b:	6a 00                	push   $0x0
  pushl $200
  10280d:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102812:	e9 94 02 00 00       	jmp    102aab <__alltraps>

00102817 <vector201>:
.globl vector201
vector201:
  pushl $0
  102817:	6a 00                	push   $0x0
  pushl $201
  102819:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10281e:	e9 88 02 00 00       	jmp    102aab <__alltraps>

00102823 <vector202>:
.globl vector202
vector202:
  pushl $0
  102823:	6a 00                	push   $0x0
  pushl $202
  102825:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10282a:	e9 7c 02 00 00       	jmp    102aab <__alltraps>

0010282f <vector203>:
.globl vector203
vector203:
  pushl $0
  10282f:	6a 00                	push   $0x0
  pushl $203
  102831:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102836:	e9 70 02 00 00       	jmp    102aab <__alltraps>

0010283b <vector204>:
.globl vector204
vector204:
  pushl $0
  10283b:	6a 00                	push   $0x0
  pushl $204
  10283d:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102842:	e9 64 02 00 00       	jmp    102aab <__alltraps>

00102847 <vector205>:
.globl vector205
vector205:
  pushl $0
  102847:	6a 00                	push   $0x0
  pushl $205
  102849:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10284e:	e9 58 02 00 00       	jmp    102aab <__alltraps>

00102853 <vector206>:
.globl vector206
vector206:
  pushl $0
  102853:	6a 00                	push   $0x0
  pushl $206
  102855:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10285a:	e9 4c 02 00 00       	jmp    102aab <__alltraps>

0010285f <vector207>:
.globl vector207
vector207:
  pushl $0
  10285f:	6a 00                	push   $0x0
  pushl $207
  102861:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102866:	e9 40 02 00 00       	jmp    102aab <__alltraps>

0010286b <vector208>:
.globl vector208
vector208:
  pushl $0
  10286b:	6a 00                	push   $0x0
  pushl $208
  10286d:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102872:	e9 34 02 00 00       	jmp    102aab <__alltraps>

00102877 <vector209>:
.globl vector209
vector209:
  pushl $0
  102877:	6a 00                	push   $0x0
  pushl $209
  102879:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10287e:	e9 28 02 00 00       	jmp    102aab <__alltraps>

00102883 <vector210>:
.globl vector210
vector210:
  pushl $0
  102883:	6a 00                	push   $0x0
  pushl $210
  102885:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10288a:	e9 1c 02 00 00       	jmp    102aab <__alltraps>

0010288f <vector211>:
.globl vector211
vector211:
  pushl $0
  10288f:	6a 00                	push   $0x0
  pushl $211
  102891:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102896:	e9 10 02 00 00       	jmp    102aab <__alltraps>

0010289b <vector212>:
.globl vector212
vector212:
  pushl $0
  10289b:	6a 00                	push   $0x0
  pushl $212
  10289d:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1028a2:	e9 04 02 00 00       	jmp    102aab <__alltraps>

001028a7 <vector213>:
.globl vector213
vector213:
  pushl $0
  1028a7:	6a 00                	push   $0x0
  pushl $213
  1028a9:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1028ae:	e9 f8 01 00 00       	jmp    102aab <__alltraps>

001028b3 <vector214>:
.globl vector214
vector214:
  pushl $0
  1028b3:	6a 00                	push   $0x0
  pushl $214
  1028b5:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1028ba:	e9 ec 01 00 00       	jmp    102aab <__alltraps>

001028bf <vector215>:
.globl vector215
vector215:
  pushl $0
  1028bf:	6a 00                	push   $0x0
  pushl $215
  1028c1:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1028c6:	e9 e0 01 00 00       	jmp    102aab <__alltraps>

001028cb <vector216>:
.globl vector216
vector216:
  pushl $0
  1028cb:	6a 00                	push   $0x0
  pushl $216
  1028cd:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1028d2:	e9 d4 01 00 00       	jmp    102aab <__alltraps>

001028d7 <vector217>:
.globl vector217
vector217:
  pushl $0
  1028d7:	6a 00                	push   $0x0
  pushl $217
  1028d9:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1028de:	e9 c8 01 00 00       	jmp    102aab <__alltraps>

001028e3 <vector218>:
.globl vector218
vector218:
  pushl $0
  1028e3:	6a 00                	push   $0x0
  pushl $218
  1028e5:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1028ea:	e9 bc 01 00 00       	jmp    102aab <__alltraps>

001028ef <vector219>:
.globl vector219
vector219:
  pushl $0
  1028ef:	6a 00                	push   $0x0
  pushl $219
  1028f1:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1028f6:	e9 b0 01 00 00       	jmp    102aab <__alltraps>

001028fb <vector220>:
.globl vector220
vector220:
  pushl $0
  1028fb:	6a 00                	push   $0x0
  pushl $220
  1028fd:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102902:	e9 a4 01 00 00       	jmp    102aab <__alltraps>

00102907 <vector221>:
.globl vector221
vector221:
  pushl $0
  102907:	6a 00                	push   $0x0
  pushl $221
  102909:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10290e:	e9 98 01 00 00       	jmp    102aab <__alltraps>

00102913 <vector222>:
.globl vector222
vector222:
  pushl $0
  102913:	6a 00                	push   $0x0
  pushl $222
  102915:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10291a:	e9 8c 01 00 00       	jmp    102aab <__alltraps>

0010291f <vector223>:
.globl vector223
vector223:
  pushl $0
  10291f:	6a 00                	push   $0x0
  pushl $223
  102921:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102926:	e9 80 01 00 00       	jmp    102aab <__alltraps>

0010292b <vector224>:
.globl vector224
vector224:
  pushl $0
  10292b:	6a 00                	push   $0x0
  pushl $224
  10292d:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102932:	e9 74 01 00 00       	jmp    102aab <__alltraps>

00102937 <vector225>:
.globl vector225
vector225:
  pushl $0
  102937:	6a 00                	push   $0x0
  pushl $225
  102939:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10293e:	e9 68 01 00 00       	jmp    102aab <__alltraps>

00102943 <vector226>:
.globl vector226
vector226:
  pushl $0
  102943:	6a 00                	push   $0x0
  pushl $226
  102945:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  10294a:	e9 5c 01 00 00       	jmp    102aab <__alltraps>

0010294f <vector227>:
.globl vector227
vector227:
  pushl $0
  10294f:	6a 00                	push   $0x0
  pushl $227
  102951:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102956:	e9 50 01 00 00       	jmp    102aab <__alltraps>

0010295b <vector228>:
.globl vector228
vector228:
  pushl $0
  10295b:	6a 00                	push   $0x0
  pushl $228
  10295d:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102962:	e9 44 01 00 00       	jmp    102aab <__alltraps>

00102967 <vector229>:
.globl vector229
vector229:
  pushl $0
  102967:	6a 00                	push   $0x0
  pushl $229
  102969:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10296e:	e9 38 01 00 00       	jmp    102aab <__alltraps>

00102973 <vector230>:
.globl vector230
vector230:
  pushl $0
  102973:	6a 00                	push   $0x0
  pushl $230
  102975:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10297a:	e9 2c 01 00 00       	jmp    102aab <__alltraps>

0010297f <vector231>:
.globl vector231
vector231:
  pushl $0
  10297f:	6a 00                	push   $0x0
  pushl $231
  102981:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102986:	e9 20 01 00 00       	jmp    102aab <__alltraps>

0010298b <vector232>:
.globl vector232
vector232:
  pushl $0
  10298b:	6a 00                	push   $0x0
  pushl $232
  10298d:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102992:	e9 14 01 00 00       	jmp    102aab <__alltraps>

00102997 <vector233>:
.globl vector233
vector233:
  pushl $0
  102997:	6a 00                	push   $0x0
  pushl $233
  102999:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  10299e:	e9 08 01 00 00       	jmp    102aab <__alltraps>

001029a3 <vector234>:
.globl vector234
vector234:
  pushl $0
  1029a3:	6a 00                	push   $0x0
  pushl $234
  1029a5:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1029aa:	e9 fc 00 00 00       	jmp    102aab <__alltraps>

001029af <vector235>:
.globl vector235
vector235:
  pushl $0
  1029af:	6a 00                	push   $0x0
  pushl $235
  1029b1:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1029b6:	e9 f0 00 00 00       	jmp    102aab <__alltraps>

001029bb <vector236>:
.globl vector236
vector236:
  pushl $0
  1029bb:	6a 00                	push   $0x0
  pushl $236
  1029bd:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1029c2:	e9 e4 00 00 00       	jmp    102aab <__alltraps>

001029c7 <vector237>:
.globl vector237
vector237:
  pushl $0
  1029c7:	6a 00                	push   $0x0
  pushl $237
  1029c9:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1029ce:	e9 d8 00 00 00       	jmp    102aab <__alltraps>

001029d3 <vector238>:
.globl vector238
vector238:
  pushl $0
  1029d3:	6a 00                	push   $0x0
  pushl $238
  1029d5:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1029da:	e9 cc 00 00 00       	jmp    102aab <__alltraps>

001029df <vector239>:
.globl vector239
vector239:
  pushl $0
  1029df:	6a 00                	push   $0x0
  pushl $239
  1029e1:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1029e6:	e9 c0 00 00 00       	jmp    102aab <__alltraps>

001029eb <vector240>:
.globl vector240
vector240:
  pushl $0
  1029eb:	6a 00                	push   $0x0
  pushl $240
  1029ed:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1029f2:	e9 b4 00 00 00       	jmp    102aab <__alltraps>

001029f7 <vector241>:
.globl vector241
vector241:
  pushl $0
  1029f7:	6a 00                	push   $0x0
  pushl $241
  1029f9:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1029fe:	e9 a8 00 00 00       	jmp    102aab <__alltraps>

00102a03 <vector242>:
.globl vector242
vector242:
  pushl $0
  102a03:	6a 00                	push   $0x0
  pushl $242
  102a05:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102a0a:	e9 9c 00 00 00       	jmp    102aab <__alltraps>

00102a0f <vector243>:
.globl vector243
vector243:
  pushl $0
  102a0f:	6a 00                	push   $0x0
  pushl $243
  102a11:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102a16:	e9 90 00 00 00       	jmp    102aab <__alltraps>

00102a1b <vector244>:
.globl vector244
vector244:
  pushl $0
  102a1b:	6a 00                	push   $0x0
  pushl $244
  102a1d:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102a22:	e9 84 00 00 00       	jmp    102aab <__alltraps>

00102a27 <vector245>:
.globl vector245
vector245:
  pushl $0
  102a27:	6a 00                	push   $0x0
  pushl $245
  102a29:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102a2e:	e9 78 00 00 00       	jmp    102aab <__alltraps>

00102a33 <vector246>:
.globl vector246
vector246:
  pushl $0
  102a33:	6a 00                	push   $0x0
  pushl $246
  102a35:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102a3a:	e9 6c 00 00 00       	jmp    102aab <__alltraps>

00102a3f <vector247>:
.globl vector247
vector247:
  pushl $0
  102a3f:	6a 00                	push   $0x0
  pushl $247
  102a41:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102a46:	e9 60 00 00 00       	jmp    102aab <__alltraps>

00102a4b <vector248>:
.globl vector248
vector248:
  pushl $0
  102a4b:	6a 00                	push   $0x0
  pushl $248
  102a4d:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102a52:	e9 54 00 00 00       	jmp    102aab <__alltraps>

00102a57 <vector249>:
.globl vector249
vector249:
  pushl $0
  102a57:	6a 00                	push   $0x0
  pushl $249
  102a59:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102a5e:	e9 48 00 00 00       	jmp    102aab <__alltraps>

00102a63 <vector250>:
.globl vector250
vector250:
  pushl $0
  102a63:	6a 00                	push   $0x0
  pushl $250
  102a65:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102a6a:	e9 3c 00 00 00       	jmp    102aab <__alltraps>

00102a6f <vector251>:
.globl vector251
vector251:
  pushl $0
  102a6f:	6a 00                	push   $0x0
  pushl $251
  102a71:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102a76:	e9 30 00 00 00       	jmp    102aab <__alltraps>

00102a7b <vector252>:
.globl vector252
vector252:
  pushl $0
  102a7b:	6a 00                	push   $0x0
  pushl $252
  102a7d:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102a82:	e9 24 00 00 00       	jmp    102aab <__alltraps>

00102a87 <vector253>:
.globl vector253
vector253:
  pushl $0
  102a87:	6a 00                	push   $0x0
  pushl $253
  102a89:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102a8e:	e9 18 00 00 00       	jmp    102aab <__alltraps>

00102a93 <vector254>:
.globl vector254
vector254:
  pushl $0
  102a93:	6a 00                	push   $0x0
  pushl $254
  102a95:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102a9a:	e9 0c 00 00 00       	jmp    102aab <__alltraps>

00102a9f <vector255>:
.globl vector255
vector255:
  pushl $0
  102a9f:	6a 00                	push   $0x0
  pushl $255
  102aa1:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102aa6:	e9 00 00 00 00       	jmp    102aab <__alltraps>

00102aab <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102aab:	1e                   	push   %ds
    pushl %es
  102aac:	06                   	push   %es
    pushl %fs
  102aad:	0f a0                	push   %fs
    pushl %gs
  102aaf:	0f a8                	push   %gs
    pushal
  102ab1:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102ab2:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102ab7:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102ab9:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102abb:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102abc:	e8 62 f5 ff ff       	call   102023 <trap>

    # pop the pushed stack pointer
    popl %esp
  102ac1:	5c                   	pop    %esp

00102ac2 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102ac2:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102ac3:	0f a9                	pop    %gs
    popl %fs
  102ac5:	0f a1                	pop    %fs
    popl %es
  102ac7:	07                   	pop    %es
    popl %ds
  102ac8:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102ac9:	83 c4 08             	add    $0x8,%esp
    iret
  102acc:	cf                   	iret   

00102acd <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102acd:	55                   	push   %ebp
  102ace:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ad3:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102ad6:	b8 23 00 00 00       	mov    $0x23,%eax
  102adb:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102add:	b8 23 00 00 00       	mov    $0x23,%eax
  102ae2:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102ae4:	b8 10 00 00 00       	mov    $0x10,%eax
  102ae9:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102aeb:	b8 10 00 00 00       	mov    $0x10,%eax
  102af0:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102af2:	b8 10 00 00 00       	mov    $0x10,%eax
  102af7:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102af9:	ea 00 2b 10 00 08 00 	ljmp   $0x8,$0x102b00
}
  102b00:	90                   	nop
  102b01:	5d                   	pop    %ebp
  102b02:	c3                   	ret    

00102b03 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102b03:	f3 0f 1e fb          	endbr32 
  102b07:	55                   	push   %ebp
  102b08:	89 e5                	mov    %esp,%ebp
  102b0a:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102b0d:	b8 80 19 11 00       	mov    $0x111980,%eax
  102b12:	05 00 04 00 00       	add    $0x400,%eax
  102b17:	a3 a4 18 11 00       	mov    %eax,0x1118a4
    ts.ts_ss0 = KERNEL_DS;
  102b1c:	66 c7 05 a8 18 11 00 	movw   $0x10,0x1118a8
  102b23:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102b25:	66 c7 05 08 0a 11 00 	movw   $0x68,0x110a08
  102b2c:	68 00 
  102b2e:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102b33:	0f b7 c0             	movzwl %ax,%eax
  102b36:	66 a3 0a 0a 11 00    	mov    %ax,0x110a0a
  102b3c:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102b41:	c1 e8 10             	shr    $0x10,%eax
  102b44:	a2 0c 0a 11 00       	mov    %al,0x110a0c
  102b49:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102b50:	24 f0                	and    $0xf0,%al
  102b52:	0c 09                	or     $0x9,%al
  102b54:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102b59:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102b60:	0c 10                	or     $0x10,%al
  102b62:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102b67:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102b6e:	24 9f                	and    $0x9f,%al
  102b70:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102b75:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102b7c:	0c 80                	or     $0x80,%al
  102b7e:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102b83:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102b8a:	24 f0                	and    $0xf0,%al
  102b8c:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102b91:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102b98:	24 ef                	and    $0xef,%al
  102b9a:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102b9f:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102ba6:	24 df                	and    $0xdf,%al
  102ba8:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102bad:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102bb4:	0c 40                	or     $0x40,%al
  102bb6:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102bbb:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102bc2:	24 7f                	and    $0x7f,%al
  102bc4:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102bc9:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102bce:	c1 e8 18             	shr    $0x18,%eax
  102bd1:	a2 0f 0a 11 00       	mov    %al,0x110a0f
    gdt[SEG_TSS].sd_s = 0;
  102bd6:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102bdd:	24 ef                	and    $0xef,%al
  102bdf:	a2 0d 0a 11 00       	mov    %al,0x110a0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102be4:	c7 04 24 10 0a 11 00 	movl   $0x110a10,(%esp)
  102beb:	e8 dd fe ff ff       	call   102acd <lgdt>
  102bf0:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102bf6:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102bfa:	0f 00 d8             	ltr    %ax
}
  102bfd:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  102bfe:	90                   	nop
  102bff:	c9                   	leave  
  102c00:	c3                   	ret    

00102c01 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102c01:	f3 0f 1e fb          	endbr32 
  102c05:	55                   	push   %ebp
  102c06:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102c08:	e8 f6 fe ff ff       	call   102b03 <gdt_init>
}
  102c0d:	90                   	nop
  102c0e:	5d                   	pop    %ebp
  102c0f:	c3                   	ret    

00102c10 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102c10:	f3 0f 1e fb          	endbr32 
  102c14:	55                   	push   %ebp
  102c15:	89 e5                	mov    %esp,%ebp
  102c17:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102c1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102c21:	eb 03                	jmp    102c26 <strlen+0x16>
        cnt ++;
  102c23:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  102c26:	8b 45 08             	mov    0x8(%ebp),%eax
  102c29:	8d 50 01             	lea    0x1(%eax),%edx
  102c2c:	89 55 08             	mov    %edx,0x8(%ebp)
  102c2f:	0f b6 00             	movzbl (%eax),%eax
  102c32:	84 c0                	test   %al,%al
  102c34:	75 ed                	jne    102c23 <strlen+0x13>
    }
    return cnt;
  102c36:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102c39:	c9                   	leave  
  102c3a:	c3                   	ret    

00102c3b <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102c3b:	f3 0f 1e fb          	endbr32 
  102c3f:	55                   	push   %ebp
  102c40:	89 e5                	mov    %esp,%ebp
  102c42:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102c45:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102c4c:	eb 03                	jmp    102c51 <strnlen+0x16>
        cnt ++;
  102c4e:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102c51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102c54:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102c57:	73 10                	jae    102c69 <strnlen+0x2e>
  102c59:	8b 45 08             	mov    0x8(%ebp),%eax
  102c5c:	8d 50 01             	lea    0x1(%eax),%edx
  102c5f:	89 55 08             	mov    %edx,0x8(%ebp)
  102c62:	0f b6 00             	movzbl (%eax),%eax
  102c65:	84 c0                	test   %al,%al
  102c67:	75 e5                	jne    102c4e <strnlen+0x13>
    }
    return cnt;
  102c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102c6c:	c9                   	leave  
  102c6d:	c3                   	ret    

00102c6e <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102c6e:	f3 0f 1e fb          	endbr32 
  102c72:	55                   	push   %ebp
  102c73:	89 e5                	mov    %esp,%ebp
  102c75:	57                   	push   %edi
  102c76:	56                   	push   %esi
  102c77:	83 ec 20             	sub    $0x20,%esp
  102c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  102c7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c80:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c83:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102c86:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c8c:	89 d1                	mov    %edx,%ecx
  102c8e:	89 c2                	mov    %eax,%edx
  102c90:	89 ce                	mov    %ecx,%esi
  102c92:	89 d7                	mov    %edx,%edi
  102c94:	ac                   	lods   %ds:(%esi),%al
  102c95:	aa                   	stos   %al,%es:(%edi)
  102c96:	84 c0                	test   %al,%al
  102c98:	75 fa                	jne    102c94 <strcpy+0x26>
  102c9a:	89 fa                	mov    %edi,%edx
  102c9c:	89 f1                	mov    %esi,%ecx
  102c9e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102ca1:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102ca4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102caa:	83 c4 20             	add    $0x20,%esp
  102cad:	5e                   	pop    %esi
  102cae:	5f                   	pop    %edi
  102caf:	5d                   	pop    %ebp
  102cb0:	c3                   	ret    

00102cb1 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102cb1:	f3 0f 1e fb          	endbr32 
  102cb5:	55                   	push   %ebp
  102cb6:	89 e5                	mov    %esp,%ebp
  102cb8:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  102cbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102cc1:	eb 1e                	jmp    102ce1 <strncpy+0x30>
        if ((*p = *src) != '\0') {
  102cc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cc6:	0f b6 10             	movzbl (%eax),%edx
  102cc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102ccc:	88 10                	mov    %dl,(%eax)
  102cce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102cd1:	0f b6 00             	movzbl (%eax),%eax
  102cd4:	84 c0                	test   %al,%al
  102cd6:	74 03                	je     102cdb <strncpy+0x2a>
            src ++;
  102cd8:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  102cdb:	ff 45 fc             	incl   -0x4(%ebp)
  102cde:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  102ce1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102ce5:	75 dc                	jne    102cc3 <strncpy+0x12>
    }
    return dst;
  102ce7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102cea:	c9                   	leave  
  102ceb:	c3                   	ret    

00102cec <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102cec:	f3 0f 1e fb          	endbr32 
  102cf0:	55                   	push   %ebp
  102cf1:	89 e5                	mov    %esp,%ebp
  102cf3:	57                   	push   %edi
  102cf4:	56                   	push   %esi
  102cf5:	83 ec 20             	sub    $0x20,%esp
  102cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  102cfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d01:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  102d04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d0a:	89 d1                	mov    %edx,%ecx
  102d0c:	89 c2                	mov    %eax,%edx
  102d0e:	89 ce                	mov    %ecx,%esi
  102d10:	89 d7                	mov    %edx,%edi
  102d12:	ac                   	lods   %ds:(%esi),%al
  102d13:	ae                   	scas   %es:(%edi),%al
  102d14:	75 08                	jne    102d1e <strcmp+0x32>
  102d16:	84 c0                	test   %al,%al
  102d18:	75 f8                	jne    102d12 <strcmp+0x26>
  102d1a:	31 c0                	xor    %eax,%eax
  102d1c:	eb 04                	jmp    102d22 <strcmp+0x36>
  102d1e:	19 c0                	sbb    %eax,%eax
  102d20:	0c 01                	or     $0x1,%al
  102d22:	89 fa                	mov    %edi,%edx
  102d24:	89 f1                	mov    %esi,%ecx
  102d26:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102d29:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102d2c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102d2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102d32:	83 c4 20             	add    $0x20,%esp
  102d35:	5e                   	pop    %esi
  102d36:	5f                   	pop    %edi
  102d37:	5d                   	pop    %ebp
  102d38:	c3                   	ret    

00102d39 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102d39:	f3 0f 1e fb          	endbr32 
  102d3d:	55                   	push   %ebp
  102d3e:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102d40:	eb 09                	jmp    102d4b <strncmp+0x12>
        n --, s1 ++, s2 ++;
  102d42:	ff 4d 10             	decl   0x10(%ebp)
  102d45:	ff 45 08             	incl   0x8(%ebp)
  102d48:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102d4b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d4f:	74 1a                	je     102d6b <strncmp+0x32>
  102d51:	8b 45 08             	mov    0x8(%ebp),%eax
  102d54:	0f b6 00             	movzbl (%eax),%eax
  102d57:	84 c0                	test   %al,%al
  102d59:	74 10                	je     102d6b <strncmp+0x32>
  102d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  102d5e:	0f b6 10             	movzbl (%eax),%edx
  102d61:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d64:	0f b6 00             	movzbl (%eax),%eax
  102d67:	38 c2                	cmp    %al,%dl
  102d69:	74 d7                	je     102d42 <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102d6b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d6f:	74 18                	je     102d89 <strncmp+0x50>
  102d71:	8b 45 08             	mov    0x8(%ebp),%eax
  102d74:	0f b6 00             	movzbl (%eax),%eax
  102d77:	0f b6 d0             	movzbl %al,%edx
  102d7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d7d:	0f b6 00             	movzbl (%eax),%eax
  102d80:	0f b6 c0             	movzbl %al,%eax
  102d83:	29 c2                	sub    %eax,%edx
  102d85:	89 d0                	mov    %edx,%eax
  102d87:	eb 05                	jmp    102d8e <strncmp+0x55>
  102d89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102d8e:	5d                   	pop    %ebp
  102d8f:	c3                   	ret    

00102d90 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102d90:	f3 0f 1e fb          	endbr32 
  102d94:	55                   	push   %ebp
  102d95:	89 e5                	mov    %esp,%ebp
  102d97:	83 ec 04             	sub    $0x4,%esp
  102d9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d9d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102da0:	eb 13                	jmp    102db5 <strchr+0x25>
        if (*s == c) {
  102da2:	8b 45 08             	mov    0x8(%ebp),%eax
  102da5:	0f b6 00             	movzbl (%eax),%eax
  102da8:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102dab:	75 05                	jne    102db2 <strchr+0x22>
            return (char *)s;
  102dad:	8b 45 08             	mov    0x8(%ebp),%eax
  102db0:	eb 12                	jmp    102dc4 <strchr+0x34>
        }
        s ++;
  102db2:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102db5:	8b 45 08             	mov    0x8(%ebp),%eax
  102db8:	0f b6 00             	movzbl (%eax),%eax
  102dbb:	84 c0                	test   %al,%al
  102dbd:	75 e3                	jne    102da2 <strchr+0x12>
    }
    return NULL;
  102dbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102dc4:	c9                   	leave  
  102dc5:	c3                   	ret    

00102dc6 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102dc6:	f3 0f 1e fb          	endbr32 
  102dca:	55                   	push   %ebp
  102dcb:	89 e5                	mov    %esp,%ebp
  102dcd:	83 ec 04             	sub    $0x4,%esp
  102dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dd3:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102dd6:	eb 0e                	jmp    102de6 <strfind+0x20>
        if (*s == c) {
  102dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  102ddb:	0f b6 00             	movzbl (%eax),%eax
  102dde:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102de1:	74 0f                	je     102df2 <strfind+0x2c>
            break;
        }
        s ++;
  102de3:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102de6:	8b 45 08             	mov    0x8(%ebp),%eax
  102de9:	0f b6 00             	movzbl (%eax),%eax
  102dec:	84 c0                	test   %al,%al
  102dee:	75 e8                	jne    102dd8 <strfind+0x12>
  102df0:	eb 01                	jmp    102df3 <strfind+0x2d>
            break;
  102df2:	90                   	nop
    }
    return (char *)s;
  102df3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102df6:	c9                   	leave  
  102df7:	c3                   	ret    

00102df8 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102df8:	f3 0f 1e fb          	endbr32 
  102dfc:	55                   	push   %ebp
  102dfd:	89 e5                	mov    %esp,%ebp
  102dff:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102e02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102e09:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102e10:	eb 03                	jmp    102e15 <strtol+0x1d>
        s ++;
  102e12:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102e15:	8b 45 08             	mov    0x8(%ebp),%eax
  102e18:	0f b6 00             	movzbl (%eax),%eax
  102e1b:	3c 20                	cmp    $0x20,%al
  102e1d:	74 f3                	je     102e12 <strtol+0x1a>
  102e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  102e22:	0f b6 00             	movzbl (%eax),%eax
  102e25:	3c 09                	cmp    $0x9,%al
  102e27:	74 e9                	je     102e12 <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
  102e29:	8b 45 08             	mov    0x8(%ebp),%eax
  102e2c:	0f b6 00             	movzbl (%eax),%eax
  102e2f:	3c 2b                	cmp    $0x2b,%al
  102e31:	75 05                	jne    102e38 <strtol+0x40>
        s ++;
  102e33:	ff 45 08             	incl   0x8(%ebp)
  102e36:	eb 14                	jmp    102e4c <strtol+0x54>
    }
    else if (*s == '-') {
  102e38:	8b 45 08             	mov    0x8(%ebp),%eax
  102e3b:	0f b6 00             	movzbl (%eax),%eax
  102e3e:	3c 2d                	cmp    $0x2d,%al
  102e40:	75 0a                	jne    102e4c <strtol+0x54>
        s ++, neg = 1;
  102e42:	ff 45 08             	incl   0x8(%ebp)
  102e45:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102e4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e50:	74 06                	je     102e58 <strtol+0x60>
  102e52:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102e56:	75 22                	jne    102e7a <strtol+0x82>
  102e58:	8b 45 08             	mov    0x8(%ebp),%eax
  102e5b:	0f b6 00             	movzbl (%eax),%eax
  102e5e:	3c 30                	cmp    $0x30,%al
  102e60:	75 18                	jne    102e7a <strtol+0x82>
  102e62:	8b 45 08             	mov    0x8(%ebp),%eax
  102e65:	40                   	inc    %eax
  102e66:	0f b6 00             	movzbl (%eax),%eax
  102e69:	3c 78                	cmp    $0x78,%al
  102e6b:	75 0d                	jne    102e7a <strtol+0x82>
        s += 2, base = 16;
  102e6d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102e71:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102e78:	eb 29                	jmp    102ea3 <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
  102e7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e7e:	75 16                	jne    102e96 <strtol+0x9e>
  102e80:	8b 45 08             	mov    0x8(%ebp),%eax
  102e83:	0f b6 00             	movzbl (%eax),%eax
  102e86:	3c 30                	cmp    $0x30,%al
  102e88:	75 0c                	jne    102e96 <strtol+0x9e>
        s ++, base = 8;
  102e8a:	ff 45 08             	incl   0x8(%ebp)
  102e8d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102e94:	eb 0d                	jmp    102ea3 <strtol+0xab>
    }
    else if (base == 0) {
  102e96:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e9a:	75 07                	jne    102ea3 <strtol+0xab>
        base = 10;
  102e9c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ea6:	0f b6 00             	movzbl (%eax),%eax
  102ea9:	3c 2f                	cmp    $0x2f,%al
  102eab:	7e 1b                	jle    102ec8 <strtol+0xd0>
  102ead:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb0:	0f b6 00             	movzbl (%eax),%eax
  102eb3:	3c 39                	cmp    $0x39,%al
  102eb5:	7f 11                	jg     102ec8 <strtol+0xd0>
            dig = *s - '0';
  102eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  102eba:	0f b6 00             	movzbl (%eax),%eax
  102ebd:	0f be c0             	movsbl %al,%eax
  102ec0:	83 e8 30             	sub    $0x30,%eax
  102ec3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ec6:	eb 48                	jmp    102f10 <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  102ecb:	0f b6 00             	movzbl (%eax),%eax
  102ece:	3c 60                	cmp    $0x60,%al
  102ed0:	7e 1b                	jle    102eed <strtol+0xf5>
  102ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  102ed5:	0f b6 00             	movzbl (%eax),%eax
  102ed8:	3c 7a                	cmp    $0x7a,%al
  102eda:	7f 11                	jg     102eed <strtol+0xf5>
            dig = *s - 'a' + 10;
  102edc:	8b 45 08             	mov    0x8(%ebp),%eax
  102edf:	0f b6 00             	movzbl (%eax),%eax
  102ee2:	0f be c0             	movsbl %al,%eax
  102ee5:	83 e8 57             	sub    $0x57,%eax
  102ee8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102eeb:	eb 23                	jmp    102f10 <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102eed:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef0:	0f b6 00             	movzbl (%eax),%eax
  102ef3:	3c 40                	cmp    $0x40,%al
  102ef5:	7e 3b                	jle    102f32 <strtol+0x13a>
  102ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  102efa:	0f b6 00             	movzbl (%eax),%eax
  102efd:	3c 5a                	cmp    $0x5a,%al
  102eff:	7f 31                	jg     102f32 <strtol+0x13a>
            dig = *s - 'A' + 10;
  102f01:	8b 45 08             	mov    0x8(%ebp),%eax
  102f04:	0f b6 00             	movzbl (%eax),%eax
  102f07:	0f be c0             	movsbl %al,%eax
  102f0a:	83 e8 37             	sub    $0x37,%eax
  102f0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f13:	3b 45 10             	cmp    0x10(%ebp),%eax
  102f16:	7d 19                	jge    102f31 <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
  102f18:	ff 45 08             	incl   0x8(%ebp)
  102f1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f1e:	0f af 45 10          	imul   0x10(%ebp),%eax
  102f22:	89 c2                	mov    %eax,%edx
  102f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f27:	01 d0                	add    %edx,%eax
  102f29:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  102f2c:	e9 72 ff ff ff       	jmp    102ea3 <strtol+0xab>
            break;
  102f31:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  102f32:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102f36:	74 08                	je     102f40 <strtol+0x148>
        *endptr = (char *) s;
  102f38:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f3b:	8b 55 08             	mov    0x8(%ebp),%edx
  102f3e:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102f40:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102f44:	74 07                	je     102f4d <strtol+0x155>
  102f46:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f49:	f7 d8                	neg    %eax
  102f4b:	eb 03                	jmp    102f50 <strtol+0x158>
  102f4d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102f50:	c9                   	leave  
  102f51:	c3                   	ret    

00102f52 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102f52:	f3 0f 1e fb          	endbr32 
  102f56:	55                   	push   %ebp
  102f57:	89 e5                	mov    %esp,%ebp
  102f59:	57                   	push   %edi
  102f5a:	83 ec 24             	sub    $0x24,%esp
  102f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f60:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102f63:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  102f67:	8b 45 08             	mov    0x8(%ebp),%eax
  102f6a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  102f6d:	88 55 f7             	mov    %dl,-0x9(%ebp)
  102f70:	8b 45 10             	mov    0x10(%ebp),%eax
  102f73:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102f76:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102f79:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102f7d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102f80:	89 d7                	mov    %edx,%edi
  102f82:	f3 aa                	rep stos %al,%es:(%edi)
  102f84:	89 fa                	mov    %edi,%edx
  102f86:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102f89:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102f8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102f8f:	83 c4 24             	add    $0x24,%esp
  102f92:	5f                   	pop    %edi
  102f93:	5d                   	pop    %ebp
  102f94:	c3                   	ret    

00102f95 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102f95:	f3 0f 1e fb          	endbr32 
  102f99:	55                   	push   %ebp
  102f9a:	89 e5                	mov    %esp,%ebp
  102f9c:	57                   	push   %edi
  102f9d:	56                   	push   %esi
  102f9e:	53                   	push   %ebx
  102f9f:	83 ec 30             	sub    $0x30,%esp
  102fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  102fa5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102fae:	8b 45 10             	mov    0x10(%ebp),%eax
  102fb1:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fb7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102fba:	73 42                	jae    102ffe <memmove+0x69>
  102fbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fbf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102fc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fc5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102fc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102fcb:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102fce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102fd1:	c1 e8 02             	shr    $0x2,%eax
  102fd4:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102fd6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102fd9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fdc:	89 d7                	mov    %edx,%edi
  102fde:	89 c6                	mov    %eax,%esi
  102fe0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102fe2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102fe5:	83 e1 03             	and    $0x3,%ecx
  102fe8:	74 02                	je     102fec <memmove+0x57>
  102fea:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102fec:	89 f0                	mov    %esi,%eax
  102fee:	89 fa                	mov    %edi,%edx
  102ff0:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102ff3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102ff6:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  102ff9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  102ffc:	eb 36                	jmp    103034 <memmove+0x9f>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102ffe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103001:	8d 50 ff             	lea    -0x1(%eax),%edx
  103004:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103007:	01 c2                	add    %eax,%edx
  103009:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10300c:	8d 48 ff             	lea    -0x1(%eax),%ecx
  10300f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103012:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  103015:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103018:	89 c1                	mov    %eax,%ecx
  10301a:	89 d8                	mov    %ebx,%eax
  10301c:	89 d6                	mov    %edx,%esi
  10301e:	89 c7                	mov    %eax,%edi
  103020:	fd                   	std    
  103021:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103023:	fc                   	cld    
  103024:	89 f8                	mov    %edi,%eax
  103026:	89 f2                	mov    %esi,%edx
  103028:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  10302b:	89 55 c8             	mov    %edx,-0x38(%ebp)
  10302e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  103031:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  103034:	83 c4 30             	add    $0x30,%esp
  103037:	5b                   	pop    %ebx
  103038:	5e                   	pop    %esi
  103039:	5f                   	pop    %edi
  10303a:	5d                   	pop    %ebp
  10303b:	c3                   	ret    

0010303c <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  10303c:	f3 0f 1e fb          	endbr32 
  103040:	55                   	push   %ebp
  103041:	89 e5                	mov    %esp,%ebp
  103043:	57                   	push   %edi
  103044:	56                   	push   %esi
  103045:	83 ec 20             	sub    $0x20,%esp
  103048:	8b 45 08             	mov    0x8(%ebp),%eax
  10304b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10304e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103051:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103054:	8b 45 10             	mov    0x10(%ebp),%eax
  103057:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10305a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10305d:	c1 e8 02             	shr    $0x2,%eax
  103060:	89 c1                	mov    %eax,%ecx
    asm volatile (
  103062:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103065:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103068:	89 d7                	mov    %edx,%edi
  10306a:	89 c6                	mov    %eax,%esi
  10306c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10306e:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  103071:	83 e1 03             	and    $0x3,%ecx
  103074:	74 02                	je     103078 <memcpy+0x3c>
  103076:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103078:	89 f0                	mov    %esi,%eax
  10307a:	89 fa                	mov    %edi,%edx
  10307c:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10307f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  103082:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  103085:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103088:	83 c4 20             	add    $0x20,%esp
  10308b:	5e                   	pop    %esi
  10308c:	5f                   	pop    %edi
  10308d:	5d                   	pop    %ebp
  10308e:	c3                   	ret    

0010308f <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  10308f:	f3 0f 1e fb          	endbr32 
  103093:	55                   	push   %ebp
  103094:	89 e5                	mov    %esp,%ebp
  103096:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  103099:	8b 45 08             	mov    0x8(%ebp),%eax
  10309c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  10309f:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030a2:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1030a5:	eb 2e                	jmp    1030d5 <memcmp+0x46>
        if (*s1 != *s2) {
  1030a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1030aa:	0f b6 10             	movzbl (%eax),%edx
  1030ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1030b0:	0f b6 00             	movzbl (%eax),%eax
  1030b3:	38 c2                	cmp    %al,%dl
  1030b5:	74 18                	je     1030cf <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1030b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1030ba:	0f b6 00             	movzbl (%eax),%eax
  1030bd:	0f b6 d0             	movzbl %al,%edx
  1030c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1030c3:	0f b6 00             	movzbl (%eax),%eax
  1030c6:	0f b6 c0             	movzbl %al,%eax
  1030c9:	29 c2                	sub    %eax,%edx
  1030cb:	89 d0                	mov    %edx,%eax
  1030cd:	eb 18                	jmp    1030e7 <memcmp+0x58>
        }
        s1 ++, s2 ++;
  1030cf:	ff 45 fc             	incl   -0x4(%ebp)
  1030d2:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  1030d5:	8b 45 10             	mov    0x10(%ebp),%eax
  1030d8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1030db:	89 55 10             	mov    %edx,0x10(%ebp)
  1030de:	85 c0                	test   %eax,%eax
  1030e0:	75 c5                	jne    1030a7 <memcmp+0x18>
    }
    return 0;
  1030e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1030e7:	c9                   	leave  
  1030e8:	c3                   	ret    

001030e9 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1030e9:	f3 0f 1e fb          	endbr32 
  1030ed:	55                   	push   %ebp
  1030ee:	89 e5                	mov    %esp,%ebp
  1030f0:	83 ec 58             	sub    $0x58,%esp
  1030f3:	8b 45 10             	mov    0x10(%ebp),%eax
  1030f6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1030f9:	8b 45 14             	mov    0x14(%ebp),%eax
  1030fc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1030ff:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103102:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103105:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103108:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  10310b:	8b 45 18             	mov    0x18(%ebp),%eax
  10310e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103111:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103114:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103117:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10311a:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10311d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103120:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103123:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103127:	74 1c                	je     103145 <printnum+0x5c>
  103129:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10312c:	ba 00 00 00 00       	mov    $0x0,%edx
  103131:	f7 75 e4             	divl   -0x1c(%ebp)
  103134:	89 55 f4             	mov    %edx,-0xc(%ebp)
  103137:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10313a:	ba 00 00 00 00       	mov    $0x0,%edx
  10313f:	f7 75 e4             	divl   -0x1c(%ebp)
  103142:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103145:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103148:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10314b:	f7 75 e4             	divl   -0x1c(%ebp)
  10314e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103151:	89 55 dc             	mov    %edx,-0x24(%ebp)
  103154:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103157:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10315a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10315d:	89 55 ec             	mov    %edx,-0x14(%ebp)
  103160:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103163:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  103166:	8b 45 18             	mov    0x18(%ebp),%eax
  103169:	ba 00 00 00 00       	mov    $0x0,%edx
  10316e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  103171:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  103174:	19 d1                	sbb    %edx,%ecx
  103176:	72 4c                	jb     1031c4 <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
  103178:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10317b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10317e:	8b 45 20             	mov    0x20(%ebp),%eax
  103181:	89 44 24 18          	mov    %eax,0x18(%esp)
  103185:	89 54 24 14          	mov    %edx,0x14(%esp)
  103189:	8b 45 18             	mov    0x18(%ebp),%eax
  10318c:	89 44 24 10          	mov    %eax,0x10(%esp)
  103190:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103193:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103196:	89 44 24 08          	mov    %eax,0x8(%esp)
  10319a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10319e:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1031a8:	89 04 24             	mov    %eax,(%esp)
  1031ab:	e8 39 ff ff ff       	call   1030e9 <printnum>
  1031b0:	eb 1b                	jmp    1031cd <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1031b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031b9:	8b 45 20             	mov    0x20(%ebp),%eax
  1031bc:	89 04 24             	mov    %eax,(%esp)
  1031bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1031c2:	ff d0                	call   *%eax
        while (-- width > 0)
  1031c4:	ff 4d 1c             	decl   0x1c(%ebp)
  1031c7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1031cb:	7f e5                	jg     1031b2 <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1031cd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1031d0:	05 30 3f 10 00       	add    $0x103f30,%eax
  1031d5:	0f b6 00             	movzbl (%eax),%eax
  1031d8:	0f be c0             	movsbl %al,%eax
  1031db:	8b 55 0c             	mov    0xc(%ebp),%edx
  1031de:	89 54 24 04          	mov    %edx,0x4(%esp)
  1031e2:	89 04 24             	mov    %eax,(%esp)
  1031e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1031e8:	ff d0                	call   *%eax
}
  1031ea:	90                   	nop
  1031eb:	c9                   	leave  
  1031ec:	c3                   	ret    

001031ed <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1031ed:	f3 0f 1e fb          	endbr32 
  1031f1:	55                   	push   %ebp
  1031f2:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1031f4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1031f8:	7e 14                	jle    10320e <getuint+0x21>
        return va_arg(*ap, unsigned long long);
  1031fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1031fd:	8b 00                	mov    (%eax),%eax
  1031ff:	8d 48 08             	lea    0x8(%eax),%ecx
  103202:	8b 55 08             	mov    0x8(%ebp),%edx
  103205:	89 0a                	mov    %ecx,(%edx)
  103207:	8b 50 04             	mov    0x4(%eax),%edx
  10320a:	8b 00                	mov    (%eax),%eax
  10320c:	eb 30                	jmp    10323e <getuint+0x51>
    }
    else if (lflag) {
  10320e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103212:	74 16                	je     10322a <getuint+0x3d>
        return va_arg(*ap, unsigned long);
  103214:	8b 45 08             	mov    0x8(%ebp),%eax
  103217:	8b 00                	mov    (%eax),%eax
  103219:	8d 48 04             	lea    0x4(%eax),%ecx
  10321c:	8b 55 08             	mov    0x8(%ebp),%edx
  10321f:	89 0a                	mov    %ecx,(%edx)
  103221:	8b 00                	mov    (%eax),%eax
  103223:	ba 00 00 00 00       	mov    $0x0,%edx
  103228:	eb 14                	jmp    10323e <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
  10322a:	8b 45 08             	mov    0x8(%ebp),%eax
  10322d:	8b 00                	mov    (%eax),%eax
  10322f:	8d 48 04             	lea    0x4(%eax),%ecx
  103232:	8b 55 08             	mov    0x8(%ebp),%edx
  103235:	89 0a                	mov    %ecx,(%edx)
  103237:	8b 00                	mov    (%eax),%eax
  103239:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  10323e:	5d                   	pop    %ebp
  10323f:	c3                   	ret    

00103240 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  103240:	f3 0f 1e fb          	endbr32 
  103244:	55                   	push   %ebp
  103245:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  103247:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10324b:	7e 14                	jle    103261 <getint+0x21>
        return va_arg(*ap, long long);
  10324d:	8b 45 08             	mov    0x8(%ebp),%eax
  103250:	8b 00                	mov    (%eax),%eax
  103252:	8d 48 08             	lea    0x8(%eax),%ecx
  103255:	8b 55 08             	mov    0x8(%ebp),%edx
  103258:	89 0a                	mov    %ecx,(%edx)
  10325a:	8b 50 04             	mov    0x4(%eax),%edx
  10325d:	8b 00                	mov    (%eax),%eax
  10325f:	eb 28                	jmp    103289 <getint+0x49>
    }
    else if (lflag) {
  103261:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103265:	74 12                	je     103279 <getint+0x39>
        return va_arg(*ap, long);
  103267:	8b 45 08             	mov    0x8(%ebp),%eax
  10326a:	8b 00                	mov    (%eax),%eax
  10326c:	8d 48 04             	lea    0x4(%eax),%ecx
  10326f:	8b 55 08             	mov    0x8(%ebp),%edx
  103272:	89 0a                	mov    %ecx,(%edx)
  103274:	8b 00                	mov    (%eax),%eax
  103276:	99                   	cltd   
  103277:	eb 10                	jmp    103289 <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
  103279:	8b 45 08             	mov    0x8(%ebp),%eax
  10327c:	8b 00                	mov    (%eax),%eax
  10327e:	8d 48 04             	lea    0x4(%eax),%ecx
  103281:	8b 55 08             	mov    0x8(%ebp),%edx
  103284:	89 0a                	mov    %ecx,(%edx)
  103286:	8b 00                	mov    (%eax),%eax
  103288:	99                   	cltd   
    }
}
  103289:	5d                   	pop    %ebp
  10328a:	c3                   	ret    

0010328b <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  10328b:	f3 0f 1e fb          	endbr32 
  10328f:	55                   	push   %ebp
  103290:	89 e5                	mov    %esp,%ebp
  103292:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  103295:	8d 45 14             	lea    0x14(%ebp),%eax
  103298:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  10329b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10329e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1032a2:	8b 45 10             	mov    0x10(%ebp),%eax
  1032a5:	89 44 24 08          	mov    %eax,0x8(%esp)
  1032a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1032b3:	89 04 24             	mov    %eax,(%esp)
  1032b6:	e8 03 00 00 00       	call   1032be <vprintfmt>
    va_end(ap);
}
  1032bb:	90                   	nop
  1032bc:	c9                   	leave  
  1032bd:	c3                   	ret    

001032be <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1032be:	f3 0f 1e fb          	endbr32 
  1032c2:	55                   	push   %ebp
  1032c3:	89 e5                	mov    %esp,%ebp
  1032c5:	56                   	push   %esi
  1032c6:	53                   	push   %ebx
  1032c7:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1032ca:	eb 17                	jmp    1032e3 <vprintfmt+0x25>
            if (ch == '\0') {
  1032cc:	85 db                	test   %ebx,%ebx
  1032ce:	0f 84 c0 03 00 00    	je     103694 <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
  1032d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032db:	89 1c 24             	mov    %ebx,(%esp)
  1032de:	8b 45 08             	mov    0x8(%ebp),%eax
  1032e1:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1032e3:	8b 45 10             	mov    0x10(%ebp),%eax
  1032e6:	8d 50 01             	lea    0x1(%eax),%edx
  1032e9:	89 55 10             	mov    %edx,0x10(%ebp)
  1032ec:	0f b6 00             	movzbl (%eax),%eax
  1032ef:	0f b6 d8             	movzbl %al,%ebx
  1032f2:	83 fb 25             	cmp    $0x25,%ebx
  1032f5:	75 d5                	jne    1032cc <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
  1032f7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1032fb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  103302:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103305:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  103308:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10330f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103312:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  103315:	8b 45 10             	mov    0x10(%ebp),%eax
  103318:	8d 50 01             	lea    0x1(%eax),%edx
  10331b:	89 55 10             	mov    %edx,0x10(%ebp)
  10331e:	0f b6 00             	movzbl (%eax),%eax
  103321:	0f b6 d8             	movzbl %al,%ebx
  103324:	8d 43 dd             	lea    -0x23(%ebx),%eax
  103327:	83 f8 55             	cmp    $0x55,%eax
  10332a:	0f 87 38 03 00 00    	ja     103668 <vprintfmt+0x3aa>
  103330:	8b 04 85 54 3f 10 00 	mov    0x103f54(,%eax,4),%eax
  103337:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  10333a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  10333e:	eb d5                	jmp    103315 <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  103340:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  103344:	eb cf                	jmp    103315 <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  103346:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  10334d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103350:	89 d0                	mov    %edx,%eax
  103352:	c1 e0 02             	shl    $0x2,%eax
  103355:	01 d0                	add    %edx,%eax
  103357:	01 c0                	add    %eax,%eax
  103359:	01 d8                	add    %ebx,%eax
  10335b:	83 e8 30             	sub    $0x30,%eax
  10335e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  103361:	8b 45 10             	mov    0x10(%ebp),%eax
  103364:	0f b6 00             	movzbl (%eax),%eax
  103367:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  10336a:	83 fb 2f             	cmp    $0x2f,%ebx
  10336d:	7e 38                	jle    1033a7 <vprintfmt+0xe9>
  10336f:	83 fb 39             	cmp    $0x39,%ebx
  103372:	7f 33                	jg     1033a7 <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
  103374:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  103377:	eb d4                	jmp    10334d <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  103379:	8b 45 14             	mov    0x14(%ebp),%eax
  10337c:	8d 50 04             	lea    0x4(%eax),%edx
  10337f:	89 55 14             	mov    %edx,0x14(%ebp)
  103382:	8b 00                	mov    (%eax),%eax
  103384:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  103387:	eb 1f                	jmp    1033a8 <vprintfmt+0xea>

        case '.':
            if (width < 0)
  103389:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10338d:	79 86                	jns    103315 <vprintfmt+0x57>
                width = 0;
  10338f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  103396:	e9 7a ff ff ff       	jmp    103315 <vprintfmt+0x57>

        case '#':
            altflag = 1;
  10339b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1033a2:	e9 6e ff ff ff       	jmp    103315 <vprintfmt+0x57>
            goto process_precision;
  1033a7:	90                   	nop

        process_precision:
            if (width < 0)
  1033a8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1033ac:	0f 89 63 ff ff ff    	jns    103315 <vprintfmt+0x57>
                width = precision, precision = -1;
  1033b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1033b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1033b8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1033bf:	e9 51 ff ff ff       	jmp    103315 <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1033c4:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  1033c7:	e9 49 ff ff ff       	jmp    103315 <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1033cc:	8b 45 14             	mov    0x14(%ebp),%eax
  1033cf:	8d 50 04             	lea    0x4(%eax),%edx
  1033d2:	89 55 14             	mov    %edx,0x14(%ebp)
  1033d5:	8b 00                	mov    (%eax),%eax
  1033d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  1033da:	89 54 24 04          	mov    %edx,0x4(%esp)
  1033de:	89 04 24             	mov    %eax,(%esp)
  1033e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1033e4:	ff d0                	call   *%eax
            break;
  1033e6:	e9 a4 02 00 00       	jmp    10368f <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1033eb:	8b 45 14             	mov    0x14(%ebp),%eax
  1033ee:	8d 50 04             	lea    0x4(%eax),%edx
  1033f1:	89 55 14             	mov    %edx,0x14(%ebp)
  1033f4:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1033f6:	85 db                	test   %ebx,%ebx
  1033f8:	79 02                	jns    1033fc <vprintfmt+0x13e>
                err = -err;
  1033fa:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1033fc:	83 fb 06             	cmp    $0x6,%ebx
  1033ff:	7f 0b                	jg     10340c <vprintfmt+0x14e>
  103401:	8b 34 9d 14 3f 10 00 	mov    0x103f14(,%ebx,4),%esi
  103408:	85 f6                	test   %esi,%esi
  10340a:	75 23                	jne    10342f <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
  10340c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  103410:	c7 44 24 08 41 3f 10 	movl   $0x103f41,0x8(%esp)
  103417:	00 
  103418:	8b 45 0c             	mov    0xc(%ebp),%eax
  10341b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10341f:	8b 45 08             	mov    0x8(%ebp),%eax
  103422:	89 04 24             	mov    %eax,(%esp)
  103425:	e8 61 fe ff ff       	call   10328b <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10342a:	e9 60 02 00 00       	jmp    10368f <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
  10342f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  103433:	c7 44 24 08 4a 3f 10 	movl   $0x103f4a,0x8(%esp)
  10343a:	00 
  10343b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10343e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103442:	8b 45 08             	mov    0x8(%ebp),%eax
  103445:	89 04 24             	mov    %eax,(%esp)
  103448:	e8 3e fe ff ff       	call   10328b <printfmt>
            break;
  10344d:	e9 3d 02 00 00       	jmp    10368f <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  103452:	8b 45 14             	mov    0x14(%ebp),%eax
  103455:	8d 50 04             	lea    0x4(%eax),%edx
  103458:	89 55 14             	mov    %edx,0x14(%ebp)
  10345b:	8b 30                	mov    (%eax),%esi
  10345d:	85 f6                	test   %esi,%esi
  10345f:	75 05                	jne    103466 <vprintfmt+0x1a8>
                p = "(null)";
  103461:	be 4d 3f 10 00       	mov    $0x103f4d,%esi
            }
            if (width > 0 && padc != '-') {
  103466:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10346a:	7e 76                	jle    1034e2 <vprintfmt+0x224>
  10346c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  103470:	74 70                	je     1034e2 <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
  103472:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103475:	89 44 24 04          	mov    %eax,0x4(%esp)
  103479:	89 34 24             	mov    %esi,(%esp)
  10347c:	e8 ba f7 ff ff       	call   102c3b <strnlen>
  103481:	8b 55 e8             	mov    -0x18(%ebp),%edx
  103484:	29 c2                	sub    %eax,%edx
  103486:	89 d0                	mov    %edx,%eax
  103488:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10348b:	eb 16                	jmp    1034a3 <vprintfmt+0x1e5>
                    putch(padc, putdat);
  10348d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  103491:	8b 55 0c             	mov    0xc(%ebp),%edx
  103494:	89 54 24 04          	mov    %edx,0x4(%esp)
  103498:	89 04 24             	mov    %eax,(%esp)
  10349b:	8b 45 08             	mov    0x8(%ebp),%eax
  10349e:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  1034a0:	ff 4d e8             	decl   -0x18(%ebp)
  1034a3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1034a7:	7f e4                	jg     10348d <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1034a9:	eb 37                	jmp    1034e2 <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
  1034ab:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1034af:	74 1f                	je     1034d0 <vprintfmt+0x212>
  1034b1:	83 fb 1f             	cmp    $0x1f,%ebx
  1034b4:	7e 05                	jle    1034bb <vprintfmt+0x1fd>
  1034b6:	83 fb 7e             	cmp    $0x7e,%ebx
  1034b9:	7e 15                	jle    1034d0 <vprintfmt+0x212>
                    putch('?', putdat);
  1034bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034be:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034c2:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  1034c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1034cc:	ff d0                	call   *%eax
  1034ce:	eb 0f                	jmp    1034df <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
  1034d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034d7:	89 1c 24             	mov    %ebx,(%esp)
  1034da:	8b 45 08             	mov    0x8(%ebp),%eax
  1034dd:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1034df:	ff 4d e8             	decl   -0x18(%ebp)
  1034e2:	89 f0                	mov    %esi,%eax
  1034e4:	8d 70 01             	lea    0x1(%eax),%esi
  1034e7:	0f b6 00             	movzbl (%eax),%eax
  1034ea:	0f be d8             	movsbl %al,%ebx
  1034ed:	85 db                	test   %ebx,%ebx
  1034ef:	74 27                	je     103518 <vprintfmt+0x25a>
  1034f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1034f5:	78 b4                	js     1034ab <vprintfmt+0x1ed>
  1034f7:	ff 4d e4             	decl   -0x1c(%ebp)
  1034fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1034fe:	79 ab                	jns    1034ab <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
  103500:	eb 16                	jmp    103518 <vprintfmt+0x25a>
                putch(' ', putdat);
  103502:	8b 45 0c             	mov    0xc(%ebp),%eax
  103505:	89 44 24 04          	mov    %eax,0x4(%esp)
  103509:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  103510:	8b 45 08             	mov    0x8(%ebp),%eax
  103513:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  103515:	ff 4d e8             	decl   -0x18(%ebp)
  103518:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10351c:	7f e4                	jg     103502 <vprintfmt+0x244>
            }
            break;
  10351e:	e9 6c 01 00 00       	jmp    10368f <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  103523:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103526:	89 44 24 04          	mov    %eax,0x4(%esp)
  10352a:	8d 45 14             	lea    0x14(%ebp),%eax
  10352d:	89 04 24             	mov    %eax,(%esp)
  103530:	e8 0b fd ff ff       	call   103240 <getint>
  103535:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103538:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  10353b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10353e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103541:	85 d2                	test   %edx,%edx
  103543:	79 26                	jns    10356b <vprintfmt+0x2ad>
                putch('-', putdat);
  103545:	8b 45 0c             	mov    0xc(%ebp),%eax
  103548:	89 44 24 04          	mov    %eax,0x4(%esp)
  10354c:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  103553:	8b 45 08             	mov    0x8(%ebp),%eax
  103556:	ff d0                	call   *%eax
                num = -(long long)num;
  103558:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10355b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10355e:	f7 d8                	neg    %eax
  103560:	83 d2 00             	adc    $0x0,%edx
  103563:	f7 da                	neg    %edx
  103565:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103568:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  10356b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  103572:	e9 a8 00 00 00       	jmp    10361f <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  103577:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10357a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10357e:	8d 45 14             	lea    0x14(%ebp),%eax
  103581:	89 04 24             	mov    %eax,(%esp)
  103584:	e8 64 fc ff ff       	call   1031ed <getuint>
  103589:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10358c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  10358f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  103596:	e9 84 00 00 00       	jmp    10361f <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  10359b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10359e:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035a2:	8d 45 14             	lea    0x14(%ebp),%eax
  1035a5:	89 04 24             	mov    %eax,(%esp)
  1035a8:	e8 40 fc ff ff       	call   1031ed <getuint>
  1035ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035b0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1035b3:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1035ba:	eb 63                	jmp    10361f <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
  1035bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035c3:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  1035ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1035cd:	ff d0                	call   *%eax
            putch('x', putdat);
  1035cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035d6:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  1035dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1035e0:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  1035e2:	8b 45 14             	mov    0x14(%ebp),%eax
  1035e5:	8d 50 04             	lea    0x4(%eax),%edx
  1035e8:	89 55 14             	mov    %edx,0x14(%ebp)
  1035eb:	8b 00                	mov    (%eax),%eax
  1035ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  1035f7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1035fe:	eb 1f                	jmp    10361f <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  103600:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103603:	89 44 24 04          	mov    %eax,0x4(%esp)
  103607:	8d 45 14             	lea    0x14(%ebp),%eax
  10360a:	89 04 24             	mov    %eax,(%esp)
  10360d:	e8 db fb ff ff       	call   1031ed <getuint>
  103612:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103615:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  103618:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  10361f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  103623:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103626:	89 54 24 18          	mov    %edx,0x18(%esp)
  10362a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10362d:	89 54 24 14          	mov    %edx,0x14(%esp)
  103631:	89 44 24 10          	mov    %eax,0x10(%esp)
  103635:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103638:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10363b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10363f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  103643:	8b 45 0c             	mov    0xc(%ebp),%eax
  103646:	89 44 24 04          	mov    %eax,0x4(%esp)
  10364a:	8b 45 08             	mov    0x8(%ebp),%eax
  10364d:	89 04 24             	mov    %eax,(%esp)
  103650:	e8 94 fa ff ff       	call   1030e9 <printnum>
            break;
  103655:	eb 38                	jmp    10368f <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  103657:	8b 45 0c             	mov    0xc(%ebp),%eax
  10365a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10365e:	89 1c 24             	mov    %ebx,(%esp)
  103661:	8b 45 08             	mov    0x8(%ebp),%eax
  103664:	ff d0                	call   *%eax
            break;
  103666:	eb 27                	jmp    10368f <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  103668:	8b 45 0c             	mov    0xc(%ebp),%eax
  10366b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10366f:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  103676:	8b 45 08             	mov    0x8(%ebp),%eax
  103679:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  10367b:	ff 4d 10             	decl   0x10(%ebp)
  10367e:	eb 03                	jmp    103683 <vprintfmt+0x3c5>
  103680:	ff 4d 10             	decl   0x10(%ebp)
  103683:	8b 45 10             	mov    0x10(%ebp),%eax
  103686:	48                   	dec    %eax
  103687:	0f b6 00             	movzbl (%eax),%eax
  10368a:	3c 25                	cmp    $0x25,%al
  10368c:	75 f2                	jne    103680 <vprintfmt+0x3c2>
                /* do nothing */;
            break;
  10368e:	90                   	nop
    while (1) {
  10368f:	e9 36 fc ff ff       	jmp    1032ca <vprintfmt+0xc>
                return;
  103694:	90                   	nop
        }
    }
}
  103695:	83 c4 40             	add    $0x40,%esp
  103698:	5b                   	pop    %ebx
  103699:	5e                   	pop    %esi
  10369a:	5d                   	pop    %ebp
  10369b:	c3                   	ret    

0010369c <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  10369c:	f3 0f 1e fb          	endbr32 
  1036a0:	55                   	push   %ebp
  1036a1:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1036a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036a6:	8b 40 08             	mov    0x8(%eax),%eax
  1036a9:	8d 50 01             	lea    0x1(%eax),%edx
  1036ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036af:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1036b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036b5:	8b 10                	mov    (%eax),%edx
  1036b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036ba:	8b 40 04             	mov    0x4(%eax),%eax
  1036bd:	39 c2                	cmp    %eax,%edx
  1036bf:	73 12                	jae    1036d3 <sprintputch+0x37>
        *b->buf ++ = ch;
  1036c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036c4:	8b 00                	mov    (%eax),%eax
  1036c6:	8d 48 01             	lea    0x1(%eax),%ecx
  1036c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1036cc:	89 0a                	mov    %ecx,(%edx)
  1036ce:	8b 55 08             	mov    0x8(%ebp),%edx
  1036d1:	88 10                	mov    %dl,(%eax)
    }
}
  1036d3:	90                   	nop
  1036d4:	5d                   	pop    %ebp
  1036d5:	c3                   	ret    

001036d6 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1036d6:	f3 0f 1e fb          	endbr32 
  1036da:	55                   	push   %ebp
  1036db:	89 e5                	mov    %esp,%ebp
  1036dd:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1036e0:	8d 45 14             	lea    0x14(%ebp),%eax
  1036e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  1036e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1036e9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1036ed:	8b 45 10             	mov    0x10(%ebp),%eax
  1036f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1036f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1036fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1036fe:	89 04 24             	mov    %eax,(%esp)
  103701:	e8 08 00 00 00       	call   10370e <vsnprintf>
  103706:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  103709:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10370c:	c9                   	leave  
  10370d:	c3                   	ret    

0010370e <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  10370e:	f3 0f 1e fb          	endbr32 
  103712:	55                   	push   %ebp
  103713:	89 e5                	mov    %esp,%ebp
  103715:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103718:	8b 45 08             	mov    0x8(%ebp),%eax
  10371b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10371e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103721:	8d 50 ff             	lea    -0x1(%eax),%edx
  103724:	8b 45 08             	mov    0x8(%ebp),%eax
  103727:	01 d0                	add    %edx,%eax
  103729:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10372c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103733:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103737:	74 0a                	je     103743 <vsnprintf+0x35>
  103739:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10373c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10373f:	39 c2                	cmp    %eax,%edx
  103741:	76 07                	jbe    10374a <vsnprintf+0x3c>
        return -E_INVAL;
  103743:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103748:	eb 2a                	jmp    103774 <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  10374a:	8b 45 14             	mov    0x14(%ebp),%eax
  10374d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103751:	8b 45 10             	mov    0x10(%ebp),%eax
  103754:	89 44 24 08          	mov    %eax,0x8(%esp)
  103758:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10375b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10375f:	c7 04 24 9c 36 10 00 	movl   $0x10369c,(%esp)
  103766:	e8 53 fb ff ff       	call   1032be <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  10376b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10376e:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  103771:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103774:	c9                   	leave  
  103775:	c3                   	ret    
