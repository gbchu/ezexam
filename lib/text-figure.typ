// 图文混排(左文右图)
#let text-figure(
  figure: none,
  figure-x: 0pt,
  figure-y: 0pt,
  top: 0pt,
  bottom: 0pt,
  gap: 0pt,
  style: "tf",
  text,
) = context {
  assert(style == "tf" or style == "ft", message: "style must be 'tf' or 'ft'")
  let (width, height) = measure(figure)
  let body = (
    text,
    [ \ ] + box(place(dx: figure-x, dy: figure-y - par.leading * 2, figure)),
  )

  let _columns = (1fr, width)
  let _gap = -figure-x + gap
  if style == "ft" {
    body = body.rev()
    _columns = _columns.rev()
    _gap = figure-x + gap
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
