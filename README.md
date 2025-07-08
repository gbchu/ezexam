# `ezexam`
## 简介
`A typst test paper and lecture notes template inspired by the LaTeX package exam-zh.`

## 使用说明
 1. **在线使用**

     + 打开[TypstApp](https://typst.app/)在线网站并新建项目

     + 导入模板：`#import "@preview/ezexam:0.1.1": *`

     + 调用方法：`#show: setup.with(mode: EXAM)`

 2. **本地使用**

     + 下载 `vscode` 并安装 `typst` 插件 `tinymist`

     + 导入模板：`#import "@preview/ezexam:0.1.1": *`

     + 调用方法：`#show: setup.with(mode: EXAM)`

## 方法及参数说明
### `setup方法`

>*该方法用于全局参数的设置,需配合`#show 和 with 方法使用`*

#### **参数及其默认值**

`mode`

`type: str`
`default: LECTURE`
`optional value: EXAM`

>*该参数用于设置模板的显示模式 `LECTURE`: 讲义模式； `EXAM` : 试卷模式 `LECTURE` 模式和 `EXAM` 模式二者仅在题号的显示方式和目录显示方式上有所不同。`LECTURE` 模式仅符合个人喜好，若你只想组卷则只用`EXAM` 模式即可！*

`paper`

`type: dictionary`
`default: a4`
`optional value: a3`

>*该参数用于设置模板的页面大小、边距、是否翻转、是否分页*

```typst
    a3 和 a4 的默认值

    #let a3 = (
      paper: "a3",
      margin: 1in,
      columns: 2,
      flipped: true,
    )

    #let a4 = (
      paper: "a4",
      margin: 1in,
      columns: 1,
      flipped: false,
    )
```
> *`a3` 和 `a4` 是内部自定义的两个变量，若需要自定义页面大小，则需要使用字典覆盖默认值，格式如上所示。例如：在调用`setup`方法时`paper`参数使用`( paper: "b5", margin: .5in, columns: 2, flipped: true,)`而非定义好的`a3` 或 `a4`*

> 注：修改该参数可能会导致页面布局混乱，仅在a3 和 a4 尺寸下测试过

`page-numbering`

`type: str | function`
`default: auto`

>*该参数用于设置模板的页码显示方式*
>
>`EXAM`模式下默认显示为: `XX试题  第X页（共X页）`
>
>`LECTURE`模式下默认显示为: `X / X`
>
> 若要修改显示格式可参考官方文档 [numbering](https://typst.app/docs/reference/model/numbering/) 的参数设置

`page-align`

`type: alignment`
`default: center`

>该参数用于设置模板的页码对齐方式
>
> 若要修改对齐方式可参考官方文档 [alignment](https://typst.app/docs/reference/layout/alignment/) 的参数设置

`footer-is-separate`

`type: boolean`
`default: true`

>*该参数用于设置在页面多列显示时，页脚的页码是否在每一列中都显示*

`outline-page-numbering`

`type: str | function`
`default: ⚜ I ⚜`

>*该参数用于设置目录的页码显示*
>
> 若要修改显示格式可参考官方文档
> [numbering](https://typst.app/docs/reference/model/numbering/) 的参数设置

`gap`

`type: length`
`default: 1in`

>*该参数用于设置多列显示时，列之间的间距*

`show-gap-line`

`type: boolean`
`default: false`

>*该参数用于设置多列显示时，列之间是否显示分隔线*

`font-size`

`type: length`
`default: 11pt`

>*该参数用于设置页面字体大小*

`font`

`type: str | array`
`default:("New Computer Modern Math", "Source Han Serif")`

>*该参数用于设置页面的字体*

>注： 由于宋体不支持加粗，故本包在设置字体时使用的是思源宋体；在使用本包时，请自行下载 [思源宋体](https://github.com/adobe-fonts/source-han-serif/releases) 并安装。或者使用第三方 [粗体包](https://typst.app/universe/package/cuti)

`font-math`

`type: str | array`
`default:("New Computer Modern Math", "Source Han Serif")`

>*该参数用于设置数学公式下的字体*

`line-height`

`type: length`
`default:2em`

>*该参数用于设置行高*

`par-spacing`

`type: length`
`default:2em`

>*该参数用于设置段落间距*

`first-line-indent`

`type: length`
`default:2em`

>*该参数用于设置首行缩进*

`heading-font`

`type: str | array`
`default:("New Computer Modern Math", "SimHei")`

>*该参数用于设置节标题的字体*

`heading-size`

`type: length`
`default:10.5pt`

>*该参数用于设置节标题的字体大小*

`heading-color`

`type: color`
`default: black`

>*该参数用于设置节标题的字体颜色*

`heading-top`

`type: length`
`default: 10pt`

>*该参数用于设置节标题的上间距*

`heading-bottom`

`type: length`
`default: 15pt`

>*该参数用于设置节标题的下间距*

`show-answer`

`type: boolean`
`default: false`

>*该参数用于设置是否显示答案*

`answer-color`

`type: color`
`default: blue`

>*该参数用于设置答案的颜色*

`show-seal-line`

`type: boolean`
`default: true`

>*该参数用于设置是否显示弥封线*

`seal-line-student-info`

`type: dictionary`
`default: (
    姓名: underline[~~~~~~~~~~~~~],
    准考证号: inline-square(14),
    考场号: inline-square(2),
    座位号: inline-square(2),
  )`

>*该参数用于设置考生信息*

`seal-line-type`

`type: str | none | auo | array | dictionary`
`default: dashed`

>*该参数用于设置弥封线的样式*
>
> 此设置的可选值参考官方文档 [线的类型](https://typst.app/docs/reference/visualize/stroke/#constructor-dash)

`seal-line-supplement`

`type: str`
`default: 弥封线内不得答题`

>*该参数用于设置弥封线的补充信息*

### `chapter方法`

>*该方法用于设置章节标题，此标题不会显示在文章中，只会出现在目录中，若不需要显示目录可忽略此方法*

> 注：若想在同一个文档中组多套试卷，则必须要在开始之前执行此方法！！！该方法会使得问题的题号清0，标题编号清0，新的章节新的开始。

### `title方法`

#### **参数及其默认值**

`font`

`type: str | dictionary`
`default: ("New Computer Modern Math", "Source Han Serif")`

>*该参数用于设置标题的字体*

`size`

`type: length`
`default: 15pt`

>*该参数用于设置标题字体的大小*

`weight`

`type: int | str`
`default: bold`

>*该参数用于设置标题字体的粗细*

`position`

`type: alignment`
`default: center`

>*该参数用于设置标题的对齐方式*

`top`

`type: length`
`default: 0pt`

>*该参数用于设置标题的上间距*

`bottom`

`type: length`
`default: 18pt`

>*该参数用于设置标题的下间距*

### `subject方法`

#### **参数及其默认值**

`font`

`type: str | dictionary`
`default: ("New Computer Modern Math", "simhei")`

>*该参数用于设置科目的字体*

`size`

`type: length`
`default: 21.5pt`

>*该参数用于设置科目字体的大小*

`spacing`

`type: length`
`default: 1em`

>*该参数用于设置科目每个字之间的间距*

`top`

`type: length`
`default: 0pt`

>*该参数用于设置科目的上间距*

`bottom`

`type: length`
`default: 18pt`

>*该参数用于设置科目的下间距*

### `secret方法`

`type: str | content`
`default: 绝密★启用前`

>*该参数用于设置密级，位置默认在左上角*

### `exam-type方法`
#### **参数及其默认值**

`prefix`

`type: str | content`
`default: 试卷类型:`

>*该参数用于设置密级，位置默认在右上角*

### `exam-info方法`
#### **参数及其默认值**

`info`

`type: dictionary`
`default: (
    时间: "120分钟",
    满分: "150分",
  )`

`font`

`type: str | dictionary`
`default: ("New Computer Modern Math", "simhei")`

>*该参数用于设置字体*

`size`

`type: length`
`default: 11pt`

>*该参数用于设置字体的大小*

`weight`

`type: int | str`
`default: bold`

>*该参数用于设置字体的粗细*

`gap`

`type: length`
`default: 2em`

>*该参数用于设置信息之间的间距*

`top`

`type: length`
`default: 0pt`

>*该参数用于设置上间距*

`bottom`

`type: length`
`default: 0pt`

>*该参数用于设置下间距*

### `scoring-box方法`
#### **参数及其默认值**

`x`

`type: length`
`default: 0pt`
>*该参数用于设置水平方向上的偏移*

`y`

`type: length`
`default: 0pt`

>*该参数用于设置竖直方向上的偏移*

### `score-box方法`
#### **参数及其默认值**

`x`

`type: length`
`default: 0pt`
>*该参数用于设置水平方向上的偏移*

`y`

`type: length`
`default: 0pt`

>*该参数用于设置竖直方向上的偏移*

### `notice方法`
>该方法接收可变参数


### `zh-arabic方法`
>该方法返回一个函数，用来设置页面页码的格式
>
>格式为：`"XX  第X页（共XX页）"`
#### **参数及其默认值**

`prefix`

`type: str`
`default: ""`
>*该参数用于设置页码的前缀*

`suffix`

`type: str`
`default: 试题`

>*该参数用于设置页码的后缀*

```typst
  例如：
  zh-arabic("SSS", "试题")
  输出： SSS科目试题 第X页（共XX页）
```

### `inline-square方法`
>该方法生成行内排列的小方格，用于弥封线内准考证号，座位号，考号的占位

#### **参数及其默认值**

`width`

`type: length`
`default: 1.5em`
>*该参数用于设置小方格的宽度*

`gap`

`type: length`
`default: 0pt`

>*该参数用于设置小方格间的间距*

`body`

`type: str | content`
`default: ""`

>*该参数用于设置小方格内的文字内容*

### `draft方法`
>该方法生成草稿纸

#### **参数及其默认值**

`name`

`type: str`
`default: 草稿纸`
>*该参数用于设置小草稿纸的标题*

`student-info`

`type: dictionary`
`default: (
    姓名: underline[~~~~~~~~~~~~~],
    准考证号: underline[~~~~~~~~~~~~~~~~~~~~~~~~~~],
    考场号: underline[~~~~~~~],
    座位号: underline[~~~~~~~],
  )`

>*该参数用于设置考生信息*

`dash`

`type: str`
`default: solid`

>*该参数用于设置草稿纸下的横线样式*

`supplement`

`type: str | none | auo | array | dictionary`
`default: ""`

>*该参数用于设置草稿纸的补充内容*
>
> 此设置的可选值参考官方文档 [线的类型](https://typst.app/docs/reference/visualize/stroke/#constructor-dash)

### `choices方法`
>该方法为选择题的选项排列

#### **参数及其默认值**

`column`

`type: int | auto`
`default: auto`
>*该参数用于设置选项排列的列数,如未指定列数，则默认根据内容自动排列*

`c-gap`

`type: length`
`default: 0pt`
>*该参数用于设置选项之间的水平间距*

`r-gap`

`type: length`
`default: 25pt`
>*该参数用于设置选项之间的垂直间距*

`indent`

`type: length`
`default: 0pt`
>*该参数用于设置选项的缩进*

`body-indent`

`type: length`
`default: 5pt`
>*该参数用于设置选项和标签$ABCD$之间的距离*

`top`

`type: length`
`default: 0pt`
>*该参数用于设置选项距离上方的距离*

`bottom`

`type: length`
`default: 0pt`
>*该参数用于设置选项距离下方的距离*

`label`

`type: str`
`default: A.`
>*该参数用于设置选项的标签类型*
>
> 若要修改标签类型，可参考官方文档 [numbering](https://typst.app/docs/reference/model/numbering/) 的参数设置

`options`

>*该参数为可变参数*

### `question方法`
#### **参数及其默认值**

`body-indent`

`type: length`
`default: 0.6em`
>*该参数用于设置题目和题号间的间隔*

`indent`

`type: length`
`default: 0pt`
>*该参数用于设置题目的缩进*

`line-height`

`type: length`
`default: auto`
>*该参数用于设置题目的行高，当题目中的公式比较高时，题号和题目会错位，这时可以通过该参数来微调。*

`label`

`type: str | function`
`default: auto`
>*该参数用于设置题号的类型*
>
> 若要修改题号类型，可参考官方文档 [numbering](https://typst.app/docs/reference/model/numbering/) 的参数设置

`label-color`

`type: color`
`default: black`
>*该参数用于设置题号的颜色*

`label-weight`

`type: str | int`
`default: regular`
>*该参数用于设置题号字体的粗细*

`points`

`type: none | int`
`default: none`
>*该参数用于设置题目的分值*

`points-separate-par`

`type: boolean`
`default: true`
>*该参数用于设置题目的分值是否独占一行*

`points-prefix`

`type: str`
`default: " ("`
>*该参数用于设置题目分值前缀*

`points-suffix`

`type: str`
`default: "分）"`
>*该参数用于设置题目的分值后缀*

`top`

`type: length`
`default: 0pt`
>*该参数用于设置题目距离上方的距离*

`bottom`

`type: length`
`default: 0pt`
>*该参数用于设置题目距离下方的距离*

`with-heading-label`

`type: none | boolean`
`default: none`
>*该参数用于设置题目是否带有标题的标签*

`body`

`type: content`
>*该参数为位置参数，题目的内容*


