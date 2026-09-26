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

#let in-outside = (margin: (inside: 1.2in, outside: .8in, y: 1in))

#let times-songti = (
  "Times New Roman",
  "TeX Gyre Termes", //（无 Times New Roman 时的 fallback）
  "Noto Serif CJK SC", // 中文字体
)

#let times-songti-math = (
  (name: "STIX Two Math", covers: regex("[∅𝜋𝑓𝑗𝑧±]")),
  "TeX Gyre Termes Math",
  "Noto Serif CJK SC",
)

#let _regex = regex("[^a-zA-Z0-9，。、；：？！\"\"''（）《》]")
#let heiti = (
  (name: "SimHei", covers: _regex),
  (name: "Noto Sans CJK SC", covers: _regex),
)

#let kaiti = ((name: "STKaiti", covers: _regex),)
