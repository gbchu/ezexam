#import "const-state.typ": EXAM, chapter-pages-state, heiti, mode-state
#let _special-char = "《（【"
// 为了解决数学公式、特殊字符在最左侧没有内容时加间距的问题
#let _math-or-special-char(body) = {
  if body.func() == math.equation { return "math" }
  if body.has("text") and body.text.first() in _special-char { "char" }
}

#let _check-content-starts-with(body) = {
  if body.has("children") {
    let children = body.children
    if children.len() == 0 { return }
    body = children.first()
    if body == [ ] { body = children.at(1) }
  }
  _math-or-special-char(body)
}

#let _content-start-space(body) = {
  if _check-content-starts-with(body) == "math" { return .25em }
  if _check-content-starts-with(body) == "char" { return .4em }
  0em
}

#let _trim-content-start-parbreak(body) = {
  if body.has("children") {
    let children = body.children
    if children.len() > 0 and children.first() == parbreak() {
      return children.slice(1).join()
    }
  }
  body
}

// 弥封线
#let _create-seal(
  dash: "dashed",
  supplement: none,
  info: (:),
) = {
  assert(type(info) == dictionary, message: "expected dictionary, found " + str(type(info)))
  set par(spacing: 10pt)
  set text(font: heiti, size: 12pt)
  set align(center)
  set grid(columns: 2, align: horizon, gutter: .5em)
  if supplement != none { text(tracking: .8in, supplement) }
  grid(
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
  line(length: 100%, stroke: (dash: dash))
}

#let _seal-line(
  student-info,
  line-type,
  supplement,
  footer-is-separate,
  current-page,
  first,
  last,
) = /* context */ {
  // 根据当前章节的第一页和最后一页，判断添加弥封线
  let current-page = current-page
  let width = page.height
  if page.flipped {
    width = page.width
    if footer-is-separate {
      current-page -= 1
    }
  }
  let margin = page.margin
  width -= margin * 2

  place(float: true, bottom, dy: -margin, dx: -1em)[
    #block(width: width)[
      //当前章节第一页弥封线
      #if current-page == first {
        rotate(-90deg, origin: left + bottom, _create-seal(
          dash: line-type,
          info: student-info,
          supplement: supplement,
        ))
        return
      }
      // 章节最后页的弥封线
      #if current-page + page.columns - 1 == last {
        width = if page.flipped { page.height } else { page.width }
        move(
          // 2.6em为弥封线的高度
          dx: -margin - 100% + width - 2.6em,
          rotate(90deg, origin: right + bottom, _create-seal(
            dash: line-type,
            supplement: supplement,
          )),
        )
      }
    ]
  ]
}

// 草稿纸
#let draft(
  name: "草稿纸",
  student-info: (
    姓名: underline[~~~~~~~~~~~~~],
    准考证号: underline[~~~~~~~~~~~~~~~~~~~~~~~~~~],
    考场号: underline[~~~~~~~],
    座位号: underline[~~~~~~~],
  ),
  dash: "solid",
  supplement: none,
) = {
  set page(margin: .5in, footer: none)
  title(name.split("").join(h(1em)), bottom: 0pt)
  _create-seal(dash: dash, supplement: supplement, info: student-info)
}

// 一种页码格式: "第x页（共xx页）
#let zh-arabic(prefix: "", suffix: "") = (..nums) => {
  let arr = nums.pos()
  [#prefix 第#arr.first()页（共#arr.last()页）#suffix]
}

#let tag(body, color: blue, font: auto, weight: 400, prefix: "【", suffix: "】", x: -.4em) = context {
  let _font = if font == auto { text.font.slice(0, -1) + heiti } else { font }
  h(x, weak: true)
  text(font: _font, weight: weight, color, prefix + body + suffix)
  h(.1em, weak: true)
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
  assert(style == "tf" or style == "ft", message: "style must be 'tf' or 'ft'")
  let body = (
    text, // [ \ ] 是为了在当前页还有一行时，换页
    [ \ ] + box(place(dx: figure-x, dy: figure-y - par.leading * 2, figure)),
  )

  let _columns = (1fr, measure(figure).width)
  let _gap = -figure-x + gap
  if style == "ft" {
    body = body.rev()
    _columns = _columns.rev()
    _gap = figure-x + gap
  }

  grid(
    columns: _columns,
    inset: (
      top: top,
      bottom: bottom,
    ),
    gutter: _gap,
    ..body,
  )
}

#let page-restart(num) = context {
  assert(type(num) == int, message: "num expected integer")
  pagebreak(weak: true)
  let chapter-index = counter("title").get().first() - 1
  let chapter-final = counter("title").final().first() - 1
  if chapter-index < 0 or chapter-index == chapter-final { return } // 处于目录页或最后一页时，不重新开始页码
  let current = counter(page).get().first() - 1
  let final-page = counter(page).final()
  let page-restart = page-restart-state.get()
  chapter-pages-state.update(pre => {
    if pre.at(chapter-index).len() == 1 {
      pre.at(chapter-index) += (current, ..final-page)
    }
    // 如果重新开始页码，则将之前的页码总数更新到当前页码 - 1
    for index in range(page-restart, chapter-index + 1) {
      pre.at(index).last() = current
    }
    pre
  })
  page-restart-state.update(chapter-index + 1)
  counter(page).update(num)
}
