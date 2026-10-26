// 页面预设
#let a3 = (paper: "a3", margin: 1in, columns: 2, flipped: true)
#let a3-binding = (..a3, margin: (inside: 1.2in, outside: .8in, y: 1in))

#let a3-3cols = (..a3, columns: 3)
#let a3-3cols-binding = (..a3-binding, columns: 3)

#let a4 = (paper: "a4", margin: 1in, columns: 1, flipped: false)
#let a4-binding = (..a4, margin: (inside: 1.2in, outside: .8in, y: 1in))

#let a4-2cols = (..a4, columns: 2)
#let a4-2cols-binding = (..a4-binding, columns: 2)

#let a4-landscape = (..a4, flipped: true)
#let a4-landscape-binding = (..a4-binding, flipped: true)

#let a4-landscape-2cols = (..a4-landscape, columns: 2)
#let a4-landscape-2cols-binding = (..a4-2cols-binding, flipped: true)

// 字体
#let heiti = ("SimHei", "Noto Sans CJK SC")
#let kaiti = ("STKaiti",)
