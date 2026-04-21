#import "state.typ": mode-state, section-data-state
#import "const.typ": HANDOUTS, _QUESTION
#import "counter.typ": counter-chapter, counter-placeholder, counter-question
#import "tools.typ": _format-content

// 为接下来的板块设置单题默认分值
// - pts (int, float, none): 单题默认分值；每题都有各自分数时可填 none
// 可以接受多个参数，如 set-default-pts(5, 6, 5)，依次设置接下来三个板块的默认分值为 5、6、5
// 若某个板块不调用，则自动继承上一次设置的分值
#let set-default-pts(..pts-args) = {
  let pts-list = pts-args.pos()
  assert(pts-list.len() > 0, message: "set-default-pts requires at least one argument")
  for pts in pts-list {
    assert(
      pts == none or (type(pts) in (int, float) and pts > 0),
      message: "pts expected positive number or none",
    )
  }
  context {
    let chapter-idx = counter-chapter.get().first()
    let current-h = counter(heading).get().first()
    section-data-state.update(data => {
      for (i, pts) in pts-list.enumerate() {
        let key = str(chapter-idx) + "-" + str(current-h + 1 + i)
        let questions = if key in data { data.at(key).questions } else { () }
        data.insert(key, (default-pts: pts, questions: questions))
      }
      data.insert(str(chapter-idx) + "-fallback", pts-list.last())
      data
    })
  }
}

// 当前板块的题目数量
#let q-count = context {
  let key = str(counter-chapter.get().first()) + "-" + str(counter(heading).get().first())
  let data = section-data-state.final()
  if key in data { [#data.at(key).questions.len()] }
}

// 当前板块的单题默认分值
#let single-pts = context {
  let chapter-idx = counter-chapter.get().first()
  let key = str(chapter-idx) + "-" + str(counter(heading).get().first())
  let fallback-key = str(chapter-idx) + "-fallback"
  let data = section-data-state.get()
  let pts = if key in data { data.at(key).default-pts } else if fallback-key in data { data.at(fallback-key) } else {
    none
  }
  if pts != none { [#pts] }
}

// 当前板块的总分
#let section-pts = context {
  let key = str(counter-chapter.get().first()) + "-" + str(counter(heading).get().first())
  let data = section-data-state.final()
  if key in data { [#data.at(key).questions.sum(default: 0)] }
}

// 整卷总分
#let total-pts = context {
  let data = section-data-state.final()
  data
    .pairs()
    .filter(pair => type(pair.last()) == dictionary)
    .map(pair => pair.last().questions.sum(default: 0))
    .sum(default: 0)
}

#let _format-label(label, label-color, label-weight, with-heading-label) = context counter-question.display(num => {
  let numbers = if with-heading-label { counter(heading).get().filter(item => item != 0) } + (num,)
  let result = text(label-color, weight: label-weight, numbering(label, ..numbers))
  if mode-state.get() == HANDOUTS { return result }
  box(width: 1em, align(right, result))
})

#let _format-points(points, prefix, suffix, separate) = {
  if points == none { return }
  assert(type(points) in (int, float) and points > 0, message: "points expected positive number!")
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
  set par(leading: line-height) if line-height != auto
  let label = _format-label(label, label-color, label-weight, with-heading-label)
  let body = terms(
    indent: indent,
    hanging-indent: if hanging-indent == auto { measure(label).width + 1em } else { hanging-indent },
    separator: h(1em, weak: true),
    (
      label,
      _format-points(points, points-prefix, points-suffix, points-separate)
        + h(first-line-indent, weak: true)
        + _format-content[#body],
    ),
  )
  v(top)
  if ref-on [
    #assert(supplement != auto, message: "supplement expected none, str, content, function")
    #show figure.where(kind: _QUESTION): it => {
      set block(breakable: true)
      align(left, it.body)
    }
    #let _ref-prefix = none
    #figure(
      supplement: {
        _ref-prefix = _format-ref-prefix()
        supplement + if show-ref-prefix [#_ref-prefix.replace("-", " - ")#h(-.25em, weak: true)]
        _ref-prefix = std.label(_ref-prefix + str(counter-question.get().first() + 1))
      },
      kind: _QUESTION,
      body,
    )#_ref-prefix
  ] else {
    counter-question.step()
    body
  }
  v(bottom)
  // 更新占位符上的题号
  context counter-placeholder.update(..counter-question.get())
  // 注册题目，统计分数
  {
    let chapter-idx = counter-chapter.get().first()
    let heading-idx = counter(heading).get().first()
    if heading-idx > 0 {
      let data = section-data-state.get()
      let key = str(chapter-idx) + "-" + str(heading-idx)
      let fallback-key = str(chapter-idx) + "-fallback"
      let default-pts-for-section = if key in data { data.at(key).default-pts } else if fallback-key in data {
        data.at(fallback-key)
      } else { none }
      let effective-pts = if points != none { points } else if default-pts-for-section != none {
        default-pts-for-section
      } else { 0 }
      section-data-state.update(d => {
        let entry = if key in d { d.at(key) } else { (default-pts: default-pts-for-section, questions: ()) }
        d.insert(key, (default-pts: entry.default-pts, questions: entry.questions + (effective-pts,)))
        d
      })
    }
  }
}
