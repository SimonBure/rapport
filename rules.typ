#import "@preview/ctheorems:1.1.3": *

// Theorems and proofs set up
#let theorem = thmbox("theorem", "Théorème", base_level: 1, stroke: navy + 1.4pt)
#let lemma = thmbox("theorem", "Lemme", base_level: 1, stroke: blue + 1.4pt)
#let corrolary = thmbox("theorem", "Corollaire", base_level: 1, stroke: aqua + 1.4pt)
#let proposition = thmbox("theorem", "Proposition", base_level: 1, stroke: teal + 1.4pt)
#let remark = thmbox("theorem", "Remarque", base_level: 1, stroke: gray + 1.4pt)
#let proof = thmproof("proof", "Preuve")

#set math.equation(numbering: "1.")

#let check-labels() = context {
  let targets = query(ref).map(x => x.target)
  let unreferenced = query(selector.or(
    figure,
    math.equation,
    // ... add other referencable elements here
  )).map(x => x.at("label", default: none))
    .filter(x => x != none and x not in targets)

  if unreferenced.len() > 0 {
    panic("Unreferenced labels found in the document. Please check the following labels:",
      unreferenced.map(str).join(", ")
    )
  }
}

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
