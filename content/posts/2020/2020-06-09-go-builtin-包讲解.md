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