#import "@preview/ctheorems:1.1.3": *

// Theorems and proofs set up
#let theorem = thmbox("theorem", "Théorème", base_level: 1, stroke: red+1.4pt)
#let lemma = thmbox("theorem", "Lemme", base_level: 1, stroke: 1.4pt)
#let proposition = thmbox("theorem", "Proposition", base_level: 1, stroke: blue+1.4pt)
#let proof = thmproof("proof", "Preuve")

// Numbered equation
#let numbered_equation(content, label) = [#set math.equation(numbering: "(1)")
#content #label
]

// Define a TO-DO
#let todo(text) = [*TO-DO : #text*]

// Unreference to avoid reference error for sub-chapter
#let no-ref(it) = {
  show ref: _ => [[?]]
  it
}
