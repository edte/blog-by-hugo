---
title: 为什么你的程序总是 stack overflow?
author: "edte"
categories: ["c","OS","内存"]
tags: ["c","OS","内存"]
date: 2020-07-10
---

## 前言

在刷 leetcode 时，遇到了 stack-buffer-overflow, 这个问题比较常见，干脆总结一下原因。本文是在 linux 下操作的，需要使用一些相关的命令。

## stack 是什么

一般 stack 这个词有两个意思，即 stack 这种数据结构，和虚拟内存中 stack   这个段。

为什么虚拟内存中 stack 段会叫这个名字，我们先来看一下 stack 这种数据结构。stack 是线性表中的一种，元素间一对一，而且只能从 stack top 增加或删除元素，遵循 LIFO(last in, fisrt out) 原则。

![](https://img2020.cnblogs.com/blog/1823594/202007/1823594-20200711161907944-940856376.png)

如图，在 stack top 入 stack（push），出 stack(pop)。 LIFO 原则就是先入栈的，后出栈，看图就容易理解

![](https://img2020.cnblogs.com/blog/1823594/202007/1823594-20200711162109707-737108200.png)

第一个入栈的元素 1, 需要其他元素的出栈后才能出栈，而最后一个进栈的元素 4, 则第一个出栈。stack 在日常生活中也非常常见，如平放一些书，就是一个典型的 stack 结构。

stack 是一种逻辑结构，主要讲求的是元素间的逻辑关系，具体的实现可以顺序存储，或者链式存储，这里就不展开了。

## 进程空间/进程内存结构

我们首先需要知道程序是怎么从源码到执行的。c 语言需要进过这几个过程，编写源码 -> 预处理 -> 编译 -> 链接 成二进制文件，在 linux 下即 elf 文件，可以是可执行文件，或者是库文件。

如果是可执行文件，链接完成后，需要装载到内存中，操作系统给这个程序分配一定的内存空间，然后程序变成进程就开始执行了。

操作系统给程序分配的空间，这块内存有固定的结构，如图

![](https://wongxingjun.github.io/figures/c-memory-layout/memorylayout.png)

第一段是这块内存的一些上下文信息，如地址，环境变量等。

剩余的几段是我们需要掌握的，即 stack, heap, BSS, data, text

text 段是存代码，字面量，在运行时只读

data 段存已经初始化的静态变量，全局变量

BSS 段存没有初始化的静态变量，全局变量

heap 段存程序员自己分配的变量

stack 段存操作系统分配的局部变量，如参数，返回值等

BSS/data 段即一般说的静态区，全局区等。

## 代码组成

代码是由语句，变量，常量，字面量组成的。

语句即关键字/标识符等，字面量则是变量或常量的值，值整数 1,字符串 "hello" 等。

```
#include <stdio.h>

int main(void) {
    int a = 1;
    char c[] = {"hello"};
    printf("%d, %s\n", a, c);

    return 0;
}
```

如语句

```
#include <stdio.h>
main()
printf
return
```



## 程序内存分配方式

有了上面基础知识后，后面的知识更容易理解。现在我们举实例来说明

我们先来编写个最第一个程序

```
#include <stdio.h>

int main(void) {
	
    return 0;
}
```

使用 gcc 编译, gcc 是一个常用的 c 编译器

```
gcc -o main main.c
```

得到可执行文件 main，可以执行一下试试 

```
$ ./main 

```

然后我们使用 `size` 命令，man 是这样解释这个命令的 `list section sizes and total size of binary files`，我们可以看到二进制文件的结构，装载到内存中运行时，也是根据此来分配内存的。

```
$ size main
   text    data     bss     dec     hex filename
   1282     512       8    1802     70a main
```

dec 是十进制（Decimal），hex 是十六进制，dec 即文件大小，hex 是对应的十六进制，filename 是文件名，这三个都不是我们需要关注的。

我们可以看到 text，data，bss 这三段，现在我们的程序还没有运行，所以这三段编译结束后就已经固定了。

**text**

text 段是代码段，这段用来存语句和字面量的。

如

```
#include <stdio.h>

int main(void) {
    int a = 1;
    char c[] = {"hello"};
    printf("%d, %s\n", a, c);

    return 0;
}
```

像

```
#include <stdio.h>
main()
=
printf
return
```

等语句就是存在 text 区的，而

```
1
"hellow"
```

等字面量也是存在 text 区的。这个区不是我们想说的重点，继续。

**data/bss**

现在我们加几个未初始化的全局变量试试

```
#include <stdio.h>

int a;
int b;

int main(void) {

    return 0;
}
```

```
$ size main
   text    data     bss     dec     hex filename
   1282     512      16    1810     712 main
```

可以看到 BSS 段增加了，现在我们再试试加几个已经初始化的全局变量

```
#include <stdio.h>

int a = 1;
int b = 2;

int main(void) {

    return 0;
}
```

```
$ size main
   text    data     bss     dec     hex filename
   1282     520       8    1810     712 main
```

可以看到 data 段增加了

现在我们再加几个没有初始化的静态变量试试（局部/全局都一样）

```
#include <stdio.h>

int main(void) {
    static int a;
    static int b;

    return 0;
}
```

```
#include <stdio.h>

static int a;
static int b;

int main(void) {

    return 0;
}
```

```
$ size main
   text    data     bss     dec     hex filename
   1282     512      16    1810     712 main
```

可以看到 BSS 段增加了

现在我们再加几个已经初始化的静态变量试试（局部/全局都一样）

```
#include <stdio.h>

int main(void) {
    static int a = 1;
    static int b = 2;

    return 0;
}
```

```
#include <stdio.h>

static int a = 1;
static int b = 2;

int main(void) {

    return 0;
}
```

```
$ size main
   text    data     bss     dec     hex filename
   1282     520       8    1810     712 main
```

可以看到，data 段增加了。

通过上面的分析，我们发现未初始化的全局变量，未初始化的静态变量存在 bss 段，而已经初始化的全局变量，已经初始化的静态变量存在 data 段。

存在 data/bss 两段的变量，一般就叫静态内存分配，所谓静态就是编译前就已经分配好了内存，这我们从上面也可以得知。

除了这两种变量，还有 const 修饰的变量，register 修饰的变量等，但这都不是我们现在要讨论的重点，这里就不展开了。

**heap**

我们在上面讨论的 bss/data 区的变量，即静态分配的变量，在编译前就分配好了内存，程序结束才释放，所以在程序允许过程中，这些内存里的数据是不会丢失的。所以我们可以把这些变量作为返回值，赋给调用的函数里的变量。或者我们多次调用同一个函数中声明的静态分配的变量，值是接着上一次调用的值的。

如

```
#include <stdio.h>

int StaticAlloc() {
    static int a = 123;
    return a;
}

int main(void) {
    printf("%d", StaticAlloc());
    return 0;
}
```

这里成调用值成功了，同样的

```
#include <stdio.h>

void StaticAlloc() {
    static int a = 123;
    a++;
    printf("%d\n", a);
}

int main(void) {
    StaticAlloc();
    StaticAlloc();
    return 0;
}
```

如果这里没看懂函数调用的原理，可以先看下面 stack 的部分，再重新看。

类似静态分配变量的生命期是整个程序，还有一种变量也是这样。

再来看一下内存结构

![](https://wongxingjun.github.io/figures/c-memory-layout/memorylayout.png)

bss 区上面有一个 heap 区，我们使用 size 命令时没有看到这个区，这是因为这个区和 stack 区一样，是在程序装载到内存中，开始运行后才分配的。图里的箭头就是这个意思。

heap 这个区和 stack 区一样，程序会分配一个最大的内存限制，具体的值要看不同的操作系统。而在程序中实际使用了对于的变量，就是分配对应大小的值。在图中就是 heap 向上扩张，而 stack 向下扩张。

普通的大小，能查看到返回的地址

```
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int *a = (int *) malloc(4);
    printf("%p\n", a); // 0x5626852372a0

    return 0;
}
```

分配的内存过大，操作 heap 的最大值，所以没有分配内存成功，直接返回 nil 了

```
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int *a = (int *) malloc(9999999999999999);
    printf("%p\n", a); // nil

    return 0;
}
```

在 c 语言中，要在 heap 中分配内存，需要使用 stdlib.c 库中的 `malloc` 函数，传入分配的大小，返回那块内存的地址。

```
#include <stdlib.h>

int main(void) {
    int *a = (int *) malloc(sizeof(int));

    return 0;
}
```

如这个代码就是传了 int 占据的 byte 大小，然后分配这么多内存，再返回首地址，转换为 int 指针。这就是在 heap 上分配的，然后如果不释放这块内存的话，在程序结束前，这块内存都会被操作系统认为你在使用，但是实际上你没用，所以这块内存就会被浪费，这就是内存泄漏。释放的函数是 free。

```
#include <stdio.h>
#include <stdlib.h>

int DynamicAlloc() {
    int *a = (int *) malloc(sizeof(int));
    *a = 123;
    return *a;
}

int main(void) {
    printf("%d\n", DynamicAlloc()); // 123

    return 0;
}
```

在子函数中分配 heap内存，即使子函数结束了，里面分配的 heap 内存还在，数据也在。要释放的话

```
#include <stdio.h>
#include <stdlib.h>

int DynamicAlloc() {
    int *a = (int *) malloc(sizeof(int));
    *a = 123;
    free(a);
    return *a;
}

int main(void) {
    printf("%p\n", DynamicAlloc()); // nil

    return 0;
}
```

释放后，哪块内存就不能用了，就变成了 nil。

从上面我们可以发现，heap 是运行期间自己分配的内存，需要自己释放，不然的话就不会释放。这种分配在 heap 上的方式就叫动态内存分配。

**stack**

看了上面的你可能还是有些不理解 heap 和静态分配变量，那种子函数调用后返回地址，内存还能够使用，这种性质。现在我们继续来看 stack ，对比着你就能明白了。

继续来看内存结构

![](https://wongxingjun.github.io/figures/c-memory-layout/memorylayout.png)

stack 和 heap 一样，在程序运行时才分配内存，运行后可以在 `/proc` 目录对应进程文件查看，stack 同样有一个 os 分配的最大值，具体分配多少，需要看实际的代码。

stack 这个区域用来存 auto 变量，也就是局部作用域的变量，是我们平时使用最多的变量，包括形参，返回值，函数中的局部变量等。

我们知道 c 是由需要函数组成的，而局部变量也是按照函数来划分的，那么在 stack 中，又是怎么划分区域来存局部变量的呢？

>  下面的知识可能有一些错误，我没有深入到汇编，查看寄存器的使用情况，这里只是为了解释 stack 的分配问题。

编译器会计算一个函数中局部变量的个数和大小，然后分配一定的内存空间作为一帧。函数名就是在一帧的入口地址，调用函数的时候，就会跳转到这一帧然后使用这一帧里的内存。

![](https://img2020.cnblogs.com/blog/1823594/202007/1823594-20200711224339366-1327310732.png)

首先是返回值入 stack，然后是普通的局部变量，最后是行参。按照我们上面讲解 stack 这种数据结构，这里的 stack 区域也是这种性质，所以行参先出 stack，然后是普通的局部变量，最后是返回值。

![](https://img2020.cnblogs.com/blog/1823594/202007/1823594-20200711224527926-1075323475.png)



当返回值出 stack 后，这个函数就调用结束了，然后返回到调用函数的地址，继续执行，而这个函数分配的一帧地址就被操作系统回收了。

所以在函数中分配的局部变量，然后返回这个变量的地址，而在其他函数中是无法使用这块地址的内存的，因为它已经被释放了

```
#include <stdio.h>

int *AutoAlloc() {
    int a[] = {1, 2, 3};
    
    return a;
}

int main(void) {
    printf("%p", AutoAlloc()); // nil

    return 0;
}
```

如这个函数中，在 AutoAlloc 函数中分配的数组，存了 1，2, 3，然后把首地址作为返回值，在 main 中打印这个地址时，这个地址却变成了 nil，这就是因为 AutoAlloc 分配的 stack 区域已经释放了。

这种分配在 stack 上的方式也被称为自动分配方式，也就是 auto，即局部变量分配。

## 再谈 stack overflow

经过上面的分析，我想现在 stack 溢出这个问题已经很明显了，就是 stack 已经满了，而还要分配。如无限递归

```
void AutoAlloc() {
    AutoAlloc();
}

int main(void) {
    AutoAlloc();

    return 0;
}
```

这个函数就一直调用 AutoAlloc，就一直在 stack 区分配内存，最后 stack 区满了，就溢出了。

除了无限递归的问题外，使用已经释放的内存也是常遇到的问题，如在 leetcode 上刷数据结构时，有的题会需要你返回一个数组，然后数组中存数据。如果你在函数中用的 array 来存数组，而返回 array 的首地址的话，那么对方得到的地址就是 nil，就会报错，这时候使用 heap 来存数据更合适。

## 总结

我们经过分析内存结构，代码组成，然后引入变量的常用内存分配方式，从底层说明了 stack 溢出的原理。

从这个过程中，我也遇到许多问题，如内存结构，c 的汇编实现等底层知识，这再一次让我意识到底层知识的重要性。

## 参考

[Difference between static memory allocation and dynamic memory allocation](https://stackoverflow.com/questions/8385322/difference-between-static-memory-allocation-and-dynamic-memory-allocation)

[自动变量](https://zh.wikipedia.org/zh-cn/%E8%87%AA%E5%8A%A8%E5%8F%98%E9%87%8F#cite_note-5)

[函数内存分配](https://www.lagou.com/lgeduarticle/49533.html)

[数据段、代码段、堆栈段、BSS 段的区别](https://ivanzz1001.github.io/records/post/cplusplus/2018/11/12/cpluscplus-segment)

[函数的返回值保存在内存的什么区域](https://www.cnblogs.com/feng9exe/p/12527408.html)

[实例分析 C 程序运行时的内存结构](https://www.cnblogs.com/shine-lee/p/4316219.html)