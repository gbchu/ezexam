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

#let _draw-line(len, stroke, body) = {
  let _len = len.to-absolute()
  // 只显示下划线；根据给定的len绘制
  if _len <= 0pt { panic("len must > 0") }
  // 第一行横线开始位置及长度
  let current-pos = here().position().x
  let first-line-available-space = page.width - page.margin - current-pos
  // 第一行线
  // 如果当前指定长度 < 剩余空间，则直接按照指定长度在文字后画线，否则，则需要在指定文字后先画一部分；
  let continue-draw = true
  if _len <= first-line-available-space.length {
    first-line-available-space = len
    continue-draw = false
  }

  box(
    width: first-line-available-space,
    stroke: (bottom: stroke),
    outset: (bottom: 1.5pt),
    align(center, body),
  )

  // 超过一行的后续横线
  if continue-draw {
    // 计算可以画多少完整的条数
    let _ratio = (_len - first-line-available-space) / page.width
    // 多条完整线
    set line(stroke: stroke)
    for _ in range(calc.floor(_ratio)) { line(length: 100%) }
    // 最后一行的线
    box(line(length: calc.fract(_ratio) * 100%))
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
  offset: 3.5pt,
) = context {
  assert(type(len) == length, message: "expect length, got " + str(type(len)))

  let result = _get-answer(body, placeholder, with-number, update)

  if (
    not answer-state.get() or result.child == [] or result.child == [ ]
  ) {
    _draw-line(len, stroke, result)
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
  [#if justify { h(1fr) }（~~#upper(result)~~）]
}

// 类似英文中的7选5题型专用语法糖
#let parenn = paren.with(with-number: true, update: true)
#let fillinn = fillin.with(with-number: true, update: true)
