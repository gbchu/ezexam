// 获取位置
#let get-pos = label => {
  let pos = 0pt
  for value in query(label) {
    pos = value.location().position().x - page.margin + measure(value).width / 2
  }
  pos
}

// 化学方程式得失电子
#let chem-e(
  equation: "",
  get: (from: "", to: "", e: 0, tsign: sym.times),
  lose: (from: "", to: "", e: 0, tsign: sym.times),
) = context {
  let (from: g-from, to: g-to, e: g-e-num, tsign: g-tsign) = (from: "", to: "", e: 0, tsign: sym.times) + get

  if g-e-num <= 0 or type(g-e-num) != int { return }

  let (from: l-from, to: l-to, e: l-e-num, tsign: l-tsign) = (from: "", to: "", e: 0, tsign: sym.times) + lose

  let body = ()
  // 得电子化学式的开始/结束位置
  let g-from-pos = get-pos(g-from)
  let g-to-pos = get-pos(g-to)
  // 得电子的描述位置
  let g-desc-pos = (
    (g-to-pos + g-from-pos - measure[#if l-e-num != 0 [得到]#if g-e-num > 1 [#g-e-num]$#g-tsign e^-$].width) / 2
  )
  // 得电子的描述
  let g-desc = [
    #h(g-desc-pos)
    #if l-e-num != 0 [得到] #if g-e-num > 1 [$#g-e-num #g-tsign e^-$] else [$e^-$]
  ]

  // 单线桥线
  if g-from-pos == g-to-pos {
    // 特殊的单线桥,自己指向自己
    body += (
      g-desc,
      curve(
        stroke: .5pt,
        curve.move((g-from-pos, 6pt)),
        curve.line((-5pt, -6pt), relative: true),
        curve.line((g-to-pos + 6pt, 0pt)),
        curve.line((-5pt, 6pt), relative: true),
        curve.line((1pt, -4pt), relative: true),
        curve.move((g-to-pos + 1pt, 6pt)),
        curve.line((4pt, -2pt), relative: true),
      ),
      equation,
    )
  } else {
    // 普通的单线桥
    body += (
      g-desc,
      curve(
        stroke: .5pt,
        curve.move((g-from-pos, 6pt)),
        curve.line((0pt, -6pt), relative: true),
        curve.line((g-to-pos, 0pt)),
        curve.line((0pt, 6pt), relative: true),
        curve.line((2pt, -4pt), relative: true),
        curve.move((g-to-pos, 6pt)),
        curve.line((-2pt, -4pt), relative: true),
      ),
      equation,
    )
  }

  // 若为双线桥则继续添加下面的电子转移
  if (l-e-num > 0) {
    // 失电子化学式的开始/结束位置
    let l-from-pos = get-pos(l-from)
    let l-to-pos = get-pos(l-to)

    // 失电子的描述位置
    let l-desc-pos = (
      (l-to-pos + l-from-pos - measure[失去#if l-e-num > 1 [$#l-e-num #l-tsign e^-$] #if l-e-num == 1 [$e^-$]].width)
        / 2
    )

    // 失电子的描述
    let l-desc = [
      #h(l-desc-pos)
      失去#if l-e-num > 1 [$#l-e-num #l-tsign e^-$] #if l-e-num == 1 [$e^-$]
    ]

    body += (
      curve(
        stroke: .5pt,
        curve.move((l-from-pos, 0pt)),
        curve.line((0pt, 6pt), relative: true),
        curve.line((l-to-pos, 6pt)),
        curve.line((0pt, -6pt), relative: true),
        curve.line((2pt, 4pt), relative: true),
        curve.move((l-to-pos, 0pt)),
        curve.line((-2pt, 4pt), relative: true),
      ),
      l-desc,
    )
  }

  stack(
    spacing: 2pt,
    ..body,
  )
}