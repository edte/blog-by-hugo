---
title: GoLand ideavim
author: "edte"
tags: ["GoLand","快捷键"]
categories: ["快捷键"]
date: 2020-03-25
---



# 快捷键


## 移动光标
| ide                                                     | ideavim        |                         介绍                         |
| :------------------------------------------------------ | -------------- | :--------------------------------------------------: |
|                                                         | h/l/j/k        |                                                      |
|                                                         | w              |         前移一个单词，光标停在下一个单词开头         |
|                                                         | e              |         前移一个单词，光标停在下一个单词末尾         |
|                                                         | b              |         后移一个单词，光标停在上一个单词开头         |
| HOME                                                    | 0              |                      移动到行首                      |
| END                                                     | $              |                      移动到行尾                      |
|                                                         | ^              |              移动到本行第一个非空白字符              |
|                                                         | Ctrl + M/enter |              移动到下一行的首个非空字符              |
|                                                         | H              |               把光标移到屏幕最顶端一行               |
|                                                         | M              |                把光标移到屏幕中间一行                |
|                                                         | L              |               把光标移到屏幕最底端一行               |
|                                                         | Ctrl U         |                      向上翻半屏                      |
|                                                         | Ctrl D         |                      向下翻半屏                      |
| Ctrl + End                                              | G              |                 跳到文件尾`（必备）`                 |
| Ctrl + Home                                             | gg             |                 跳到文件头`（必备）`                 |
| <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>Enter</kbd>     |                |   光标所在行上空出一行，光标定位到新行 `（必备）`    |
| <kbd>Shift</kbd> + <kbd>Enter</kbd>                     |                | 开始新一行。光标所在行下空出一行，光标定位到新行位置 |
| <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>前方向键</kbd> |                |          移动光标所在行向上移动 `（必备）`           |
| <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>后方向键</kbd> |                |          移动光标所在行向下移动 `（必备）`           |



   



## 插入

| ide  | ideavim | 介绍 |
| :----------- | ------------ | :------ |
|  | i | 在光标前插入 |
|         | a | 在光标后插入 |
|         | I | 在当前行第一个非空字符前插入 |
|         | gI | 在当前行第一列插入 |
|         | A | 在当前行最后插入 |
|         | o | 在下面新建一行插入 |
| | O | 在上面新建一行插入 |
|      | Ctrl C | 退出插入模式/ESC |







## 复制/粘贴/剪切/查找/替换


| ide| ideavim | 介绍     |
| :----------- | ------------ | :------ |
| delete | x |                                                              |
| back | X |  |
| | yy | 复制光标所在行 |
| Ctrl + x | dd | 剪切光标所在行 |
| Ctrl + D |  | 复写当前行 |
| | v | 进入字符可视化模式 |
| | V | 进入行可视化模式 |
| | x/d | (可视化模式)剪切选择内容 |
| | y | (可视模式) 复制选择内容 |
| | u | (可视模式) 所有字母变小写 |
| | U | (可视模式) 所有字母变大写 |
| Ctrl A |  | 全选 |
|                                       | /            | 在当前文件进行文本查找                                       |
| | n | 向后查找下一个 |
| | N | 向前查找下一个 |
|                                       | :%s/old/new | 在当前文件进行文本替换                                       |
| Ctrl+Z | u            | 撤销                                                         |
| Ctrl+shift+Z | Ctrl + R     | 取消撤销      |
|                                       | P           | 在光标之前粘贴                                               |
|                                       | p            | 在光标之后粘贴                                                  |
|                                       | >> |此行缩进一个 Tab|
| | << |此行取消缩进一个 Tab|







## 其他

| ide  | ideavim | 介绍 |
| :----------- | ------------ | :------ |
| <kbd>Ctrl</kbd> + <kbd>W</kdb> |              | 递进式选择代码块。可选中光标所在的单词或段落，连续按会在原有选中的基础上再扩展选中范围 `（必备）` |
| <kbd>Ctrl</kbd> + <kbd>E</kdb>        |              | 显示最近打开的文件记录列表 `（必备）`                        |
| <kbd>Ctrl</kbd> + <kbd>J</kdb>        |              | 插入自定义动态代码模板 `（必备）`                            |
| <kbd>Ctrl</kbd> + <kbd>P</kdb>        |              | 方法参数提示显示 `（必备）`                                  |
|                                       | gd           | 进入光标所在的方法/变量的接口或是定义处，等效于 `Ctrl + 左键单击`  `（必备）` |
| <kbd>Ctrl</kbd> + <kbd>K</kdb>        |              | 版本控制提交项目，git commit `（必备）`                      |
| <kbd>Ctrl</kbd> + <kbd>\+</kdb>       | zo           | 展开代码`（必备）`                                           |
| <kbd>Ctrl</kbd> + <kbd>\-</kdb>       | zc           | 折叠代码`（必备）`                                           |
| <kbd>Ctrl</kbd> + <kbd>/</kdb>        |              | 注释光标所在行代码，会根据当前不同文件类型使用不同的注释符号 `（必备）` |
| <kbd>Ctrl</kbd> + <kbd>F1</kdb>       |              | 在光标所在的错误代码处显示错误信息`(必备)`                   |
| <kbd>Ctrl</kbd> + <kbd>F4</kdb>       |              | 关闭当前编辑文件`(必备)`                                     |
| <kbd>Alt</kbd> + <kbd>\`</kbd> |         | 显示版本控制常用操作菜单弹出层 `（必备）` |
| <kbd>Alt</kbd> + <kbd>Enter</kbd>     |  |IntelliJ IDEA 根据光标所在问题，提供快速修复选择，光标放在的位置不同提示的结果也不同 `（必备）`|
| <kbd>Alt</kbd> + <kbd>Insert</kbd>    |         |代码自动生成，如生成对象的 set / get 方法，构造函数，toString() 等 `（必备）`|
| <kbd>Alt</kbd> + <kbd>左方向键</kbd>  |         |切换当前已打开的窗口中的子视图，比如Debug窗口中有Output、Debugger等子视图，用此快捷键就可以在子视图中切换 `（必备）`|
| <kbd>Alt</kbd> + <kbd>右方向键</kbd>  |         |按切换当前已打开的窗口中的子视图，比如Debug窗口中有Output、Debugger等子视图，用此快捷键就可以在子视图中切换 `（必备）`|
| <kbd>Alt</kbd> + <kbd>前方向键</kbd>  |         |当前光标跳转到当前文件的前一个方法名位置 `（必备）`|
| <kbd>Alt</kbd> + <kbd>后方向键</kbd>  |         |当前光标跳转到当前文件的后一个方法名位置 `（必备）`|
| <kbd>Alt</kbd> + <kbd>1</kbd> |         |`（必备）`|
| <kbd>Shift</kbd> + <kbd>F1</kbd>  |         |如果有外部文档可以连接外部文档`（必备）`|
| <kbd>Shift</kbd> + <kbd>F2</kbd>  |         |跳转到上一个高亮错误 或 警告位置`（必备）`|
| <kbd>Shift</kbd> + <kbd>F4</kbd>  |         |对当前打开的文件，使用新Windows窗口打开，旧窗口保留`（必备）`|
| <kbd>Shift</kbd> + <kbd>F6</kbd>  |         |对文件 / 文件夹 重命名`（必备）`|
| <kbd>Shift</kbd> + <kbd>F10</kbd> |         |等效于点击工具栏的 `Run` 按钮`（必备）`|
| <kbd>Shift</kbd> + <kbd>ESC</kbd> |         |隐藏当前 或 最后一个激活的工具窗口`（必备）`|
| <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>L</kbd> |  |格式化代码，可以对当前文件和整个包目录使用 `（必备）`|
| <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>S</kbd> |         |打开 IntelliJ IDEA 系统设置 `（必备）`|
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>J</kbd> |         |自动将下一行合并到当前行末尾 `（必备）`|
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>Z</kbd> |         |取消撤销 `（必备）`|
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>W</kbd> |         |递进式取消选择代码块。可选中光标所在的单词或段落，连续按会在原有选中的基础上再扩展取消选中范围 `（必备）`|
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>T</kbd> |         |对当前类生成单元测试类，如果已经存在的单元测试类则可以进行选择 `（必备）`|
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>C</kbd> |         | 复制当前文件磁盘路径到剪贴板 `（必备）` |
| Ctrl + shift +k | | git push origin master |
| <kbd>F4</kbd>   |         | 编辑源 |
|<kbd>Tab</kbd>   |         | 缩进 `（必备）` |





# ideavim 配置文件

```bash
" set <command> 开启 vim 配置命令
" 可输入 https://github.com/JetBrains/ideavim/blob/master/doc/set-commands.md 查看 

" 设置默认进行大小写不敏感查找
set ignorecase

" 如果有一个大写字母，则切换到大小写敏感查找
set smartcase 

" 在敲键的同时搜索，按下回车把移动光标移动到匹配的词； 按下 Esc 取消搜索。
set incsearch

" 检索时高亮显示匹配项
" set hlsearch                 

" 共享系统粘贴板
set clipboard=unnamed



" 键位映射 map 命令, 在所有模式下均生效
" 可以在 http://haoxiang.org/2011/09/vim-modes-and-mappin/  查看
" 可以添加一些前缀实现不同的模式
" nore      表示非递归
" n         表示 command mode 
" i         表示 insert mode
" c         表示 last line mode
" v         表示 visual mode
" un        表示 清除映射
"
" 键位表示
" 字母: 如映射 qq 为 G, 则 nnoremap qq G, 在 command mode 下输入 qq 就输入 G
" 非字母: 如映射 ESC 为 :q, 则 nnoremap <ESC> :q ,在 command mode 下按 ESC 键就输入 :q         
" 组合键: 如映射 Ctrl + h 为 <Left>, 则 innoremap <C-h> <Left> 
" action: 
"  获取 action  
"    :actionlist
"  映射 action
"    :action  name<CR>   
"  如 映射 gt 为 GotoTest, 则 nnoremap gt action:GotoTest<CR>   ,  <CR> 表示换行
"
"
" action list : https://gist.github.com/zchee/9c78f91cc5ad771c1f5d

" insert mode 
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>



" command mode
" 弹出输入框，跳转到指定操作
nnoremap ga   :action GotoAction<CR>

" 弹出输入框，跳到指定类
nnoremap gc   :action GotoClass<CR>

" 弹出输入框, 跳转到指定文件
nnoremap gf   :action GotoFile<CR>

" 跳转到定义
nnoremap gd   :action GotoDeclaration<CR>

" Run
nnoremap r :action Run<CR>

" 移动到行首/末
nnoremap H  0
nnoremap L  $


" 移动 Tabs
nnoremap  J     :action PreviousTab<CR>
nnoremap  K     :action NextTab<CR>


" 打开 git commit 
nnoremap  <C-k>     :action GitFileActions<CR>


" 保存时候自动格式化代码
nnoremap <C-s> :action ReformatCode<CR> :w <CR>
inoremap <C-s>  <ESC>  :action ReformatCode<CR> :w <CR>

" 打开设置
nnoremap s   :action ShowSettings<CR>

" 关闭 Tab
nnoremap `  :action CloseContent<CR>

" 快速实现接口
nnoremap <C-i> :action ImplementMethods<CR>

" 快速给 struct 生成构造函数
nnoremap go   :action GoGenerateConstructorAction<CR>

" 调用函数时, 快速生成返回值, 光标要在函数后
nnoremap   gi    :action IntroduceVariable<CR>

" 快速生成返回值, 光标要在 return 后
nnoremap   gr      :action CodeCompletion<CR>

" 快速生成测试文件
nnoremap gt   :action GotoTest<CR> 

" 快速插入 live template
nnoremap <C-j>  :action   InsertLiveTemplate<CR>

" 前进/后退   移动光标
nnoremap   <      :action Back<CR>
nnoremap   >      :action Forward<CR>

```





# GoLand 与 vim 快捷键冲突设置

![](https://images.cnblogs.com/cnblogs_com/just-save/1680093/o_200325072850Screenshot_20200325_032741.png)

![](https://images.cnblogs.com/cnblogs_com/just-save/1680093/o_200325072841Screenshot_20200325_032755.png)