#let preamble(
  title: str,
  subtitle: str,
  authors: list(),
  supervisors: list(),
  lang: "fr",
  abstract: str,
  cover_image: str,
  thanks: str
) = {
  set align(center)

  // Title & subtitle
  text(20pt, title)
  linebreak()
  linebreak()

  emph(text(16pt, subtitle))
  linebreak()
  linebreak()

  // Image
  cover_image

  // Abstract
  par(justify: false)[
    *Abstract* \
    #abstract
  ]

  if lang == "fr" {
    par(justify: false)[
      *Rédigé par* \
    ]
  } else {
    par(justify: false)[
      *Written by* \
    ]
  }
  // Authors
  let ncols = authors.len()
  grid(
    columns: (1fr,) * ncols,
    row-gutter: 24pt,
    ..authors.map(author => [
      #author.name \
      #author.affiliation \
      #link("mailto:" + author.email)
    ]),
  )


  if lang == "fr" {
    par(justify: false)[
      *Sous la supervision de* \
    ]
  } else {
    par(justify: false)[
      *Under the supervision of* \
    ]
  }
  // Supervisors
  let ncols = supervisors.len()
  grid(
    columns: (1fr,) * ncols,
    row-gutter: 24pt,
    ..supervisors.map(supervisor => [
      #supervisor.name \
      #supervisor.affiliation \
      #link("mailto:" + supervisor.email)
    ]),
  )

  if lang == "fr" {
    par(justify: false)[
      *Terminé le* \
    ]
  } else {
    par(justify: false)[
      *Ended on* \
    ]
  }
  // Today's date
  datetime.today().display("[day]-[month]-[year]")
  pagebreak()

  // Thanks
  set align(left)
  if lang == "fr" {
    text(16pt)[*Remerciements*]
  } else {
    text(16pt)[*Special Thanks*]
  }
  par(justify: true)[
    #thanks
  ]
  pagebreak()

  // Table of contents
  let outline_title = ""
  if lang == "fr" {
    outline_title = "Table des matières"
  } else {
    outline_title = "Table of contents"
  }
  outline(title: outline_title)
  pagebreak()

}