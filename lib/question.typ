#import "const-state.typ": HANDOUTS, mode-state
#import "tools.typ": _trim-content-start-parbreak

#let _format-question-number(label, label-color, label-weight, with-heading-label) = {
  counter("question").step()
  context counter("question").display(num => {
    let _label = label
    if label == auto { _label = "1." }

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
  if points == none { return }
  assert(type(points) == int, message: "points be a positive integer!")
  [#h(0pt, weak: true)#prefix#points#suffix#h(0pt, weak: true)#if separate [ \ ]]
}

#let question(
  body,
  indent: 0em,
  first-line-indent: 0em,
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

  let _space = .5em
  if mode-state.get() == HANDOUTS { _space = .4em }

  v(top)
  terms(
    indent: indent,
    hanging-indent: hanging-indent,
    separator: h(_space),
    (
      box(align(right, _marker), width: 1em),
      _points + h(first-line-indent) + _trim-content-start-parbreak(body),
    ),
  )
  v(bottom)
  // 更新占位符上的题号
  context counter("placeholder").update(counter("question").get().first())
}
