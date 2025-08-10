#import "rules.typ": *
#import "global_variables.typ": *
#import "preamble.typ": preamble
// Theorem box and proof box
#show: thmrules.with(qed-symbol: $square$)

// Headings general set up
#set heading(numbering: "1.")

// Text general set up
#let lang = "fr"
#set text(lang: lang)

// Pages general set up
#let name = "Simon Buré"
#let institution = "Université Paris-Saclay & Institut Polytechnique de Paris"
#let header_footer_text_size = 10pt
#set page(
  paper: "a4",
  header : [
    #set text(header_footer_text_size)
    #smallcaps[Mémoire de stage]
    #h(1fr) #smallcaps(institution)
  ],
  footer : context [
    #set text(header_footer_text_size)
    #smallcaps(name)
    #h(1fr) #counter(page).display()
  ],
)

// Paragraph general set up
#set par(justify: true)

// Preamble : title page + thanks + outline
#preamble(
  title: "Mémoire de stage de fin de Master",
  subtitle: "Modélisation de la mémoire de court-terme et processus de Markov neuronaux en temps discret",
  authors: (
    (
      name: "Simon Buré",
      affiliation: [#image("upsaclay.svg",width: 25%)#image("ip_paris.svg", width: 50%)],
      email: "simon.bure@etu-upsaclay.fr",
    ),
  ),
  supervisors: (
    (
      name: "Prof. Eva Löcherbach",
      affiliation: image("sorbonne.svg", width: 50%),
      email: "Eva.Locherbach@univ-paris1.fr",
    ),
  ),
  lang: lang,
  abstract: [
    Ce rapport présente une modélisation mathématique du processus de mémoire de court-terme, en s'appuyant sur la théorie des chaînes de Markov. Nous étudions un modèle de neurones spiking en temps discret, où les neurones sont activés par des stimuli et peuvent se désactiver après un certain temps. Nous analysons les propriétés de ce processus, notamment sa convergence vers un état stationnaire et son comportement en champ moyen. Enfin, nous discutons des implications de ces résultats pour la compréhension des mécanismes neuronaux sous-jacents à la mémoire.
  ],
  cover_image: "cover.png",
  thanks: [
    Je tiens à exprimer ma profonde gratitude à ma directrice de mémoire, Prof. Eva Löcherbach, pour son encadrement, ses conseils avisés et sa disponibilité tout au long de ce travail. Son expertise et son soutien ont été essentiels à la réalisation de ce mémoire.
  ]
)

= Introduction
#include "intro.typ"

@andreQuasiStationaryApproachMetastability2025
@bremaudDiscreteProbabilityModels2017
@darrochQuasiStationaryDistributionsAbsorbing1965

= Modélisation <section_modele>
#include "modelisation.typ"

= Étude de la chaîne de Markov associée <section_markov>
#include "markovchain.typ"

= Limite en champ moyen du processus <section_mf>
#include "meanfield.typ"

= Mesure stationnaire du modèle limite <section_mesure_sta>
#include "mesure_sta.typ"

= Distribution quasi-stationnaire <section_qsd>

= Conclusion
#include "conclusion.typ"

#bibliography("biblio.bib", title: "Références", style: "apa")

= Annexes
#include "appendix.typ"

#check-labels()
