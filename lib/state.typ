#let mode-state = state("mode", auto)
#let answer-state = state("answer", false)
#let answer-color-state = state("answer-color", blue)
#let subject-state = state("subject", none)
#let chapter-pages-state = state("chapter-pages", ()) // 章节的第一页、最后一页、总页码
#let page-restart-state = state("page-restart", 0)
#let section-data-state = state("section-data", ()) // 各板块的题目数量和分值
#let current-section-state = state("current-section", -1) // 当前板块的索引
