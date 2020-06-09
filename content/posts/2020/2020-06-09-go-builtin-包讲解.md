---
title: go builtin 包讲解
author: "edte"
tags: ["go"]
date: 2020-06-09
---

## 引言

这篇博客记录一下我学习 builtin  包的一些历程

## 介绍

我们知道，一门语言中的函数有两种类型，即内置函数和标准库函数，内置函数在直接内置在编译器中，而标准库则在磁盘里，需要用时需要去寻找。在 go 中也是一样，严格说来并没有 builtin 这个标准库，而我们现在在学习的这个包，只是官方为了使用 go doc 工具方便生成文档，而常见的，这个包里都是对 go 语言预定义标识符的一些介绍，具体实现自然没有在这个包。我们看源码包注释

```
/*
	Package builtin provides documentation for Go's predeclared identifiers.
	The items documented here are not actually in package builtin
	but their descriptions here allow godoc to present documentation
	for the language's special identifiers.
*/
```

这里清楚的说明了这个包的作用，所以我们平时使用 `errors.new` `new` 等，明明是小写，但是却可以在任何包中使用，这是因为它们根本就不是标准库函数，是内置函数。

## 正文

### bool/true/flase

我们知道任何语言都有一些数据类型（data type），而 bool 正是 go 内置的其中一种。

在 go 中，任何 data 都是分为 type 和 value 的，在 go 中还专门有 reflect 包来提供这方面的功能。对于 bool 这种 type, 也是有其 value 范围的，在 go 中就是  true 和 false 这两种了。在 go 里，true 和 false 都是常量，具体实现我们看源码

```
// bool is the set of boolean values, true and false.
type bool bool
```

可以看到 bool 是一种 type, value 是 true 和 false。我们可以实际来建立一个 bool var 看看

```
func main() {
	var a bool

	fmt.Println(reflect.TypeOf(a))  // bool
	fmt.Println(reflect.ValueOf(a)) // false
}
```

我们发现如果不在声明的时候赋值的话，bool 默认的 value 是 false

我们再来看源码

```
// true and false are the two untyped boolean values.
const (
	true  = 0 == 0 // Untyped bool.
	false = 0 != 0 // Untyped bool.
)
```

可以看到，true 和 false 是两种 const, 同时作为 bool type 的 values, 至于为什么 是 ` 0 == 0` 这种表达，或许你需要了解一下 bool 这种类型是什么意思。

我们可以实际看一下 true 和 false 的 type 和 value

```
func main() {
	fmt.Println(reflect.TypeOf(true))  // bool
	fmt.Println(reflect.ValueOf(true))  // true
	fmt.Println(reflect.TypeOf(false))  // bool 
	fmt.Println(reflect.ValueOf(false))  //false
}
```



我们说了这个包里都是些预定义标识符，不是关键字，那么我们可以把这些作为标识符的名字，如

```
func main() {
	var true int

	true = 1
	fmt.Println(true) // 1
}
```

可以看到 true 是能作为标识符的名字的，但是这种命名是极不推荐的，后面就的同样道理，就不占开了。



### uint8/uint16/uint32/uint64/uint/uintptr

我们只看 int 类型是基本的 data type，之后我们就会讲到 int，同样在 go 中，加上前缀 u (unsigned), 表示无符号整数，加上数字表示这个 int 占用多少 bit，如 uint32, 表示无符号整数，占用 32 bit。

我们来看源码

```
// uint8 is the set of all unsigned 8-bit integers.
// Range: 0 through 255.
type uint8 uint8

// uint16 is the set of all unsigned 16-bit integers.
// Range: 0 through 65535.
type uint16 uint16

// uint32 is the set of all unsigned 32-bit integers.
// Range: 0 through 4294967295.
type uint32 uint32

// uint64 is the set of all unsigned 64-bit integers.
// Range: 0 through 18446744073709551615.
type uint64 uint64
```

可以看到讲了这些 type，以及它们的范围（range），我们刚刚说了，后缀数字表示占用的 bit，比如占用 8 bit，那么就可以表示  `2 ** 8` 种情况。

我们来输出看一下

```
func main() {
	fmt.Println(math.Pow(2, 8))   // 256
	fmt.Println(math.Pow(2, 16))  // 65536
	fmt.Println(math.Pow(2, 32))  // 4.294967296e+09
	fmt.Println(math.Pow(2, 64))  // 1.8446744073709552e+19
}
```

可以看到 range 的上限就是这么来的，至于下限，都说了 unsigned 的了，自然只能是整数，如果你对这些不了解的话，需要自行了解一下它们的存储原理。

我们知道 uint 是有范围的，在 c 中，溢出（overflow）了的话，会根据存储原理改变数值，而不会报错，那么 go 中会怎么办呢，我们来看一下

```
func main() {
	var u uint8  // (0,255)
	u = -1   // constant -1 overflows uint8
	fmt.Println(u)
	u = 300   // constant 300 overflows uint8
	fmt.Println(u)
}
```

可以看到，go 会报 error ，这让我们更加关注问题本身，而不用考虑语言带来的问题了。

我们发现包中还有一个 uint 类型，前缀容易理解了，但是却没有后缀，我们来看注释

```
// uint is an unsigned integer type that is at least 32 bits in size. It is a
// distinct type, however, and not an alias for, say, uint32.
type uint uint
```

原来这是一个动态的 uint，我们经常会遇到移植问题，在不同平台上使用的 bit 也不同，所以这个类型可以很方便的自动判断，当使用 32 bit 的平台，那么就是 32 bit 的，当使用 64 bit 的，那么就是 64 bit 的。最小 32 bit，没有 8 和 16 bit 的。

我们继续，我们发现还有一个 uint 开头的 uintptr, uint 我们理解了， ptr 又是什么玩意？回想一下，  ptr 好像是 pointer(指针) 的缩写，那么这个类型肯定和 pointer 有关，我们继续看注释

```
// uintptr is an integer type that is large enough to hold the bit pattern of
// any pointer.
type uintptr uintptr
```

原来这个 type 也是一种 unsigned int, 用来存指针，至于有什么用，博主的指针现阶段比较弱，还没遇到过。

### int8/int16/int32/int64/int



### float32/float64

### complex64/complex128

### string

### byte/rune



## 参考

[基本类型和它们的字面量表示](https://gfw.go101.org/article/basic-types-and-value-literals.html)

[Difference between fmt.Println() and println() in Go](https://stackoverflow.com/questions/14680255/difference-between-fmt-println-and-println-in-go)

[example for the go pkg's function](https://github.com/astaxie/gopkg)

[Golang 中 fmt.Println 和直接 println 有什么区别](https://www.zhihu.com/question/335186436)