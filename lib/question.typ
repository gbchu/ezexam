#import "state.typ": mode-state, question-count-points-state
#import "const.typ": HANDOUTS, _QUESTION
#import "counter.typ": counter-chapter, counter-placeholder, counter-question
#import "tools.typ": _format-content

// 设置每节每题的默认分数
#let set-per-pts(..pts) = context {
  let points = pts.pos()
  assert(
    points.all(item => item == none or type(item) in (int, float) and item > 0),
    message: "points expected positive number or none, found " + repr(points),
  )
  let chapter-index = counter-chapter.get().first() - 1
  question-count-points-state.update(pre => {
    let zeros = points.len() * (0,)
    let init-cnt-pts = zeros.zip(points, zeros)
    if pre.len() == chapter-index {
      pre.push(init-cnt-pts)
    } else {
      pre.at(chapter-index) += init-cnt-pts
    }
    pre
  })
}

#let _current-chapter-q-cnt-pts() = question-count-points-state.final().at(counter-chapter.get().first() - 1)

#let _current-sec-q-cnt-pts(idx) = context {
  let heading-idx = counter(heading).get().first() - 1
  assert(
    heading-idx >= 0,
    message: "the count of current questions and points will not be available! Unless a heading is added.",
  )
  _current-chapter-q-cnt-pts().at(heading-idx).at(idx)
}

// 当前小节的题目数量、每题分数、小节分数、总分、总题数
#let sec-q-cnt = _current-sec-q-cnt-pts(0)
#let per-pts = _current-sec-q-cnt-pts(1)
#let sec-pts = _current-sec-q-cnt-pts(-1)
#let tot-pts = context _current-chapter-q-cnt-pts().fold(0, (acc, (.., sec-pts)) => acc + sec-pts)
#let tot-q-cnt = context _current-chapter-q-cnt-pts().fold(0, (acc, (sec-q-cnt, ..)) => acc + sec-q-cnt)

// 更新每个小节的问题数、总分数
#let _update-question-count-points(points, chapter-idx, heading-idx) = {
  if heading-idx < 0 { return } // 题目没有小节标题时
  question-count-points-state.update(pre => {
    if pre.len() == chapter-idx { pre.push(((0, none, 0),)) } // 当前章节未设置分数时
    let chapter-cnt-pts = pre.at(chapter-idx)
    if chapter-cnt-pts.len() == heading-idx { chapter-cnt-pts.push((0, none, 0)) } // 当前小节没有初始化时
    let (cnt, per-pts, sec-pts) = chapter-cnt-pts.at(heading-idx)
    chapter-cnt-pts.at(heading-idx) = (cnt + 1, per-pts, sec-pts + if points != none { points } else { per-pts })
    pre.at(chapter-idx) = chapter-cnt-pts
    pre
  })
}

#let _format-label(label, label-color, label-weight, with-heading-label, headings) = context counter-question.display(
  num => {
    let result = text(label-color, weight: label-weight, numbering(
      label,
      ..if with-heading-label { headings.filter(item => item != 0) } + (num,),
    ))
    if mode-state.get() == HANDOUTS { return result }
    box(width: 1em, align(right, result))
  },
)

#let _format-points(points, prefix, suffix, separate) = {
  if points == none { return }
  assert(
    type(points) in (int, float) and points > 0,
    message: "points expected positive number, found " + repr(points),
  )
  [#box(prefix)#points#suffix#if separate [ \ ]]
}

#let _format-ref-prefix(chapter, headings) = {
  if chapter == 0 { chapter = "1" }
  let heading-label = headings.filter(item => item != 0)
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
  let chapters = counter-chapter.get()
  let headings = counter(heading).get()
  let label = _format-label(label, label-color, label-weight, with-heading-label, headings)
  let body = terms(
    indent: indent,
    hanging-indent: if hanging-indent == auto { measure(label).width + 1em } else { hanging-indent },
    separator: h(1em, weak: true),
    terms.item(
      label,
      _format-points(points, points-prefix, points-suffix, points-separate)
        + h(first-line-indent)
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
    #let ref-prefix = none
    #figure(
      supplement: {
        ref-prefix = _format-ref-prefix(chapters.first(), headings)
        supplement
        if show-ref-prefix [#ref-prefix.replace("-", " - ")#h(-.25em, weak: true)]
        ref-prefix = std.label(ref-prefix + str(counter-question.get().first() + 1))
      },
      kind: _QUESTION,
      body,
    )#ref-prefix
  ] else {
    counter-question.step()
    body
  }
  v(bottom)
  // 更新占位符上的题号
  context counter-placeholder.update(..counter-question.get())
  _update-question-count-points(points, chapters.first() - 1, headings.first() - 1)
}
