#import "state.typ": section-data-state, current-section-state

// 为接下来的板块设置默认单题分数
// - pts (int, none): 单题默认分数；每题都有各自分数时可填 none
#let set-default-pts(pts) = {
  assert(
    pts == none or (type(pts) == int and pts > 0),
    message: "pts expected positive integer or none",
  )
  current-section-state.update(s => s + 1)
  section-data-state.update(data => {
    data.push((default-pts: pts, questions: ()))
    data
  })
}

// 当前板块的题目数量
#let q-count = context {
  let section-idx = current-section-state.get()
  let data = section-data-state.final()
  if section-idx >= 0 and section-idx < data.len() {
    [#data.at(section-idx).questions.len()]
  }
}

// 当前板块的单题默认分数
#let single-pts = context {
  let section-idx = current-section-state.get()
  let data = section-data-state.final()
  if section-idx >= 0 and section-idx < data.len() {
    let pts = data.at(section-idx).default-pts
    if pts != none { [#pts] }
  }
}

// 当前板块的总分
#let section-pts = context {
  let section-idx = current-section-state.get()
  let data = section-data-state.final()
  if section-idx >= 0 and section-idx < data.len() {
    [#data.at(section-idx).questions.sum(default: 0)]
  }
}

// 试卷总分
#let total-pts = context {
  let data = section-data-state.final()
  [#data.map(s => s.questions.sum(default: 0)).sum(default: 0)]
}
