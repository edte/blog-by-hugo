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

我们前面讲了 uint，这里讲解 int，没有了 u 前缀，我们容易理解 int 表示一一般的 int 型，对于 unsigned int 的范围是正数，而 int 型则根据其存储方式范围有正有负，后面的数字同样表示其占的 bit 数

```
// int8 is the set of all signed 8-bit integers.
// Range: -128 through 127.
type int8 int8

// int16 is the set of all signed 16-bit integers.
// Range: -32768 through 32767.
type int16 int16

// int32 is the set of all signed 32-bit integers.
// Range: -2147483648 through 2147483647.
type int32 int32

// int64 is the set of all signed 64-bit integers.
// Range: -9223372036854775808 through 9223372036854775807.
type int64 int64
```

我们来看一下

```
func main() {
	fmt.Println(math.Pow(2, 8) / 2)  //128
	fmt.Println(math.Pow(2, 16) / 2)  //32768
	fmt.Println(math.Pow(2, 32) / 2)  //2.147483648e+09
	fmt.Println(math.Pow(2, 64) / 2) //9.223372036854776e+18
}
```

可以看到其范围是对上的，不知道怎么回事请先学习 int 的存储方式。

我们再来看 int 型，类似于 uint

```
// int is a signed integer type that is at least 32 bits in size. It is a
// distinct type, however, and not an alias for, say, int32.
type int int
```

这个类型同样是一个不定的类型，根据平台知道分配 32 或 64 bit。

### float32/float64

我们继续来看 float

```
// float32 is the set of all IEEE-754 32-bit floating-point numbers.
type float32 float32

// float64 is the set of all IEEE-754 64-bit floating-point numbers.
type float64 float64
```

可以看到 float32/float64 即遵从 IEEE-754 标准的常用的单精度/双精度浮点数，类似 c 中的 float 和 double，至于 float 是什么，IEEE-754 标准是什么，这里就不展开了。

### complex64/complex128

```
// complex64 is the set of all complex numbers with float32 real and
// imaginary parts.
type complex64 complex64

// complex128 is the set of all complex numbers with float64 real and
// imaginary parts.
type complex128 complex128
```

看注释我们知道 complex 是复数类型，并且虚数和实数要是同一种 type，go 里只有两种，虚数和实数是 float32 的建立 complex64 type，虚数和实数是 float64 的建立 complex128 type，数字就是虚数和实数的 bit 相加，比较容易理解。

### byte/rune

我们先来看 byte

```
// byte is an alias for uint8 and is equivalent to uint8 in all ways. It is
// used, by convention, to distinguish byte values from 8-bit unsigned
// integer values.
type byte = uint8
```

可以看到 byte 即是 uint8, 只是用 type 别名了一下，uint8 我们先前知道即是无符号整型，占 8 bit，即 1 byte，也就是 1 字节，我们知道 byte 在计算机中是一个基本单位，那么 alias 一下便于使用也能理解，但是 rune 又是什么玩意？

```
// rune is an alias for int32 and is equivalent to int32 in all ways. It is
// used, by convention, to distinguish character values from integer values.
type rune = int32
```

我们看到 rune 是 int32 的别名，也就是 4 byte, 为什么要单独把这个东西列出来呢？注释说是为了区分 char 和 int 型。这里显然需要具体了解 string, char，字符编码等底层知识，这里就不展开了。

### string

我们来继续讲解 string

```
// string is the set of all strings of 8-bit bytes, conventionally but not
// necessarily representing UTF-8-encoded text. A string may be empty, but
// not nil. Values of string type are immutable.
type string string
```

可以看到 string 是 8 bit 的 slice, 也就是 byte slice, 使用的是 UTF-8 编码，只读，可以是空字符串，但不能是 nil, 我们来看代码

```
func main() {
	a := ""

	fmt.Println(reflect.TypeOf(a))   //string
	fmt.Println(reflect.ValueOf(a))  // 
	fmt.Println(len(a))      // 0 
	
	a = nil  //cannot use nil as type string in assignment
	
	a[0] = "sdf" //cannot assign to a[0]
}
```

可以看到的确可以为空字符串，其 byte length 为 0,输出空字符串，不能为 nil，且 string 这个 slice 是不能修改的。（len 返回 string 的 byte length)

我们再看

```
func main() {
	a := "啊"
	fmt.Println(len(a))  // 3
}
```

我们知道 中文在 Unicode 中占 2 byte，在 UTF-8 中 占 3 byte，可以看到的确是使用了 UTF-8 编码。但这也带来一些问题，比如如果某个字符串中有中文字符，想要获取这个字符串的字符个数，而不是 byte 长都，怎么办呢，显然 len 函数是不行的，又或者我们想要字符串的某个字符，直接使用下标 `a[3]` 是不行的，这得到的是第几个 byte, 这些问题都是我们有时会遇到的，这里就不展开了，其实 rune 就可以在这种情况中使用。

### iota

我们发现 builtin 包中有个 iota 常量，如果稍微对 go 熟悉一点的话，就知道 strconv 包中也有个 itoa 函数，不过 strconv(string convert) 中的 itoa(int to ascii) 是 int 转 string 用的，这里的 iota 显然不一样。我们来看注释

```
// iota is a predeclared identifier representing the untyped integer ordinal
// number of the current const specification in a (usually parenthesized)
// const declaration. It is zero-indexed.
const iota = 0 // Untyped int.
```

可以看到这个是一个常量计数器，只能在 const 语句中使用，默认从 0开始，后面递增赋值

```
func main() {
	fmt.Println(iota)  //undefined: itoa
}
```

可以看到我们不能直接使用 iota 常量

```
const a = iota

func main() {
	fmt.Println(a) // 0
}
```

```
const (
	a = iota
	b
)

func main() {
	fmt.Println(a) // 0
	fmt.Println(b)  //1
}
```

```
const (
	a = iota
	b
)

const c = iota

func main() {
	fmt.Println(a) // 0
	fmt.Println(b) // 1
	fmt.Println(c) // 0
}
```

根据上面我们知道 在不同的 const 语句中会重新从 0 开始，如果我们要跳过某个值的话，可以使用空白标识符 `_` 占位

```
const (
	a = iota
	_
	b
)

func main() {
	fmt.Println(a) // 0
	fmt.Println(b) // 2
}
```

```
const (
	a = iota
	_
	b
	c = 1
	d
	e
)

func main() {
	fmt.Println(a) // 0
	fmt.Println(b) // 2
	fmt.Println(c) // 1
	fmt.Println(d) // 1
	fmt.Println(e) // 1
}
```

可以看到如果某个值直接赋值了的话，后面会默认赋相同的值。

这里我们大概讲解了 iota 的使用，当然还用具体实际的应用和一些注意点，这里就不展开了。

### Type/Type1/IntegerType/FloatType/ComplexType

这么一长串在 go 中都没有对应的预定义标识符，完全是为了生成文档，为什么要搞这几类，我们这里就不去了解了

```
// Type is here for the purposes of documentation only. It is a stand-in
// for any Go type, but represents the same type for any given function
// invocation.
type Type int

// Type1 is here for the purposes of documentation only. It is a stand-in
// for any Go type, but represents the same type for any given function
// invocation.
type Type1 int

// IntegerType is here for the purposes of documentation only. It is a stand-in
// for any integer type: int, uint, int8 etc.
type IntegerType int

// FloatType is here for the purposes of documentation only. It is a stand-in
// for either float type: float32 or float64.
type FloatType float32

// ComplexType is here for the purposes of documentation only. It is a
// stand-in for either complex type: complex64 or complex128.
type ComplexType complex64
```

### nil

nil 是我们在错误处理时常遇到的，我们这里来稍微深入一下

```
// nil is a predeclared identifier representing the zero value for a
// pointer, channel, func, interface, map, or slice type.
var nil Type // Type must be a pointer, channel, func, interface, map, or slice type
```

可以看到 nil 是一种 value，不是一种 type，这种 value 是 pointer, channerl, func, interface, map, slice 没有赋值时默认的 value。我们先来看这之外的 type

```
type A struct {
	i int
	f float32
	c complex64
	s string
}

func main() {
	var a A
	fmt.Println(reflect.ValueOf(a))  //{0 0 (0+0i) }
}
```

可以看到， int 为赋值时默认 value 为 0, float 为赋值时默认 value 为 0, complex 为赋值时默认 value 为 0+0i, string 为赋值时默认 value 为 ""。 struct 则要看具体的 filed，如果没有 filed 则 是 `{}`.

```
func main() {
	a := nil //Cannot use 'nil' as type Type
	fmt.Println(a)
}
```

可以看到 nil 不是一种 type

```
func main() {
	fmt.Println(reflect.TypeOf(nil))  //<nil>
	fmt.Println(reflect.ValueOf(nil)) // <invalid reflect.Value>
}
```

但是这里 却显示 nil 是一种 type ，暂时不知道为什么。



现在我们来看空 value 为 nil 的几种 type

pointer

```
func main() {
	var p *int

	fmt.Println(reflect.TypeOf(p))  //*int
	fmt.Println(reflect.ValueOf(p)) // <nil>
	fmt.Println(p == nil)  //true
}
```

slice

```
func main() {
	var s []int

	fmt.Println(reflect.TypeOf(s))  //[]int
	fmt.Println(reflect.ValueOf(s)) // []
	fmt.Println(s == nil)  //true
}
```

interface

```
func main() {
	var a interface{}
	fmt.Println(reflect.TypeOf(a))  // <nil>
	fmt.Println(reflect.ValueOf(a)) //<invalid reflect.Value>
	fmt.Println(a == nil)           //true
}
```

map

```
func main() {
	var a map[int]string

	fmt.Println(reflect.TypeOf(a))  // map[int]string
	fmt.Println(reflect.ValueOf(a)) // map[]
	fmt.Println(a == nil)           // true
}
```

channel

```
func main() {
	var a chan int

	fmt.Println(reflect.TypeOf(a))  // chan int
	fmt.Println(reflect.ValueOf(a)) // <nil>
	fmt.Println(a == nil)           // true
}
```

func

```
func main() {
	var a func()

	fmt.Println(reflect.TypeOf(a))  // func()
	fmt.Println(reflect.ValueOf(a)) // <nil>
	fmt.Println(a == nil)           // true
}
```

现在我们已经知道什么时候会出现 nil，那么具体 nil 的应用就要看具体哪一种类型了，如 error interface 为 nil 的话，就是没有错误，这也是我们最常用的一种，其他具体的应用这里就不展开了。

### complex/real/imag

我们在前面讲了 complex 这种类型，但是要创建一个 complex 的话还需要借助 complex 这个内置 func

```
// The complex built-in function constructs a complex value from two
// floating-point values. The real and imaginary parts must be of the same
// size, either float32 or float64 (or assignable to them), and the return
// value will be the corresponding complex type (complex64 for float32,
// complex128 for float64).
func complex(r, i FloatType) ComplexType
```

可以看到传入两个 type 相同的 float，返回一个对于的 complexType, 如

```
func main() {
	c := complex(1, 2)
	fmt.Println(reflect.TypeOf(c))   //complex128
	fmt.Println(reflect.ValueOf(c))  // 1+2i
}
```

我们知道复数是有实部（real) 和虚部（imaginary) 的，同样的，在 go 中也有 real(), ima() 函数获取对应的值

```
// The real built-in function returns the real part of the complex number c.
// The return value will be floating point type corresponding to the type of c.
func real(c ComplexType) FloatType

// The imag built-in function returns the imaginary part of the complex
// number c. The return value will be floating point type corresponding to
// the type of c.
func imag(c ComplexType) FloatType
```

```
func main() {
	c := complex(1, 2)
	fmt.Println(real(c)) // 1
	fmt.Println(imag(c)) // 2
}
```

### append

```
// The append built-in function appends elements to the end of a slice. If
// it has sufficient capacity, the destination is resliced to accommodate the
// new elements. If it does not, a new underlying array will be allocated.
// Append returns the updated slice. It is therefore necessary to store the
// result of append, often in the variable holding the slice itself:
//	slice = append(slice, elem1, elem2)
//	slice = append(slice, anotherSlice...)
// As a special case, it is legal to append a string to a byte slice, like this:
//	slice = append([]byte("hello "), "world"...)
func append(slice []Type, elems ...Type) []Type
```

我们先来看注释，注释说 append 用来给 slice 增加元素的，而且是在末尾追加。我们知道 slice 有 cap（分配的内存长度） 和 len（实际存储的元素个数），注释说，如果 cap 够，那么直接在这个 slice 中添加元素，如果不够，那么间新建一个 array。所以需要有一个返回值 slice。这里我们了解到，slice 其实底层就是 array，并不存在变长这么个操作，只是重新分配内存然后赋值而已。

很多时候我们只是操作一个 slice, 所以一般都是把返回的 slice 赋给它本身，这样从结果看来似乎就是 slice 变长了。我们来看代码

```
func main() {
	a := []int{1, 2, 3}
	b := append(a, 4, 5)
	fmt.Println(b) // [1 2 3 4 5]
	fmt.Println(a) // [1 2 3]
}
```

可以看到原来的 slice a 并没有变化。

当然更多的时候我们是这样用的

```
func main() {
	a := []int{1, 2, 3}
	a = append(a, 4, 5)
	fmt.Println(a) // [1 2 3 4 5]
}
```

我们继续看注释，append 的第二个参数原来还可以是 slice, 我们来继续

```
func main() {
	a := []int{1, 2, 3}
	b := []int{4, 5}
	fmt.Println(append(a, b...)) // [1 2 3 4 5]
}
```

我们发现需要加 `...`, 这个是 go 的一个语法糖，用来表示可变参数，这里就是把 b slice 中的元素以此传进去。

当然，有时候我们会问如果类型不同怎么办

```
func main() {
	a := []int{1, 2, 3}
	b := []string{"df", "sd"}
	fmt.Println(append(a, b...)) //cannot use b (type []string) as type []int in append
}
```

那当然是报 error 了。

我们继续看注释，还有种特殊情况，第一个 slice 是 byte slice 时，第二个参数可以直接是 string

```
func main() {
	a := append([]byte("hello "), "word"...)
	fmt.Println(a)         // [104 101 108 108 111 32 119 111 114 100]
	fmt.Println(string(a)) // hello word
}
```

我们发现成功返回了 byte slice, 转换看一下也成功了，如果我们了解 string 的底层原理的话，我们就知道 string 其实就是 byte slice, 所以这种其实和第二个参数是 slice 原理相同，只是需要考虑是否会在字符编码的问题。

### copy

我们刚刚讲了 append() 这个给 slice 增加 elem 的 func，现在我们来继续讲一个和 slice 相关的。

```
// The copy built-in function copies elements from a source slice into a
// destination slice. (As a special case, it also will copy bytes from a
// string to a slice of bytes.) The source and destination may overlap. Copy
// returns the number of elements copied, which will be the minimum of
// len(src) and len(dst).
func copy(dst, src []Type) int
```

我们从注释中得知，这个函数用来复制 slice, 我们可能会问，为什么不直接声明一个变量赋值或短声明直接赋值呢，语言是苍白的，我们来看代码

```
func main() {
	a := []int{1, 3, 4, 5}
	var b []int
	b = a

	fmt.Printf("%p\n", a) // 0xc000100020
	fmt.Printf("%p", b)   // 0xc000100020
}
```

```
func main() {
	a := []int{1, 3, 4, 5}
	b := a

	fmt.Printf("%p\n", a) // 0xc000018240
	fmt.Printf("%p", b)   // 0xc000018240
}
```

我们发现两个 slice 的 地址是相同的，这说明它们根本指向的是一个东西，对一个操作会影响另一个变量。不行的话看

```
func main() {
	a := []int{1, 3, 4, 5}
	b := a
	b[0] = 100

	fmt.Println(a[0]) //100
}
```

那么这是为什么呢，如果我们知道 slice 的存储原理，或者学过 c 语言就比较容易理解，变量名存储的其实 slice 的首地址，直接赋值只是把首地址，也就是指针给传过去了，根本没有分配新的内存空间，自然会失败了。

而 copy 函数，我们看到传入了 dst slice 和 src slice，即 目标（destination） slice 和 源（source） slice，分配了两块内存空间。我们知道有可能其中一个会溢出，所以会返回成功赋值成功的元素个数。我们来看代码

```
func main() {
	a := []int{1, 2, 3}
	b := make([]int, 2)

	copy(b, a) // 把 a 的元素 复制 b，b 的 len 是 2 , a 是 3,所以 b 溢出了，只能复制前两个元素 1 和 2

	fmt.Println(b) // [1,2]
}
```

```
func main() {
	a := []int{1, 2, 3}
	b := make([]int, 5)

	copy(b, a) // 把 a 的元素 复制 b，b 的 len 是 5 , a 是 3,所以 a 的元素不够，剩余的元素不变，这里 int 型没有赋值是 0

	fmt.Println(b) // [1,2,3,0,0]
}
```

```
func main() {
	a := []int{1, 2, 3}
	b := []int{10, 11, 12, 13, 14}

	copy(b, a)

	fmt.Println(b) // [1,2,3,13,14]
}
```

### delete

```
// The delete built-in function deletes the element with the specified key
// (m[key]) from the map. If m is nil or there is no such element, delete
// is a no-op.
func delete(m map[Type]Type1, key Type)
```

可以看到这个函数用于根据 key 删除 map 的 element。

```
func main() {
	a := map[int]string{1: "ha", 2: "Sdf", 3: "gweg"}
	fmt.Println(a) //map[1:ha 2:Sdf 3:gweg]
	delete(a, 1)
	fmt.Println(a) // map[2:Sdf 3:gweg]
}
```

可以看到成功删除成功，根据注释，可以知道当 map 为 nil，即没有给 map 赋值时，或者 key 不存在，那么什么也不做

```
func main() {
	a := map[int]string{1: "ha", 2: "Sdf", 3: "gweg"}
	fmt.Println(a) //map[1:ha 2:Sdf 3:gweg]

	delete(a, 0)   // key not exits
	fmt.Println(a) //map[1:ha 2:Sdf 3:gweg]
}
```

```
func main() {
	a := make(map[int]string)
	fmt.Println(a) // map[]

	delete(a, 0)   // map nil  (equal key not exits)
	fmt.Println(a) // map[]
}
```

### len/cap



### make/new



### close





### panic/recover



### prinln/print

这是两个很少用的 func，但是既然出现了我们还是来看一下吧

```
// The print built-in function formats its arguments in an
// implementation-specific way and writes the result to standard error.
// Print is useful for bootstrapping and debugging; it is not guaranteed
// to stay in the language.
func print(args ...Type)
```

可以看到，print 函数输出 stderr, 不像 fmt 包中 print 输出 stdout，在一些对这些有高亮显示的就能区分。同样 print 主要用于自举和 debug，而且还不一定保证以后不会去掉。

```
// The println built-in function formats its arguments in an
// implementation-specific way and writes the result to standard error.
// Spaces are always added between arguments and a newline is appended.
// Println is useful for bootstrapping and debugging; it is not guaranteed
// to stay in the language.
func println(args ...Type)
```

而 println 比 print 就是多了个在参数和新行后加空格，这些设计肯定是有其原因的，但是一般的开发者也用不了。这里简单的用代码讲解一下，以后该用 fmt 包就老老实实的用 fmt 包

```
func main() {
	a := struct{}{}

	print(a) // illegal types for operand: print

	b := [10]int{}
	print(b) // illegal types for operand: print
}
```

我们发现这两个参数不能打印 struct 和 slice

```
func main() {
	a := []int{}

	println(a) // [0/0]0xc00003c778

	print(errors.New("sdf")) // (0x48a7c0,0xc00003c768)
}
```

然后打印组合型的参数时，打印底层的地址，而 fmt 包中的函数则打印 value。

总之，这两个函数是个特殊的函数，一般也用不上，了解下就行了。 

### error







## 参考

[基本类型和它们的字面量表示](https://gfw.go101.org/article/basic-types-and-value-literals.html)

[Difference between fmt.Println() and println() in Go](https://stackoverflow.com/questions/14680255/difference-between-fmt-println-and-println-in-go)

[example for the go pkg's function](https://github.com/astaxie/gopkg)

[Golang 中 fmt.Println 和直接 println 有什么区别](https://www.zhihu.com/question/335186436)

