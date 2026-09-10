#import "state.typ": answer-color-state, answer-state
#import "counter.typ": counter-placeholder, counter-question
#import "tools.typ": _fallback, _get-margin-x, _is_empty

#let _get-answer(body, placeholder, with-number, update) = {
  if answer-state.get() { return text(answer-color-state.get(), body) }
  if not with-number { return placeholder }
  counter-placeholder.step()
  context counter-placeholder.display()
  if update { counter-question.step() }
}

#let _get-space() = {
  let page-width = if page.flipped { page.height } else { page.width }
  let (l, r) = _get-margin-x(page.margin) // 这里如果启用in-outside，左右是反的
  let page-columns = page.columns
  let trim-margin-x-width = page-width - l - r
  let container-width = (trim-margin-x-width - columns.gutter * (page-columns - 1)) / page-columns

  let here-pos-x = here().position().x
  let cols = here-pos-x / container-width // 当前位置所在列
  let end-pos-x = r + container-width * calc.ceil(cols) + columns.gutter * calc.floor(cols)

  (container-width, end-pos-x - here-pos-x)
}

#let _draw-line(len, stroke, offset, body) = {
  assert(type(len) == length or len == 1fr, message: "expect length, 1fr")
  set box(stroke: (bottom: stroke), inset: (bottom: offset))
  body = align(center, body)
  if len == 1fr {
    box(width: len, body)
  } else {
    let len = len.to-absolute()
    assert(len > 4pt, message: "len must > 4pt")

    let (first-line-useable-width, container-width) = _get-space()
    let rest-len = len - first-line-useable-width
    let is-line-break = false
    // 当前行剩余空间 < 1em 时，则直接换行在新的一行从头开始画
    if first-line-useable-width < 1em.to-absolute() {
      [ \ ]
      is-line-break = true
      rest-len = len
    } else {
      // 当前行的线
      // 如果当前指定长度 < 剩余空间，则按照指定长度在文字后画线
      box(width: if rest-len < 0pt { len } else { 1fr }, body)
      // 如果当前行画满，则强制换行，否则如果后面有文字会导致线和文字一起换行
      if rest-len > 0pt [ \ ]
    }

    // 不在当前行的横线
    if rest-len > 5pt {
      // 完整的条数
      let _ratio = rest-len / container-width
      for _ in range(calc.trunc(_ratio)) {
        box(width: 100%)[#if is-line-break {
            body
            is-line-break = false
          } else { sym.zws }
        ]
      }
      // 最后一行的线
      box(width: calc.fract(_ratio) * 100%)[#if is-line-break { body } else { sym.zws }]
    }
  }
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
) = {
  let space = h(.25em, weak: true)
  space
  context {
    let result = _get-answer(body, placeholder, with-number, update)
    if result == placeholder or _is_empty(result.child) {
      _draw-line(len, stroke, offset, result)
    } else {
      underline(
        evade: false,
        offset: offset,
        stroke: stroke,
        result,
      )
    }
  }
  space
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
  #let space = h(0pt, weak: true)
  #space
  （~~#context _get-answer(body, placeholder, with-number, update)~~）
  #space
]

// 类似英文中的7选5题型专用语法糖
#let parenn = paren.with(with-number: true, update: true)
#let fillinn = fillin.with(with-number: true, update: true)
