#let emphdot(text) = {
  context stack(
    spacing: 2pt,
    text,
    line(
      length: measure(text).width,
      stroke: (dash: "dotted", thickness: 1pt),
    ),
  )
}

// 使用
#emphdot[这是需要加着重号的文本]


#underline(
  stroke: (dash: none, paint: black),
  offset: 3pt,
  extent: -10pt
)[需要加着重号的文字]
