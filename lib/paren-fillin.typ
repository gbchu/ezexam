#import "const-state.typ": answer-color-state, answer-state

#let _FRAC = "frac"
#let _SUM = "sum"
#let _CASES = "cases"

#let _is-normal(body) = {
  if body == [] or body == [ ] or body.has("text") {
    return true
  }
  return false
}

#let _check-equation(body) = {
  // 只有单独的一个公式
  if not body.body.has("children") {
    if body.body.func() == math.cases {
      return _CASES
    }

    if body.body.has("base") and body.body.base.text == "∑" {
      return _SUM
    }

    if body.body.func() == math.frac {
      return _FRAC
    }
    return
  }

  if body.body.func() == math.cases {
    return _CASES
  }

  let res = none
  for value in body.body.children {
    // 先检测公式中是否有CASES（最高）
    if value.func() == math.cases {
      return _CASES
    }

    // 检测公式中是否有SUM
    if value.has("base") and value.base.text == "∑" {
      res = _SUM
      continue
    }

    // 检测公式中是否有分数
    if value.func() == math.frac {
      if res == _SUM { continue }
      res = _FRAC
    }
  }
  return res
}

#let _check-content(body) = {
  // 检测是否为字符串
  if (type(body) == str) {
    panic("expected content，got " + str(type(body)))
  }

  // 如果为空或全都是字符
  if _is-normal(body) { return }

  // 含有公式的content检测
  // 例如：$1/2 sum_(i=1)^n$ exexam $cases()$
  if body.has("children") {
    let res = for item in body.children {
      if _is-normal(item) { continue }
      (_check-equation(item),)
    }
    if res == none { return }
    if res.contains(_CASES) { return _CASES }
    if res.contains(_SUM) { return _SUM }
    if res.contains(_FRAC) { return _FRAC }
    return
  }

  // 只有一个纯公式检测；比如 $1/2 sum_(i=1)^n$
  _check-equation(body)
}

#let _get-answer(body, placeholder, with-number, update) = {
  if answer-state.get() {
    return text(answer-color-state.get(), body)
  }
  if not with-number { return placeholder }
  counter("placeholder").step()
  context counter("placeholder").display()
  if update { counter("question").step() }
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
  if type(len) in (ratio, relative) {
    panic("expect length, got " + str(type(len)))
  }

  if len <= 0pt { panic("len must > 0") }

  let _body = _get-answer(body, placeholder, with-number, update)
  // 显示答案时
  if answer-state.get() {
    // 检测内容中是否有分数，求和，cases 这些较高的公式
    // 分别对应下划线的偏移量 8 13
    let check-result = _check-content(body)
    let line-offset = offset
    if check-result == _CASES {
      line-offset = 16pt
    } else if check-result == _SUM {
      line-offset = 13pt
    } else if check-result == _FRAC {
      line-offset = 9pt
    }

    // 如果填写的内容包含数学公式，给数学公式添加下划线
    show math.equation: it => box(
      stroke: (bottom: stroke),
      outset: (bottom: line-offset),
      it,
    )

    // 显示答案，但是并没有填写答案，默认显示下划线
    if (_body.child == [] or _body.child == [ ]) {
      _body = [~~~#_body~~~]
    }

    underline(
      evade: false,
      offset: line-offset,
      stroke: stroke,
    )[~#_body~]
  } else {
    // 只显示下划线；根据给定的len绘制
    // 第一行横线开始位置及长度
    let current-pos = here().position().x
    let first-line-available-space = page.width - page.margin - current-pos
    // 第一行线
    // 如果当前指定长度 < 剩余空间，则直接按照指定长度在文字后画线，否则，则需要在指定文字后先画一部分；
    let continue-draw = true
    if len <= first-line-available-space.length {
      first-line-available-space = len
      continue-draw = false
    }

    set box(outset: (bottom: 1.5pt)) if with-number
    box(
      width: first-line-available-space,
      stroke: (bottom: stroke),
      align(center, _body),
    )

    // 超过一行的后续横线
    if continue-draw {
      set line(stroke: stroke)
      // 计算可以画多少完整的条数
      let _ratio = (len - first-line-available-space).length / page.width
      // 多条完整线
      for _ in range(calc.floor(_ratio)) {
        line(length: 100%)
      }
      // 最后一行的线
      box[#line(length: calc.fract(_ratio) * 100%)]
    }
  }
}

// 选项的括号
#let paren(
  body,
  justify: false,
  placeholder: "▴",
  with-number: false,
  update: false,
) = context {
  let body = _get-answer(body, placeholder, with-number, update)
  [#if justify { h(1fr) }（~~#upper(body)~~）]
}

// 类似英文中的7选5题型专用语法糖
#let parenn = paren.with(with-number: true, update: true)
#let fillinn = fillin.with(with-number: true, update: true)
