#import "const-state.typ": EXAM, heiti, mode-state, seal-line-page-state
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
  current-page,
) = context {
  // 根据当前章节的第一页和最后一页，判断添加弥封线
  let chapter-first-last-pages = seal-line-page-state.final()
  chapter-first-last-pages.last().push(..counter(page).final())
  let chapter-index = counter("chapter").get().first() - 1
  let chapter-first-last = chapter-first-last-pages.at(chapter-index)

  let width = page.height
  if page.flipped {
    width = page.width
    if footer-is-separate {
      current -= 1
    }
  }
  let margin = page.margin
  width -= margin * 2

  place(float: true, bottom, dy: -margin, dx: -1em)[
    #block(width: width)[
      //当前章节第一页弥封线
      #if current-page == chapter-first-last.first() {
        rotate(-90deg, origin: left + bottom, _create-seal(
          dash: line-type,
          info: student-info,
          supplement: supplement,
        ))
        return
      }
      // 章节最后页的弥封线
      #if current-page + page.columns - 1 == chapter-first-last.last() {
        width = page.width
        if page.flipped { width = page.height }
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
  set page(margin: .5in, header: none, footer: none)
  title(name.split("").join(h(1em)), bottom: 0pt)
  _create-seal(dash: dash, supplement: supplement, info: student-info)
}

// 一种页码格式: "第x页（共xx页）
#let zh-arabic(prefix: "", suffix: "") = (..nums) => {
  let arr = nums.pos()
  [#prefix 第#str(arr.at(0))页（共#str(arr.at(-1))页）#suffix]
}

#let tag(body, color: blue, font: auto, weight: 400, prefix: "【", suffix: "】", x: -.4em) = context {
  let _font = font
  if font == auto { _font = text.font.slice(0, -1) + heiti }
  h(x, weak: true)
  text(font: _font, weight: weight, color)[#prefix#body#suffix]
  h(.1em, weak: true)
}
