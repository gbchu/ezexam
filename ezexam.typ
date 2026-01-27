#import "lib/tools.typ": draft, page-restart, tag, text-figure, zh-arabic
#import "lib/outline.typ": *
#import "lib/choice.typ": choices
#import "lib/question.typ": question
#import "lib/paren-fillin.typ": fillin, fillinn, paren, parenn

#let setup(
  mode: HANDOUTS,
  paper: a4,
  page-numbering: auto,
  page-align: center,
  gap: 1in,
  show-gap-line: false,
  footer-is-separate: true,
  outline-page-numbering: "I",
  font: roman,
  font-size: 11pt,
  line-height: 2em,
  par-spacing: 2em,
  first-line-indent: 0em,
  heading-numbering: auto,
  heading-hanging-indent: auto,
  h1-size: auto,
  heading-font: heiti,
  heading-color: luma(0),
  heading-top: 10pt,
  heading-bottom: 15pt,
  enum-numbering: "（1.i.a）",
  enum-spacing: 2em,
  enum-indent: 0pt,
  resume: true,
  watermark: none,
  watermark-color: rgb("#f666"),
  watermark-font: roman,
  watermark-size: 88pt,
  watermark-rotate: -45deg,
  show-answer: false,
  answer-color: blue,
  show-seal-line: true,
  seal-line-student-info: (
    姓名: underline[~~~~~~~~~~~~~],
    准考证号: table(
      columns: 14,
      inset: .8em,
      [],
    ),
    考场号: table(
      columns: 2,
      inset: .8em,
      [],
    ),
    座位号: table(
      columns: 2,
      inset: .8em,
      [],
    ),
  ),
  seal-line-type: "dashed",
  seal-line-decoration: none,
  seal-line-supplement: "弥封线内不得答题",
  doc,
) = {
  assert(mode in (HANDOUTS, EXAM, SOLUTION), message: "mode expected HANDOUTS, EXAM, SOLUTION")
  assert(
    type(font) == array and type(heading-font) == array,
    message: "font must be an array",
  )
  mode-state.update(mode)
  paper = a4 + paper
  // 页码的正则：包含两个1,两个1中间不能是连续空格、包含数字
  // 支持双：阿拉伯数字、小写、大写罗马，带圈数字页码
  let _reg = "^\D*1\D*[^\d\s]\D*1\D*$|^\D*i\D*[^\d\s]\D*i\D*$|^\D*I\D*[^\d\s]\D*I\D*$|^\D*①\D*[^\d\s]\D*①\D*$|^\D*⓵\D*[^\d\s]\D*⓵\D*$"
  let _matcher = regex(_reg)
  import "lib/tools.typ": _seal-line

  let _footer(label, hide-seal-line: false) = context {
    assert(
      type(label) in (str, function, none),
      message: "page-numbering expected str, function, none found" + str(type(label)),
    )
    if label == none { return }
    let _mode = mode-state.get()
    if label == auto {
      _label = "1 / 1"
      if _mode != HANDOUTS {
        _label = zh-arabic(prefix: [#subject-state.get()#if _mode == SOLUTION [参考答案] else [试题]])
      }
    }

    let current = counter(page).get()
    let final = counter(page).final()

    let chapter-first-last-pages = chapter-pages-state.final()
    // 没有添加任何标题时，默认添加一个页码，否则没有添加页码时会报错
    if chapter-first-last-pages == () { chapter-first-last-pages.push((1, ..final * 2)) }
    if chapter-first-last-pages.last().len() == 1 {
      chapter-first-last-pages.last() += (..final * 2,)
    }
    let (first, last, ..total-pages) = chapter-first-last-pages.at(counter("title").get().first() - 1)
    if (type(_label) == function or _matcher in _label) { current += total-pages }

    let _numbering = numbering(_label, ..current)
    // 处于分栏下且左右页脚分离
    if page.columns == 2 and footer-is-separate {
      current.first() += 1
      grid(
        columns: (1fr, 1fr),
        align: center + horizon,
        // 左页码
        _numbering,
        // 右页码
        numbering(_label, ..current),
      )
      counter(page).step()
    } else {
      // 页面的页脚是未分离, 则让奇数页在右侧，偶数页在左侧
      let position = page-align
      if not footer-is-separate {
        position = if calc.odd(current.first()) { right } else { left }
      }
      align(position, _numbering)
    }

    if _mode != EXAM or not show-seal-line or hide-seal-line { return }
    _seal-line(
      seal-line-student-info,
      seal-line-type,
      seal-line-supplement,
      footer-is-separate,
      current.first(),
      first,
      last,
      seal-line-decoration,
    )
  }
  let _background() = {
    if paper.columns > 1 and show-gap-line {
      line(angle: 90deg, length: 100% - paper.margin * 2, stroke: .5pt)
    }
  }
  let _foreground() = {
    if watermark == none { return }
    set text(size: watermark-size, watermark-color)
    set par(leading: .5em)
    place(horizon, grid(
      columns: paper.columns * (1fr,),
      ..paper.columns * (rotate(watermark-rotate, watermark),),
    ))
  }

  set page(
    ..paper,
    footer: _footer(page-numbering),
    background: _background(),
    foreground: _foreground(),
  )
  set columns(gutter: gap)
  set outline(
    target: if mode == EXAM { <chapter> } else { heading },
    title: text(size: 1.5em)[目#h(1em)录],
  )
  show outline: it => {
    set page(footer: _footer(outline-page-numbering, hide-seal-line: true))
    align(center, it)
    pagebreak(weak: true)
    counter(page).update(1)
  }

  set par(leading: line-height, spacing: par-spacing, first-line-indent: (amount: first-line-indent, all: true))
  set text(font: font, size: font-size)

  if heading-numbering == auto {
    if mode in (EXAM, SOLUTION) {
      heading-numbering = (..item) => numbering("一、", ..item) + h(-0.3em)
      heading-hanging-indent = 2em
    } else { heading-numbering = "1.1.1.1.1 " }
  }
  set heading(numbering: heading-numbering, hanging-indent: heading-hanging-indent)
  show heading: it => {
    set par(leading: 1.3em)
    v(heading-top)
    text(heading-color, font: font.slice(0, -1) + heading-font, it)
    v(heading-bottom)
    if not resume { counter("question").update(0) }
  }
  show heading.where(level: 1): it => {
    let size = h1-size
    if size == auto {
      if mode == HANDOUTS { size = 1em } else { size = 10.5pt }
    }
    text(size: size, it)
  }
  // 试卷模式下，书签只显示章节
  set heading(bookmarked: false) if mode == EXAM
  show heading.where(level: 1).and(<chapter>): set heading(bookmarked: true)

  set enum(numbering: enum-numbering, spacing: enum-spacing, indent: enum-indent)
  set table.cell(align: horizon + center, stroke: .5pt)

  // 分段函数样式
  set math.cases(gap: 1em)
  // 显示方程编号
  set math.equation(numbering: "（1）", supplement: [Eq -]) if mode == HANDOUTS
  show math.equation: it => {
    // features: 一些特殊符号的设置，如空集符号设置更加漂亮
    set text(font: font, features: ("cv01",))
    //  1. 行内样式默认块级显示样式; 2. 添加数学符号和中文之间间距
    let space = h(.25em, weak: true)
    space + math.display(it) + space
  }
  //  π 在 "TeX Gyre Termes Math" 下显示的样式；默认的丑
  show math.pi: it => {
    if "TeX Gyre Termes Math" in font {
      return text(font: "Times New Roman", "π")
    }
    it
  }
  show math.parallel: "//"

  // 中文着重号
  show strong: content => {
    show regex("\p{Hani}"): it => box(place(text("·", size: 0.8em), dx: 0.45em, dy: 0.75em) + it)
    content.body
  }

  if show-answer {
    answer-state.update(true)
    answer-color-state.update(answer-color)
  }

  doc
}
