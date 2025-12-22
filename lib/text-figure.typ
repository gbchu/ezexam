// 图文混排(左文右图)
#let text-figure(
  figure: none,
  figure-x: 0pt,
  figure-y: 0pt,
  top: 0pt,
  bottom: 0pt,
  gap: 0pt,
  align: horizon,
  style: "tf",
  text,
) = context {
  assert(style == "tf" or style == "ft", message: "style must be 'tf' or 'ft'")
  let (width, height) = measure(figure)
  let body = (
    text,
    place(dx: figure-x, dy: figure-y, align, box(height: height, figure)), // 使用box设置高度是为了确保有足够的高度，否则图片可能会显示不全
  )

  let _columns = (1fr, width)
  let _gap = -figure-x + gap
  if style == "ft" {
    body = body.rev()
    _columns = _columns.rev()
    _gap = figure-x + gap
  }

  // 检测是否需要换页
  let _page-height = page.height
  if page.flipped { _page-height = page.width }
  if _page-height - page.margin - here().position().y < height / 2 {
    colbreak()
  }

  grid(
    columns: _columns,
    inset: (
      top: top,
      bottom: bottom,
    ),
    gutter: _gap,
    ..body,
  )
}
