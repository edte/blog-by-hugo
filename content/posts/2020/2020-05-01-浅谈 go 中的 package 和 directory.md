---
title: 浅谈 go 中的 package 和 directory
author: "edte"
categories: ["go"]
date: 2020-05-01
---


## 几个 概念

* project: project 即项目，这是最大的单位
* package: package 即包，包是程序的概念，程序又不同的包组成
* directory: directory 即文件夹，里面可以放文件  file
* file: file 即文件，一般加后缀的那个就是了，如 main.go
* func: func 即函数，编程的基本单位，在 file里

## file 名什么影响也没有

我们建立

```
└── dd 
    └── ff.go
```

自然 file 的名字和 directory 没有任何关系，如果我们在 ff.go 中

```
package pp
```

表示 ff.go 文件位于 pp package 中，这没有任何问题， 把 pp 任意改为其他，也没有 error, 

这说明 file 的名字和 directory, package 等都没有任何关系，可以随便建


## package 和 directory 名没有关系

```
└── dd 
    └── ff.go
```

directory 名叫 dd, 而 file 名叫 ff.go, 在 ff.go 中, 代码如下

```
package pp
```

并没有报错，这说明此 package 被命名为 pp , 但是 directory 名是 dd，说明 package 和 directory 名没有关系

我们可以在此 director 下多建几个文件试试

```
└── dd 
    └── ff.go
    └── ff1.go
```

在 ff1.go 中我们同样写代码如下

```
package pp
```

同样没有表错，说明 package 和 directory 名没有关系

## 一个 directory 下只能有一个 package

刚刚我们建立了 

```
└── dd 
    └── ff.go
    └── ff1.go
```

ff.go 里

```
package pp
```

ff1.go 里

```
package pp
```

这并没有报错，当如果我们把 ff1.go 里改为

```
package pp1
```

我们会得到一个 error ` Multiple packages in directory: pp, pp1`

这说明同一个 directory 下的所有文件必须是同一个 package, 即 一个 directory 下只能有一个 package

##  import package 的 path 是 directory 名

我们建立

```
└── main.go
└── dd 
    └── ff.go
```

在 ff.go 中

```
package pp

type Haha struct {
	a int
	b string
}
```

在 main.go 中

```
package main
```

现在要在 main.go 中，也就是在 main package 中引用 pp  package 的 Haha 类型， 需要 import pp package,

在 main.go 中使用 Haha 时，会自动 import，我们发现

```
import (
	"projectName/dd"
)
```

然后使用 Haha 时是 dd.Haha ，dd 是 package 所在 directory 的名字，那我们可以猜测导包时导入的是 package 所在的 directroy 名，而不是 package 名，现在我们验证一下。

把 dd 改为 dd1 ，我们发现

```
import (
	"projectName/dd1"
)
```

导包时的名字自动变为了 dd1 ，这验证了我们的猜想。实际上 import 后面是 GOPATH 的相对路径。

同时如果我们把 Haha 改为 haha, 即首字母小写，我们发现 main package 是无法使用 pp package 中的 haha struct 的。同时如果我们细心一点，就会发现平时不同 package 间引用时，type 或 func 都是需要大写的。如常见的`fmt.Println`

这里如果我们反过来，把 Haha strict 放在 main.go 中，即 main package 中，我们会发现无论是否大小，在其他 package ，如这里的 pp package  中还是无法使用。我们知道 在 main package 要使用其他 package 里声明的东西需要 import 其他 package，这里也说明其他 package 是无法使用 main 包里声明的东西，

故 main package 一般都建议代码量够少，同时一个 project 里如果有多个 main package，不同 main package 想要使用对方

声明的东西也是不行的。

## 不同 directory 下的 同名 package 是不同的 package

 即一个 package 只能位于一个 directory 中，从上面我们知道使用其他 package 里的东西时需要 import。

我们建立

```
└── dd 
    └── ff.go
└── cc 
    └── mm.go
└── main.go
```

ff.go 里

```
package pp

type Dd_s struct{
}
```

mm.go 里

```
package pp

type Cc_s struct{
}
```

现在我们建立了分别在 dd 和 cc  directory 里建立了 pp package，现在我们要在 main.go 里调用它们

我们先调用 dd 里的 Dd_s

```
package main

import "projectName/dd"

func main() {
	a := pp.Dd_s{}
}
```

然后我们再调用 cc 里的 Cc_s

```
package main

import (
	pp  "projectName/dd"
	pp2 "projectName/cc"
)

func main() {
	a := pp1.Dd_s{}
	b := pp2.Cc_s{}
}
```

我们会发现调用第二个 pp package 时， import 会自动给它们 alias, 不光 import package 时 import 的是 directory name，这里进一步说明 不同 directory 里的同名package 是不同的package

上面我们 的 directory 都是平行的，其实子目录和父目录也是不同的包

## 一个 project 至少有一个 main package

换句话说可以有多个 main package

我们建立

```
└── dd 
    └── ff.go
```

在 ff.go 里

```
package pp

func s () {

}
```

即在 非 main 里没有 main func, 然后 run 我们会发现抱 error `Main file has non-main package or doesn't contain main function`, 然后我们把 ff.go  改为

```
package pp

func main() {
	fmt.Printfln("Hello World!")
}
```

我们 run  一下，同样抱 error `Main file has non-main package or doesn't contain main function`

现在我们又改

```
package main

func s() {
	fmt.Println("Hello World!")
}
```

又报 error `Main file has non-main package or doesn't contain main function`

我们再改

```
package main

func main() {
	fmt.Println("Hello world")
}
```

现在成功了，我们根据上面可以得出 build and run 的结论，即只有 main package 含有一个 main func 时，才可以 run

我们知道不同 directory 都是不同的 package, 那我们多建个 main package 试试

```
└── dd 
    └── ff.go
└── cc 
    └── mm.go
```

ff.go

```
package main

func main() {
	fmt.Println("Hello dd!")
}
```

mm.go

```
package main

func main() {
	fmt.Println(Hello cc!)
}
```

我们分别 run ff.go和 mm.go， 我们发现都是成功的，现在我们可以发现一个 project 可以有多个 main package ，而且它们 run 都是分开的，当然如果 project 里没有  main package 的话，那 project 就不能 run 了，这是自然的。



## 一个 package 最多只能有一个 main 函数

无论是一个 package 中 不同 file 里

```
└── dd 
    └── ff.go
    └── ff1.go
```

ff.go

```
func main {
	fmt.Println("Hello ff!")
}
```

ff1.go

```
func main {
	fmt.Println("Hello ff1!")
}
```

会报 error `contains more than one main function`



还是 一个 package  里一个 file 里

```
func main {
	fmt.Println("Hello ff1!")
}

func main {
	fmt.Println("Hello ff1!")
}
```

报 error `'main' redeclared in this package`







## 总结

* 在一个 project  中
* 至少有一个 main package，可以有多个 main package，
* build and run 时是先找到 main package, 然后找到这个 main package 中的 main func，然后开始 build，故一个 project 中可以 run 不同的 main package
* 在 一个 main package 中，只能有一个 main func, 当然可以没有 main func ，不过那样的话其他 package 又不能 使用 main package 里的东西，这个 main package 没有 main func, 这个 package 也就不能 build, 那这个 package  显然没有用处

* 在一个 directory 中都是一个 package ，并且他们的名字没有关系，只要 一个 directory 里只有一个 package 就行
* 虽然 directory name 和 package name 没有关系，但是一般建议 directory name 和 package name 取成一样的，不然的话容易弄混
* 不同 directory 里取相同名的 package, 这些 package 是不同的 package， 如果要同时使用这两个 package 里的内容， import 的时候需要 alias pakcage name

* 一般项目结构就是 一个 project 里，只要一个 main package, 然后里面一个 main file，一个 main func, 这就是 project 的启动文件，然后各自建立 directory , dirctory name 即 package name， 然后在 direcory 里建立不同 的file，file name 表明这个 file 里主要干些什么