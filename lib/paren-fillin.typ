#import "const-state.typ": answer-color-state, answer-state

#let _get-answer(body, placeholder, with-number, update) = {
  if answer-state.get() {
    return text(answer-color-state.get(), body)
  }
  if not with-number { return placeholder }
  counter("placeholder").step()
  context counter("placeholder").display()
  if update { counter("question").step() }
}

#let _draw-line(len, stroke, offset, body) = {
  let _len = len.to-absolute()
  assert(_len > 4pt, message: "len must > 4pt")

  set box(stroke: (bottom: stroke), inset: (bottom: offset), outset: (bottom: offset))

  let page-width = page.width
  if page.flipped {
    page-width = page.height
  }

  let _columns = page.columns
  let here-pos-x = here().position().x
  if _columns > 1 {
    let one-column-width = (page-width + columns.gutter * (_columns - 1)) / _columns
    // 当有多个列时，当前内容所在的那一列加上前面所有的列的总宽度
    page-width = one-column-width * calc.ceil(here-pos-x / one-column-width)
  }

  // 第一行线
  // 如果当前指定长度 < 剩余空间，则直接按照指定长度在文字后画线
  let first-line-available-space = page-width - page.margin - here-pos-x
  let rest-len = _len - first-line-available-space
  if rest-len < 0pt {
    first-line-available-space = _len
  }

  let is-new-line = false
  // 当前指定长度 > 剩余空间且剩余空间 > 6pt，则按照当前行的剩余空间画线；
  if first-line-available-space < 8pt {
    [ \ ]
    is-new-line = true
    rest-len = _len
  } else {
    let space = 1pt
    h(space, weak: true)
    // hide("") // 存在是解决当前面是中文标点时换行的问题（搞不懂为啥，猜测和符号计算方式有关）
    box(width: first-line-available-space - space, align(center, body), inset: 0pt)
    h(space, weak: true)
  }

  // 超过一行的后续横线
  if rest-len > 5pt {
    // 计算可以画多少完整的条数
    let _ratio = rest-len / (page.width - page.margin * 2)
    // 多条完整线
    for _ in range(calc.trunc(_ratio)) {
      box(width: 100%)[
        #if is-new-line {
          align(center, body)
          is-new-line = false
        }]
      hide("") // 解决多条线时，最后一行线与之前的线间距不等的问题
    }

    // 最后一行的线
    let _last-line-len = calc.fract(_ratio)
    box(width: _last-line-len * 100%)[
      #if is-new-line {
        align(center, body)
      }
    ]
    hide("") // 解决最后一行线，在这条线之后如果加文本线的间距变大问题
    h(1.5pt, weak: true)
  }
}

// 填空的横线
#let fillin(
  body,
  len: 1cm,
  placeholder: "▴",
  with-number: false,
  update: false,
  stroke: .45pt + luma(0),
  offset: 3pt,
) = context {
  assert(type(len) == length, message: "expect length, got " + str(type(len)))

  let result = _get-answer(body, placeholder, with-number, update)

  if (
    not answer-state.get() or result.child == [] or result.child == [ ]
  ) {
    _draw-line(len, stroke, offset / 2, result)
    return
  }

  underline(
    evade: false,
    offset: offset,
    stroke: stroke,
    result,
  )
}

// 选项的括号
#let paren(
  body,
  justify: false,
  placeholder: "▴",
  with-number: false,
  update: false,
) = context {
  let result = _get-answer(body, placeholder, with-number, update)
  [#if justify { h(1fr) } else { h(0pt, weak: true) }（~~#result~~）]
}

// 类似英文中的7选5题型专用语法糖
#let parenn = paren.with(with-number: true, update: true)
#let fillinn = fillin.with(with-number: true, update: true)
