#import "const-state.typ": hei-ti
// 一种页码格式: "第x页（共xx页）
#let zh-arabic(prefix: "", suffix: "") = (..nums) => {
  let arr = nums.pos()
  [#prefix 第#str(arr.at(0))页（共#str(arr.at(-1))页）#suffix]
}

#let multi = text(maroon)[（多选）]

#let tag(body, color: blue, font: auto, prefix: "【", suffix: "】") = context {
  let _font = font
  if font == auto { _font = text.font.slice(0, 1) + hei-ti }
  text(font: _font, color)[#prefix#body#suffix]
  h(.1em, weak: true)
}

#let underdot(body) = {
  assert(type(body) == str or body.func() == text, message: "expected str or text")

  let _body = body
  if type(body) == content { _body = body.text }

  for value in _body {
    box(
      baseline: 49%,
      grid(
        align: center,
        value,
        $dot$,
      ),
    )
  }
}
