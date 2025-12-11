#import "const-state.typ": HANDOUTS, mode-state

#let _format-question-number(label, label-color, label-weight, with-heading-label) = {
  counter("question").step()
  context counter("question").display(num => {
    let _label = label
    if label == auto {
      _label = "1."
    }

    let arr = (num,)
    if with-heading-label {
      _label = "1.1.1.1.1.1."
      // 去除heading label数组中的0
      arr = counter(heading).get().filter(item => item != 0) + arr
    }
    text(
      label-color,
      weight: label-weight,
      numbering(_label, ..arr),
    )
  })
}

#let _question-points-set(points, prefix, suffix, separate) = {
  assert(type(points) == int or points == none, message: "points must be a int or none")
  if points == none { return }
  [#h(-.45em, weak: true)#prefix#points#suffix #if separate [ \ ]]
}

#let question(
  body,
  indent: 0pt,
  body-indent: .85em,
  hanging-indent: 2em,
  label: auto,
  label-color: luma(0),
  label-weight: 400,
  with-heading-label: false,
  points: none,
  points-separate: true,
  points-prefix: "（",
  points-suffix: "分）",
  line-height: auto,
  top: 0pt,
  bottom: 0pt,
) = context {
  // 分数设置
  let _points = _question-points-set(
    points,
    points-prefix,
    points-suffix,
    points-separate,
  )
  // 格式化题号
  let _marker = _format-question-number(
    label,
    label-color,
    label-weight,
    with-heading-label,
  )

  set par(leading: line-height) if line-height != auto

  let _indent = indent
  if mode-state.get() == HANDOUTS {
    _indent -= 1em - measure(_marker).width + .14em
  }
  let _body = body
  // 去除body中的第一个换行
  if body.has("children") {
    let children = body.children
    if children.first() == parbreak() {
      children.remove(0)
      _body = children.fold([], (acc, item) => acc + item)
    }
  }
  _body = (box(align(right, _marker), width: 1em), _points + _body)
  v(top)
  terms(
    hanging-indent: hanging-indent,
    indent: indent,
    separator: h(body-indent, weak: true),
    _body,
  )
  v(bottom)

  // 更新占位符上的题号
  context counter("placeholder").update(counter("question").get().first())
}
