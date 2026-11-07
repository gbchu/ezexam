#import "@preview/ezexam:0.4.0": *

#show: setup.with(
  mode: EXAM,
  paper: a3,
  show-answer: true,
  show-gap-line: true,
)

#outline()
#chapter[2026新高考I卷]
#title[2026年普通高等学校招生全国统一考试]
#subject[数学]
#secret()
#score-box(y: .35in)
#exam-type[A]
#exam-info(
  info: (命题人: "张三  李四  王五", 审题: "老六", 时间: "120分钟", 满分: tot-pts),
  columns: 2,
)
#notice(
  [答题前，考生务必将自已的姓名、考生号、考场号、座位号填写在答题卡上。],
  [回答选择题时，选择每小题答案后，用铅笔把答题卡上对应题目的答案标号涂黑，如需改动，用橡皮擦干净后，再选涂其他答案标号。回答非选择题时，将答案写在答题卡上，写在本试卷上无效。
  ],
  [考试结束后，请将本试卷和答题卡一并交回。],
)

#set-per-pts(5, 6, 5) // 设置小节每题的分数
= 单选题：本题共 #sec-q-cnt 小题，每小题 #per-pts 分，共 #sec-pts 分.在每小题给出的四个选项中，只有一项是符合题目要求的.
#question[
  样本数据6，8，4，5，12的中位数为 #paren[B]
  #choices(5, 6, 8, 9)
]

#question[
  已知平面向量$bold(a)$,$bold(b)$不共线，且$2bold(a)+y bold(b)=x bold(a)- 3bold(b)$，则
  #paren[A]
  #choices([$x=2，y=-3$], [$x=-2，y=3$], [$x=2，y=3$], [$x=-2，y=-3$])
]

#question[
  已知集合$A = {sin (7pi)/6,cos (5pi)/3,tan (5pi)/4}$，$B = {-sqrt(3)/2,-1/2,1}$，则$A inter B=$ #paren[C]
  #choices(top: 10pt, bottom: 5pt, [${-sqrt(3)/2,-1/2}$], [${-sqrt(3)/2,1}$], [${-1/2,1}$], [${-sqrt(3)/2,-1/2,1}$])
]

#question[
  曲线$y=5x+8ln x$在点$(1,5)$处的切线方程为 #paren[D]
  #choices([$y=3x+2$], [$y=5x$], [$y=8x-3$], [$y=13x-8$])
]

#question[
  已知抛物线$C_1:y^2=2p_1x(p_1>0)$和$C_2:x^2=2p_2y(p_2>0)$均经过点(4,8)，则$C_1$的焦点与$C_2$的焦点之间的距离为#paren[D]
  #choices([12], [$4sqrt(5)$], [6], [$sqrt(65) / 2$])
]

#question[
  已知函数$f(x)=frac(x+2, upright(e)^x+a)$的最大值为1，则$a$= #paren[B]
  #choices($1/2$, 1, $3/2$, 2)
]

#question[
  一百零八塔位于宁夏回族自治区青钢峡市，以其独特的速筑格局和深远的历史文化间名遐迩，该塔群共有108座塔，依山势自上而下排成12行，将第$i$行中塔的座数记为$a_i (i=1,2,dots.c,12)$，其中$a_1=1,a_2=a_3=3,a_4=a_5=5$，且$a_6,a_7,dots.c,a_12$是一个首项为7，公差为2的等差数列，将$a_1,a_2,dots.c,a_12$，分为6组，每组2个数，使得每组的2个数之和可构成一个项数为6且公差为$d(d>0)$的等差数列，则$d=$
  #paren[B]
  #choices(2, 4, 6, 8)
]

#question[
  设$U={(x_1,x_2,x_3) | x_i in {-2,-1,1,2},i=1,2,3}$为空间中64个点构成的集合。点$P(1,1,1)$，记样本空间$Omega = complement_U {P}$。从$Omega$中随机取一个点。定义随机变量$X$如下：对$Omega$中的每个点$A=(x_1,x_2,x_3)$。令$X(A)=x_1+x_2+x_3$，则$X$的数学期望为
  #paren[A]
  #choices([$-1/(21)$], [$-1/(63)$], 0, [$1/7$])
]

= 多选题：本题共 #sec-q-cnt 小题，每小题 #per-pts 分，共 #sec-pts 分.在每小题给出的选项中，有多项符合题目要求.全部选对的得 6 分，部分选对的得部分分，有选错的得 0 分.
#question[
  设$z=3+2"i"$，则 #paren[ACD]
  #choices([$overline(z)=3-2"i"$], [$|z|=5$], [$z^2=5+12"i"$], [$frac(z+3, z-1) in$ *R*])
]

#question[
  在空间中，$A、B$为两个定点，动点$C$到直线$A B$的距离为2，动点$D$到直线$A B$的距离为1，若二面角$C-A B-D$为60°，则
  #paren[BC]
  #choices(
    [$angle C A D gt.slant 60°$],
    [$C D gt.slant sqrt(3)$],
    [当$A B perp C D$时，$C D perp "平面" A B D$],
    [当$A B perp "平面" A C D$时，$A C perp A D$],
  )
]

#question[
  已知圆$C_(1):(x+1)^(2)+y^(2)=1$，圆$C_(2):(x-1)^(2)+y^(2)=1$，圆$C_(3):x^(2)+(y-sqrt(3))^(2)=1$，直线$l:y=k x+b$与$C_(1),C_(2),C_(3)$均有两个交点。记$l$被$C_(1),C_(2),C_(3)$截得的弦长分别为$s_(1),s_(2),s_(3)$，则#paren[BCD]
  #choices(
    [$k$可以取任意实数],
    [满足$s_(1)=s_(2)=s_(3)$的直线共有3条],
    [满足$s_(1)+s_(2)+s_(3)=3$的直线多于3条],
    [当$b=0$时，$s_(1)+s_(2)+s_(3)$的最大值为$frac(2 sqrt(21), 3)$],
  )
]

= 填空题：本题共 #sec-q-cnt 小题，每小题 #per-pts 分，共 #sec-pts 分.
#question[
  双曲线$5x^(2)-6y^(2)=1$的离心率为#fillin[$underline(sqrt(66)/6)$].
]

#question[
  已知$f(x)=2sin(a x+θ)(a in upright(bold(Z)),0 lt.slant θ < 2π)$是偶函数，$f(x)$在区间$(0,frac(π, 2))$单调递增。则

  $θ$=#fillin[$underline((3pi)/2)$]，$f(frac(2π, 3))$=#fillin[~0或2].
]

#question[
  设实数$q$满足：存在数列${a_(n)}$，使得对于任意$n in upright(bold(N))^(*)$，均有$a_(1)+a_(2)+dots.c+a_(3n)=n^(2)+n$，且${a_(n)}$中有某连续9项$a_(k),a_(k+1),dots.c,a_(k+8)$是公比为$q$的等比数列。则$q$的最大值为#fillin[$underline(root(3, 3/2))$].
]

= 解答题：本题共 #sec-q-cnt 小题，共 #sec-pts 分.解答应写出文字说明、证明过程或演算步骤.
#let question = question.with(bottom: .5in)
#question(points: 13)[
  如图，在直三棱柱$A B C-A_(1)B_(1)C_(1)$中，$angle A C B=90°$，$A C=B C$，$D$，$E$分别为$A B$，$A C_(1)$的中点.
  #text-figure(
    figure: image("15.png", height: 1.8in),
    figure-x: 20pt,
    figure-y: 10pt,
  )[
    + 证明：$D E parallel$ 平面$B C C_(1)B_(1)$；
    + 设$C C_(1)=2$，直线$D E$与平面$A C C_(1)A_(1)$所成的角为$45°$，求直线$D E$到平面$B C C_(1)B_(1)$的距离.

  ]
]

#question(points: 15)[
  已知在$triangle A B C$中，$A B = 3$，$B C = 2 sqrt(3)$，$cos B = frac(sqrt(3), 3)$.
  + 求$cos A$；
  + 设$D$，$E$两点满足：$D$在$B A$的延长线上，$D E parallel B C$，$A E perp A C$。若$D E = sqrt(6)$，求$C E$.
]

#question(points: 15)[
  设整数$N gt.slant 2$，某同学用一个球进行投篮练习，至多投篮$N$次，当且仅当投中1次时或$N$次均未投中时，停止练习。设该同学每次投中的概率为$p$
  ($0 < p < 1$)，各次投中与否相互独立。记$X$为停止练习时该同学的投篮次数。
  + 当$N = 4$，$p = frac(1, 3)$时，求$X$的分布列；
  + 设$k$，$m$均为自然数。
    + 当$k lt.slant N - 1$时，求$P(X > k)$；
    + 当$k + m lt.slant N - 1$时，证明：$P(X > k + m | X > k) = P(X > m)$.
]

#question(points: 17)[
  已知椭圆$C:frac(x^(2), a^(2)) + frac(y^(2), b^(2)) = 1$ ($a > b > 0$)的左焦点为$F(-1,0)$，离心率为$frac(1, 2)$。
  + 求$C$的方程；
  + 设$O$为坐标原点，过$F$且斜率大于$0$的动直线$l$与$C$交于$P$，$Q$两点，其中$Q$在第三象限，直线$P O$与$C$的另一个交点为$R$。
    + 若$triangle P Q R$的面积是$triangle P F O$的面积的$3$倍，求$l$的方程；
    + 求$tan angle P Q R$的最小值.
]

#question(points: 17)[
  已知函数$f(x)$的定义域为R，且当$x < 0$时，$f(x) = 2^x$。对任意$x_(0) in "R"$，定义集合$D(x_(0)) = {d in upright(bold(R)) | f(x_(0) + d) > f(x_(0))}$.
  + 若当$x gt.slant 0$时，$f(x) = 1 - x$，求$D(-1)$；
  + 若$f(x)$是奇函数，$f(x_(1)) lt.slant f(x_(2))$，且$x_(1) x_(2)!= 0$，证明：$D(x_(2)) subset.eq D(x_(1))$；
  + 设$f(x)$满足：①若$f(x_(1)) lt.slant f(x_(2))$，则$D(x_(2)) subset.eq D(x_(1))$；②当$0 < x < 1$时，$f(x) < f(0)$。
    + 证明：$f(0) gt.slant 1$；
    + 证明：$f(x)$在区间$(0, +oo)$单调递增.
]

#solution-env[
  #let answer = tag.with(prefix: "答案：", suffix: none)
  = 选择题
  #solution(title: "解析")[
    #answer[B]

    #tag[解析]: #lorem(6)
  ]

  = 填空题
  #solution[
    #answer[$6$]

    #tag[解析]: #lorem(6)
  ]

  = 解答题
  #solution[
    #tag[解析]: #lorem(6)#score(5)
  ]
]
