#import "state.typ": section-data-state, current-section-state

/// Set default points for questions in the next section.
/// Call this before the section heading.
/// - pts (int, none): default points per question, or none if each question specifies its own points
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

/// Question count for the current section (use in headings).
#let q-count = context {
  let section-idx = current-section-state.get()
  let data = section-data-state.final()
  if section-idx >= 0 and section-idx < data.len() {
    [#data.at(section-idx).questions.len()]
  }
}

/// Default points per question for the current section (use in headings).
#let single-pts = context {
  let section-idx = current-section-state.get()
  let data = section-data-state.final()
  if section-idx >= 0 and section-idx < data.len() {
    let pts = data.at(section-idx).default-pts
    if pts != none { [#pts] }
  }
}

/// Total points for the current section (use in headings).
#let section-pts = context {
  let section-idx = current-section-state.get()
  let data = section-data-state.final()
  if section-idx >= 0 and section-idx < data.len() {
    [#data.at(section-idx).questions.sum(default: 0)]
  }
}

/// Total points for the entire test paper (use in exam-info or notice).
#let total-pts = context {
  let data = section-data-state.final()
  [#data.map(s => s.questions.sum(default: 0)).sum(default: 0)]
}
