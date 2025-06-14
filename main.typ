#import "@preview/ctheorems:1.1.3": *

#import "rules.typ" : *

// Theorem box and proof box
#show: thmrules.with(qed-symbol: $square$)
#let theorem = thmbox("theorem", "Théorème", base_level: 1, stroke: red+1.4pt)
#let lemma = thmbox("theorem", "Lemme", base_level: 1, stroke: 1.4pt)
#let proposition = thmbox("theorem", "Proposition", base_level: 1, stroke: blue+1.4pt)
#let proof = thmproof("proof", "Preuve")


// Headings general set up
#set heading(numbering: "1.")

// Text general set up
#set text(lang: "fr")

// Paragraph general set up
#set par(justify: true)

#let test = "test"

= Introduction
//#include "intro.typ"

= Modélisation
#include "modelisation.typ"

= Étude de la chaîne de Markov associée
//#include "markovchain.typ"

= Limite en champ moyen du processus
//#include "meanfield.typ"

= Mesure invariante
