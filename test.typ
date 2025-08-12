#import "/ezexam.typ": *
#show: setup.with(show-watermark: true, show-gap-line: true, /* paper: a3 */ watermark: "ezexam")

#lorem(500)

// #let pat = tiling(size: (30pt, 30pt))[
//   #place(line(start: (0%, 0%), end: (100%, 100%)))
//   #place(line(start: (0%, 100%), end: (100%, 0%)))
// ]

// #place(center + horizon)[
//   #rotate(45deg)[#rect(fill: pat, width: 100%, height: 60pt, stroke: 1pt)]
// ]
