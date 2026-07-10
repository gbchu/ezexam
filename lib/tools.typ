#import "config.typ": heiti
#import "const.typ": CIRCLE, TEXT
#import "counter.typ": counter-title
#import "state.typ": chapter-pages-state, page-restart-state

#let _SPECIAL-CHAR = "《（【"
// 以特殊字符，数学公式开头的行特殊处理
#let _trim-left-space(body) = {
  if body.func() == math.equation {
    assert(not body.block, message: "block level formulas are not allowed at the beginning!")
    return h(-.25em) + body
  }

  if body.has("text") {
    let text = body.text
    let first = text.first()
    if first in _SPECIAL-CHAR { return box(first) + text.slice(first.len()) }
  }
  body
}

#let _is_empty(body) = body in ([ ], parbreak(), [])

#let _trim-content(body) = {
  if _is_empty(body) { return body }
  show parbreak: [ \ ] // 去除数学公式在 question 方法中，新的段落以数学公式开头时，左侧加间距的问题(typst留下的坑)
  if body.has("children") {
    body = body.children
    if _is_empty(body.first()) { body = body.slice(1) } // 去除开头的空行，换行
    body.first() = _trim-left-space(body.first())
    body.join()
  } else {
    _trim-left-space(body)
  }
}

// 生成弥封线
#let _create-seal(
  info: (:),
  line-type: "dashed",
  decoration: none,
  supplement: none,
  rotate-deg: 0deg,
  rotate-origin: center + horizon,
) = rotate(rotate-deg, origin: rotate-origin)[
  #assert(type(info) == dictionary, message: "expected dictionary, found " + str(type(info)))
  #set par(spacing: 10pt)
  #set text(font: heiti, 12pt)
  #set align(center)
  #set grid(columns: 2, align: horizon, gutter: .5em)
  #if supplement != none { text(tracking: .8in, supplement) }
  #grid(
    columns: if info.len() == 0 { 1 } else { info.len() },
    gutter: 1em,
    ..for (key, value) in info {
      (
        grid(
          key,
          value,
        ),
      )
    }
  )
  #if decoration == none {
    line(length: 100%, stroke: (dash: line-type))
  } else {
    let data = (
      { CIRCLE }: 4 * (circle(width: 1.25em, stroke: .5pt),),
      { TEXT }: ("弥", "封", "线", none),
    )
    let seal-line = (4 * (line(length: 100%, stroke: (dash: line-type)),))
      .zip(data.at(decoration))
      .flatten()
      .slice(0, -1)
    grid(
      columns: seal-line.len(),
      align: horizon,
      ..seal-line,
    )
  }
]

// 一种页码格式: "第x页（共xx页）
#let zh-arabic(prefix: none, suffix: none) = (..nums) => {
  let arr = nums.pos()
  [#prefix;第#arr.first()页（共#arr.last()页）#suffix]
}

#let tag(
  body,
  color: blue,
  font: auto,
  weight: 400,
  prefix: "【",
  suffix: "】",
) = context {
  text(font: if font == auto { heiti + text.font } else { font }, weight: weight, color)[#box(prefix)#body#box(
      suffix,
    )#h(.5em, weak: true)]
}

// 图文混排
#let text-figure(
  figure: none,
  figure-x: 0pt,
  figure-y: 0pt,
  top: 0pt,
  bottom: 0pt,
  gap: 0pt,
  style: "tf",
  text,
) = context {
  assert(style in ("tf", "ft"), message: "style expected 'tf', 'ft'")
  let body = (
    text, // [ \ ] 是为了在当前页还有一行时，换页
    [ \ ] + box(place(dx: figure-x, dy: figure-y - par.leading * 2, figure)),
  )

  let columns = (1fr, measure(figure).width)
  let gap = -figure-x + gap
  if style == "ft" {
    body = body.rev()
    columns = columns.rev()
    gap = figure-x + gap
  }

  grid(
    columns: columns,
    inset: (
      top: top,
      bottom: bottom,
    ),
    gutter: gap,
    ..body,
  )
}

// 指定开始页码
#let page-restart(num: 1) = context {
  assert(type(num) == int and num > 0, message: "num expected positive integer")
  pagebreak(weak: true)
  let chapter-index = counter-title.get().first() - 1
  let chapter-final = counter-title.final().first() - 1
  if chapter-index < 0 or chapter-index == chapter-final { return } // 处于目录页或最后一页时，不重新开始页码
  let current = counter(page).get().first() - 1
  let page-restart = page-restart-state.get()
  // 如果重新开始页码，则将之前章节的页码总数更新到当前页码 - 1
  chapter-pages-state.update(pre => {
    for index in range(page-restart, chapter-index + 1) {
      pre.at(index).last() = current
    }
    pre
  })
  page-restart-state.update(chapter-index + 1)
  counter(page).update(num)
}

// 中文着重号
#let _han-zi = regex("\p{Han}")
#let emph-dot(body) = {
  show _han-zi: it => box(place(text("·", .7em), dx: .4em, dy: .7em) + it)
  body
}
