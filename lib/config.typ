#let a3 = (
  paper: "a3",
  margin: 1in,
  columns: 2,
  flipped: true,
)

#let a4 = (
  paper: "a4",
  margin: 1in,
  columns: 1,
  flipped: false,
)

#let roman-font = (
  (name: "Times New Roman", covers: regex("\w")), // 西文字体
  (name: "TeX Gyre Termes", covers: regex("\w")), // 西文字体（无Times New Roman时）
  (name: "STIX Two Math", covers: regex("[𝑗𝑓𝑧𝜋∅±/]")),
  "TeX Gyre Termes Math",
  "Noto Serif CJK SC", // 中文字体
)

#let _regex = regex("[^a-zA-Z0-9，。、；：？！\"\"''（）《》〈〉…—·]")
#let heiti = (
  (name: "SimHei", covers: _regex),
  (name: "Noto Sans CJK SC", covers: _regex),
)

#let kaiti = ((name: "STKaiti", covers: _regex),)
