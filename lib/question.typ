#import "const-state.typ": HANDOUTS, answer-color-state, answer-state, mode-state

#let question(
  body,
  body-indent: .7em,
  indent: 0pt,
  label: auto,
  label-color: black,
  label-weight: "regular",
  with-heading-label: false,
  points: none,
  points-separate: true,
  points-prefix: "（",
  points-suffix: "分）",
  top: 0pt,
  bottom: 0pt,
  padding-top: 0pt,
  padding-bottom: 0pt,
) = {
  // 分数设置
  assert(type(points) == int or points == none, message: "points must be a int or none")
  if points != none {
    body = [#points-prefix#points#points-suffix #if points-separate [ \ ] #body]
  }

  // 格式化题号
  counter("question").step()
  let _format = context counter("question").display(num => {
    let _label = label
    if label == auto {
      if mode-state.get() == HANDOUTS {
        _label = "【1.1.1.1.1.1】"
      } else {
        _label = "1. "
      }
    }

    let arr = (num,)
    if with-heading-label {
      // 去除heading label数组中的0
      arr = counter(heading).get().filter(item => item != 0) + arr
    }
    text(
      label-color,
      weight: label-weight,
      box(
        align(right, numbering(_label, ..arr)),
        width: 1.45em,
      ),
    )
  })

  v(top - padding-top)
  list(
    marker: _format,
    body-indent: body-indent,
    indent: indent,
    pad(top: padding-top, bottom: padding-bottom, body),
  )
  v(bottom)

  // 更新占位符上的题号
  context counter("placeholder").update(counter("question").get().first())
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




#let _is-normal(body) = {
  if body == [] or body == [ ] or body.has("text") {
    return true
  }
  return false
}

#let _FRAC = "frac"
#let _SUM = "sum"
#let _CASES = "cases"

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

#let _check-content(
  body,
) = {
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

// 填空的横线
#let fillin(
  body,
  len: 1cm,
  placeholder: "▴",
  with-number: false,
  update: false,
  stroke: .45pt,
  offset: 3.5pt,
) = context {
  if type(len) in (ratio, relative) {
    panic("expect length, got " + str(type(len)))
  }

  if len <= 0pt { panic("len must > 0") }

  let _body = _get-answer(body, placeholder, with-number, update)
  // 需要显示答案时
  if _body != placeholder and with-number == false {
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
    show math.equation: it => {
      box(
        stroke: (bottom: stroke),
        outset: (bottom: line-offset),
        it,
      )
    }

    // 显示答案，但是并没有填写答案，默认显示下划线
    if (_body.child == [] or _body.child == [ ]) {
      _body = [~~~#_body~~~]
    }

    underline(
      evade: false,
      offset: line-offset,
      stroke: stroke + black,
    )[~#_body~]

    return
  }

  // 不显示答案时，只显示横线；根据给定的len绘制
  // 第一行横线开始位置及长度
  let current-pos = here().position().x
  let first-line-available-space = page.width - page.margin - current-pos
  // 第一行线
  // 如果当前指定长度 < 剩余空间，则直接按照指定长度在文字后画线，否则，则需要在指定文字后先画一部分；
  let continue-draw = true
  set line(stroke: stroke)
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

// 类似英文中的7选5题型专用语法糖
#let parenn = paren.with(with-number: true, update: true)
#let fillinn = fillin.with(with-number: true, update: true)

// 图文混排(左文右图)
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
  let _columns = (1fr, measure(figure).width)
  let _gap = -figure-x + gap
  let body = (text, place(dy: figure-y, dx: figure-x, horizon, figure))
  if style == "ft" {
    body = body.rev()
    _columns = _columns.rev()
    _gap = figure-x + gap
  }
  let dpar = par.leading - par.spacing
  grid(
    columns: _columns,
    align: horizon,
    inset: (
      top: top + dpar,
      bottom: bottom + dpar,
    ),
    gutter: _gap,
    ..body,
  )
}

#let solution(
  body,
  title: none,
  title-size: 12pt,
  title-weight: "bold",
  title-color: luma(100%),
  title-bg-color: maroon,
  title-radius: 5pt,
  title-align: top + center,
  title-x: 0pt,
  title-y: 0pt,
  border-style: "dashed",
  border-width: .5pt,
  border-color: maroon,
  color: blue,
  radius: 5pt,
  bg-color: luma(100%),
  breakable: true,
  top: 0pt,
  bottom: 0pt,
  padding-top: 0pt,
  padding-bottom: 0pt,
  inset: (rest: 10pt, top: 20pt, bottom: 20pt),
  show-number: true,
) = context {
  if not answer-state.get() { return }
  assert(type(inset) == dictionary, message: "inset must be a dictionary")
  let _inset = (rest: 10pt, top: 20pt, bottom: 20pt) + inset
  v(top)
  block(
    width: 100%,
    breakable: breakable,
    inset: _inset,
    radius: radius,
    stroke: (thickness: border-width, paint: border-color, dash: border-style),
    fill: bg-color,
  )[
    // 标题
    #if title != none {
      let title-box = box(fill: title-bg-color, inset: 6pt, radius: title-radius, text(
        size: title-size,
        weight: title-weight,
        tracking: 3pt,
        title-color,
        title,
      ))
      let _title-height = measure(title-box).height
      place(
        title-align,
        dx: title-x,
        dy: -_inset.top - _title-height / 2 + title-y,
      )[#title-box]
    }

    // 解析题号的格式化
    #counter("explain").step()
    #let format = context () => {
      numbering("1.", ..counter("explain").get())
    }

    #list(
      marker: if show-number { format } else { none },
      pad(top: padding-top, bottom: padding-bottom, text(color, body)),
    )
  ]
  v(bottom)
}

// 解析的分值
#let score(points, color: maroon, score-prefix: "", score-suffix: "分") = text(color)[
  #box(width: 1fr, repeat($dot$))#score-prefix#h(2pt)#points#score-suffix
]

#let answer(body, color: maroon) = par(text(weight: 700, color)[答案: #body])
