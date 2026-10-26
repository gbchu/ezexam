#let a3 = (
  paper: "a3",
  margin: 1in,
  columns: 2,
  flipped: true,
)

#let a3-3cols = (..a3, columns: 3)

#let a4 = (
  paper: "a4",
  margin: 1in,
  columns: 1,
  flipped: false,
)

#let a4-2cols = (..a4, columns: 2)
#let a4-flipped = (..a4, flipped: true)
#let a4-flipped-2cols = (..a4-2cols, flipped: true)

#let in-outside = (margin: (inside: 1.2in, outside: .8in, y: 1in))

#let heiti = ("SimHei", "Noto Sans CJK SC")
#let kaiti = ("STKaiti",)
