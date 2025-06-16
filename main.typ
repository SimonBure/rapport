#import "rules.typ" : *
#import "global_variables.typ": *

// Theorem box and proof box
#show: thmrules.with(qed-symbol: $square$)

// Headings general set up
#set heading(numbering: "1.")

// Text general set up
#set text(lang: "fr")

// Paragraph general set up
#set par(justify: true)

#let test = "test"

= Introduction
#include "intro.typ"

= Modélisation
#include "modelisation.typ"

= Étude de la chaîne de Markov associée
#include "markovchain.typ"

= Limite en champ moyen du processus
#include "meanfield.typ"

= Mesure invariante
