---
title: 谈谈 Golang 中接口 interface 的应用
author: "edte"
categories: ["Goland"]
date: 2020-05-03
---



## interface 是什么

在讲解 interface 是什么之前，先让我们了解这个名词：  `duck typing`，翻译成中文就是 鸭子类型。我们来看 wiki 是怎样说明的：

>**鸭子类型**（英语： **duck typing** ）在[程序设计](https://zh.wikipedia.org/wiki/程序设计)中是[动态类型](https://zh.wikipedia.org/wiki/類型系統)的一种风格。在这种风格中，一个对象有效的语义，不是由继承自特定的类或实现特定的接口，而是由 " 当前[方法](https://zh.wikipedia.org/wiki/方法_(電腦科學))和属性的集合 " 决定。

换句话说，我们可以这样理解，鸭子类型是一种动态类型的风格，在这种类型中，我们只关注它们的方法，而不关注它们实际的数据类型。只要它们的方法相同，那么就是鸭子类型。

wiki 是这样解释的：

> 在鸭子类型中，关注点在于对象的行为，能作什么；而不是关注对象所属的类型。

而这种特性也是 鸭子类型的名字来源

> “当看到一只鸟走起来像鸭子、游泳起来像鸭子、叫起来也像鸭子，那么这只鸟就可以被称为鸭子。”

光是文字难以理解，我们来看代码：

```
package main

import "fmt"

type Animal interface {
	speak()
}

type person struct {
}

func (p person) speak() {
	fmt.Println("I'm a man")
}

type dog struct {
}

func (d dog) speak() {
	fmt.Println("I'm a dog")
}

// 看这里，我们传入了一个接口变量
func Speak(animal Animal) {
	animal.speak()
}

func main() {
	// 实例一个Animal 接口
	var animal Animal

	// 这里和下面为什么能够直接赋值，等会再讲
	animal = person{}
	Speak(animal)

	animal = dog{}
	Speak(animal)
}
```

运行结果：

```
I'm a man
I'm a dog
```

我们重点看两处调用 Speak() 的地方，我们分别传入 person{} 和 dog{}, 它们的类型显然是不同的，但是它们都使用了 speak() 方法，如果我们把 person 的 speak 方法注释掉，显然 传入 person 时是无法使用 speak 方法的。这里就已经比较清楚的表明 interface 是 duck typing 了。什么，你还是无法理解？你看, person 和 dog 类型不同，但它们都能够使用 speak 方法，这就已经符合 duck typing 的定义了。当然，你还无法理解，为什么是 struct 实现方法，却表明 interface 的属性，也无法理解为何 dog 和 person 能够直接赋值给 animal, 请继续看。

> 这里拓展一下， duck typing 一般是动态语言中才会出现，如 python, 为什么 Golang 能够使用？请自行了解。

现在我们已经明白了 duck typing 这种类型了，显然 interface 就是 duck typing 了，那么我们可以知道， interface 是 Golang 中具有 duck typing 类型的一种数据类型。

## interface 的属性

### interface 是 一组方法 (method) 的集合

### interface 是一种数据类型

### interface 描述方法，而不实现方法
