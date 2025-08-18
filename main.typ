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
    Ce rapport présente une modélisation mathématique de réseaux de neurones biologiques occupés à une tâche de mémoire à court-terme, en s'appuyant sur la théorie des chaînes de Markov, l'analyse de la limite de champ moyen et la mesure stationnaire d'une modèle limite.\
    Nous développons un modèle stochastique en temps discret où les neurones évoluent selon des dynamiques de potentiel de membrane couplées à des variables d'activation synaptique. Nous développons également une version limite de notre processus grâce à la limite de champ moyen. La convergence sera rigoureusement établie.\
    Notre nouvelle définition mathématique de la mémoire court-terme se base sur la démonstration d'existence d'une activité neuronale soutenue et persistente sur le long-terme, grâce à la mesure stationnaire de notre processus limite. Les preuves et définitions reposent sur propriétés des chaînes de Markov.\
    Nous calculons explicitement la mesure stationnaire du processus limite en exploitant l'état de régénération naturel du système. L'étude des équilibres de cette mesure stationnaire établit des conditions quantitatives sur les paramètres biologiques (probabilité de spike, taux de désactivation, seuil de potentiel) déterminant l'apparition d'une activité neuronale soutenue.\
    Ces résultats dépassent les approches qualitatives traditionnelles en neurosciences computationnelles en fournissant un cadre mathématiquement rigoureux pour comprendre les mécanismes sous-jacents à la mémoire de travail, avec des prédictions testables sur les conditions d'existence des régimes d'activités persistantes nécessaire au maintien de la mémoire de travail.
  ],
  cover_image: "cover.png",
  thanks: [
    Je tiens à exprimer ma profonde gratitude à ma directrice de mémoire, Prof. Eva Löcherbach, pour son encadrement, ses conseils avisés et sa disponibilité tout au long de ce travail. Son expertise et son soutien ont été essentiels à la réalisation de ce mémoire.\
    Merci aux amis qui ont supporté la fin de rédaction pendant les vacances, à la peluche Dr. Penguin pour son savoir et ses conseils, ainsi qu'à toutes les molécules de glucoses qui ont alimenté mes neurones afin que je modélise d'autres neurones.
  ]
)

= Introduction <intro>
#include "intro.typ"

= Modélisation <section_modele>
#include "modelisation.typ"

= Étude de la chaîne de Markov associée au modèle <section_markov>
#include "markovchain.typ"

= Limite en champ moyen du processus <section_mf>
#include "meanfield.typ"

= Mesure stationnaire du modèle limite <section_mesure_sta>
#include "mesure_sta.typ"

= Conclusion
#include "conclusion.typ"

#bibliography("biblio.bib", title: "Références", style: "apa")
