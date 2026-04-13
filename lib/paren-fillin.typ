#import "state.typ": answer-color-state, answer-state
#import "counter.typ": counter-placeholder, counter-question
#import "tools.typ": _is_empty

#let _get-answer(body, placeholder, with-number, update) = {
  if answer-state.get() { return text(answer-color-state.get(), body) }
  if not with-number { return placeholder }
  counter-placeholder.step()
  context counter-placeholder.display()
  if update { counter-question.step() }
}

#let _draw-line(len, stroke, offset, body) = {
  assert(type(len) == length, message: "expect length, found " + str(type(len)))
  let _len = len.to-absolute()
  assert(_len > 4pt, message: "len must > 4pt")

  let page-width = if page.flipped { page.height } else { page.width }
  let _columns = page.columns
  let here-pos-x = here().position().x
  if _columns > 1 {
    let one-column-width = (page-width + columns.gutter * (_columns - 1)) / _columns
    // 当有多个列时，当前内容所在的那一列加上前面所有的列的总宽度
    page-width = one-column-width * calc.ceil(here-pos-x / one-column-width)
  }

  let _margin = page.margin
  if _margin == auto { _margin = 1in }
  let first-line-available-space = page-width - _margin - here-pos-x
  let rest-len = _len - first-line-available-space
  let is-line-break = false
  let _space = if here-pos-x == _margin { 0pt } else { 1pt }
  set box(stroke: (bottom: stroke), inset: (bottom: offset), outset: (bottom: offset))

  h(_space, weak: true)
  // 当前行剩余空间 < 1em 时，则直接换行在新的一行从头开始画
  if first-line-available-space < 1em.to-absolute() {
    is-line-break = true
    rest-len = _len
  } else {
    // 如果当前指定长度 < 剩余空间，则按照指定长度在文字后画线
    if rest-len < 0pt { first-line-available-space = _len }
    sym.zws // 解决左侧为中文标点时，导致换行问题
    // 当前行的线
    box(width: first-line-available-space - _space, align(center, body))
  }

  // 不在当前行的横线
  if rest-len > 5pt {
    // 完整的条数
    let _ratio = rest-len / (page.width - _margin * 2)
    (
      box(width: 100%)[#if is-line-break {
          align(center, body)
          is-line-break = false
        } else { sym.zws }
      ]
        * calc.trunc(_ratio)
    )

    // 最后一行的线
    box(width: calc.fract(_ratio) * 100%)[#if is-line-break { align(center, body) } else { sym.zws }]
  }
  h(_space, weak: true)
}

// 填空的横线
#let fillin(
  body,
  len: 27.5pt,
  placeholder: "▲",
  with-number: false,
  update: false,
  stroke: .45pt + black,
  offset: 3pt,
) = context {
  let result = _get-answer(body, placeholder, with-number, update)
  if result == placeholder or _is_empty(result.child) {
    return _draw-line(len, stroke, offset / 2, result)
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
  placeholder: "▲",
  with-number: false,
  update: false,
) = [
  #if justify { h(1fr) }
  #h(0pt, weak: true)（~~#context _get-answer(body, placeholder, with-number, update)~~）
]

// 类似英文中的7选5题型专用语法糖
#let parenn = paren.with(with-number: true, update: true)
#let fillinn = fillin.with(with-number: true, update: true)
