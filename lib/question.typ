#import "state.typ": current-section-state, mode-state, section-data-state
#import "const.typ": HANDOUTS, _QUESTION
#import "counter.typ": counter-chapter, counter-placeholder, counter-question
#import "tools.typ": _format-content

#let _format-label(label, label-color, label-weight, with-heading-label) = context counter-question.display(num => {
  let numbers = if with-heading-label { counter(heading).get().filter(item => item != 0) } + (num,)
  let result = text(label-color, weight: label-weight, numbering(label, ..numbers))
  if mode-state.get() == HANDOUTS { return result }
  box(width: 1em, align(right, result))
})

#let _format-points(points, prefix, suffix, separate) = {
  if points == none { return }
  assert(type(points) == int and points > 0, message: "points expected positive integer!")
  [#box(prefix)#points#suffix#if separate [ \ ]]
}

#let _format-ref-prefix() = {
  let chapter = counter-chapter.get().first()
  if chapter == 0 { chapter = "1" }
  let heading-label = counter(heading).get().filter(item => item != 0)
  str(chapter) + if heading-label != () { "-" + heading-label.map(str).join(".") } + "-"
}

#let question(
  body,
  indent: 0em,
  first-line-indent: 0em,
  hanging-indent: auto,
  label: "1.1.1.1.1.1.",
  label-color: black,
  label-weight: 400,
  with-heading-label: false,
  points: none,
  points-separate: true,
  points-prefix: "（",
  points-suffix: "分）",
  line-height: auto,
  top: 0pt,
  bottom: 0pt,
  ref-on: false,
  show-ref-prefix: true,
  supplement: none,
) = context {
  assert(supplement != auto, message: "supplement expected none, str, content, function")
  let _label = _format-label(label, label-color, label-weight, with-heading-label)
  set par(leading: line-height) if line-height != auto
  let _ref-prefix = none
  v(top)
  [#figure(
      supplement: if ref-on {
        _ref-prefix = _format-ref-prefix()
        supplement + if show-ref-prefix [#_ref-prefix.replace("-", " - ")#h(-.25em, weak: true)]
        _ref-prefix = std.label(_ref-prefix + str(counter-question.get().first() + 1))
      },
      kind: _QUESTION,
    )[
      #terms(
        indent: indent,
        hanging-indent: if hanging-indent == auto { measure(_label).width + 1em } else { hanging-indent },
        separator: h(1em, weak: true),
        (
          _label,
          _format-points(points, points-prefix, points-suffix, points-separate)
            + h(first-line-indent, weak: true)
            + _format-content[#body],
        ),
      )
    ]
    #_ref-prefix
  ]
  v(bottom)
  // 更新占位符上的题号
  context counter-placeholder.update(..counter-question.get())
  // 注册题目，统计分数
  {
    let section-idx = current-section-state.get()
    if section-idx >= 0 {
      let section-data = section-data-state.get()
      if section-idx < section-data.len() {
        let section = section-data.at(section-idx)
        let effective-pts = if points != none {
          points
        } else if section.default-pts != none {
          section.default-pts
        } else {
          0
        }
        section-data-state.update(data => {
          data.at(section-idx).questions.push(effective-pts)
          data
        })
      }
    }
  }
}
