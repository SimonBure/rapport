#import "rules.typ": *
#import "global_variables.typ": *
// Rule to avoid references error in sub-chapters when compiling local file
// #show: no-ref

// Display settings for theorems and proofs
#show: thmrules.with(qed-symbol: $square$)

Notons #max_potential_limit le nombre de pas de temps minimum nécessaire à un neurone pour que son voltage parte de $0$ et atteigne une valeur supérieure à #max_potential. La valeur de #max_potential_limit dépendra de tous les #unknown_expectation() et donc du temps. Mathématiquement, #max_potential_limit est tel que :
#numbered_equation(
    $ #max_potential_limit =  inf_(I in #integers) {sum_(t=0)^I #unknown_expectation() > #max_potential}. $, <def_max_potentiel_limite>
)

La mémoire de travail est un maintien actif d'une information via l'activité persistante des neurones. Si l'activité est perturbée ou si l'information n'est plus nécessaire, elle est oubliée, libérant les neurones. D'un côté, notre modèle inclut un mécanisme de désactivation (paramètre #deactivation_probability) qui pousse le modèle #chain_limit() vers l'extinction. De l'autre, le mécanisme de facilitation synaptique (spike → activation) tend à maintenir l'activité. Des questions viennent ainsi naturellement : Quelle dynamique l'emporte ? Existe-il un équilibre ? Dans quelles conditions ?

Notre modèle limite de champ moyen décrit la dynamique temporelle des neurones, mais nous voyons que pour comprendre la mémoire de travail, il faut pouvoir décrire la dynamique à long-terme de ces neurones et voir les comportements typiques qui en émergent. Le comportement qui nous intéresse particulièrement est celui où le système peut soutenir une activité persistante. D'un point de vue mathématique, cela peut s'aborder comme un questionnement sur l'existence d'*états d'équilibres actifs* (autre que les états d'absorption) où le système limite pourrait rester indéfiniment et connaître une activité régulière.

La notion d'analyse de l'activité à long-terme (à entendre dans un sens mathématique) nous donne envie d'utiliser la notion de *mesure stationnaire*. Cependant, en l'état, le processus #chain_limit(), n'est pas Markovien, à cause de la dépendance temporelle des #unknown_expectation(). Nous commencerons pour cela à poser l'hypothèse afin de rendre #chain_limit() markovien, afin ensuite de travailler sur la mesure stationnaire qui y sera associée.

Dans cette optique, cette section répondra à plusieurs objectifs :
+ Introduire et définir la mesure invariante, ou stationnaire, pour notre processus limite $#chain_limit() = #neuron_limit()$.
+ Prouver son existence à l'aide de résultats classiques.
+ La calculer pour tous les états du système.
+ Étudier l'existence de ses équilibres et en faire émerger une condition sur les paramètres du modèle.

== Définition et existence
#let gamma_stationnary = unknown_expectation(t: $$)
Le processus limite #chain_limit() n'est, en l'état, pas markovien. C'est à cause des #unknown_expectation(), rendant #chain_limit() dépendant de toute la trajectoire temporelle. Pour retrouver le cadre markovien, nous allons faire l'hypothèse forte, qu'après un temps suffisant $tau$, le processus atteint une version *stationnaire*, où, quelque soit $t > tau$, $#unknown_expectation() = #gamma_stationnary$.\
Délivré de cette dépendance, nous parlerons désormais de #chain_limit() comme d'une chaîne de Markov, dans une version stationnaire où $t > tau$.

De façon générale pour notre modèle, la mesure stationnaire est une *mesure de probabilité* descriptive de l'état "moyen" de la chaîne de Markov #chain_limit() après un temps long. Dans notre contexte, elle représente la *proportion de temps* qu'un neurone passe dans chaque état $(v, a)$. Il est aussi possible de la voir comme la *proportion de neurones* dans chaque état $(v, a)$.

Pour prouver l'*existence* de cette mesure et garantir son *unicité*, appuyons-nous sur les résultats classiques en probabilités. Si nous pouvons montrer que notre chaîne de Markov limite #chain_limit() est *irréductible* et *apériodique* sur son espace d'états fini $#space_potentiel_mf times {0, 1}$, nous aurons montré qu'une unique mesure stationnaire existe.

=== Existence
#theorem([Existence et unicité de la mesure stationnaire associée à #chain_limit()])[
  Il existe une unique mesure stationnaire, notée #mesure_stationnaire(), associée à la chaîne de Markov #chain_limit().
]<thm_unique_mesure_stationnaire>
#proof()[
  En prouvant @lemme_chaine_limite_irr et @lemme_aperiodicite plus bas, nous prouvons le @thm_unique_mesure_stationnaire.
]

#lemma("Irréductibilité de la chaîne limite")[
  La chaîne de Markov #chain_limit() est irréductible sur son espace d'état #space_chain_limit.
] <lemme_chaine_limite_irr>
#proof()[
  Cette preuve est philosophiquement similaire à la preuve du @theoreme_irreductibilite. Elle reste cependant plus simple grâce à plusieurs points importants. La @rmk_non_absorption_chaine_limite nous dit que la chaîne limite #chain_limit() ne peut pas être absorbée du fait de l'ajout des contributions moyennes #unknown_expectation() à chaque pas de temps. Il n'y a donc pas d'états absorbants ou presque-absorbants qui pourraient poser problème.

  Par contrainte temporelle, ce qui est proposé ici est seulement une ébauche de preuve. Nous allons montrer qu'il est possible, à partir d'un état quelconque $x in #space_chain_limit$ d'atteindre un état de référence $y$ avec probabilité positive. Ensuite, nous établirons qu'à partir d'$y$, n'importe quel état $z in #space_chain_limit$ est atteignable avec probabilité positive.

  // Nous utiliserons les même notations pour les opérations que pour la preuve du @theoreme_irreductibilite. Ces opérations peuvent toujours advenir avec probabilité positive, puisque notre chaîne limite #chain_limit() ne peut jamais être absorbée.

  Soit $y$ l'état où :
  - tous les neurones sont dans la couche la plus haute définie en @def_max_potentiel_limite (c'est-à-dire #max_potential_limit dans le cas de la chaîne limite #chain_limit()) : $#mesure_couche(state: $y$, v: max_potential_limit) = N$.
  - tous les neurons sont actifs : $#mesure_activation(state: $y$, a: $1$) = N$.
  Cet état est facilement atteignable à partir de n'importe quel état $x$. Il suffit d'abord d'attendre #max_potential_limit pas de temps sans aucun saut, amenant tous les neurones à la couche #max_potential_limit. Puis ensuite d'effectuer $N$ sauts, activant tous les neurones. Enfin, dans le cas où $N < #max_potential_limit$, il suffit d'attendre encore $#max_potential_limit - N$ pas de temps pour avoir de nouveau tous les neurones dans la couche #max_potential_limit. Toutes les étapes précédentes ont une probabilité positive d'advenir par construction du modèle limite.

  Finalelement, nous pouvons nous douter (et c'est la partie moins formelle de cette preuve) qu'atteindre un état $z$ soit possible à partir de $y$ en faisant spiker les neurones dans le bon ordre pour que tous atteignent leur couche finale dans $z$ (tout en corrigeant pour prendre en compte les ajouts #unknown_expectation() à chaque pas de temps). Nous n'irons malheureusement pas plus loin par manque de temps.
]

#lemma("Apériodicité de la chaîne limite")[
  La chaîne de Markov #chain_limit() est apériodique sur son espace d'état #space_chain_limit.
]<lemme_aperiodicite>
#proof()[
  Le plus simple dans notre cas est de montrer que notre chaîne de Markov #chain_limit() peut, sur un état quelconque $x in #space_chain_limit$, rester dans cet état avec probabilité positive.

  Prenons l'état $x$ tel que tous les neurones soient actifs, et à la couche #max_potential_limit, soit
  $ #mesure_activation() = #mesure_couche(v: max_potential_limit) = N. $
  Il, peut avec probabilité positive et égale à $(1 - #deactivation_probability)^N times (1 - #spiking_probability)^N$ rester dans cet état.
]

=== Définition
Pour définir la *mesure stationnaire*, nous utiliserons le résultat classique suivant :\
Si $r$ est un état régénérant pour une chaîne de Markov #chain(), alors la mesure stationnaire se définit par :\
Soit $x$, un état quelconque du système. Notons $pi$ la mesure stationnaire associée à #chain()
$ pi(x) = (#expectation("Temps passé en x entre deux visites de r")) / (#expectation("Temps entre deux visites de r")) $

Il nous faut donc trouver un état régénérant pour notre système, afin de définir toutes les quantités nécessaire pour calculer #mesure_stationnaire().

== État régénérant
Un état est dit "régénérant" pour notre chaîne #chain_limit() si, en le visitant le processus oublie son passé et peut être considéré comme "redémarrant de zéro". Formellement, si $T_r$ est le premier temps de visite de l'état régénérant :
$
  #proba_conditional(chain_limit(t: $T_r + s$), filtration(t: $T_r$)) = #proba_conditional(chain_limit(t: $s$), $#chain_limit(t: $0$) = r$).
$

Pour notre système, remarquons que :

#remark()[
  L'état #regenering_state est un état de régénération pour la chaîne #chain_limit().
]
Cette remarque s'établit pour plusieurs raisons structurelles :
- Après un potentiel d'action, un neurone termine toujours dans l'état #regenering_state peu importe sa trajectoire passée.
- Depuis #regenering_state, le neurone peut reprendre un cycle complet d'accumulation de potentiel.
- La futur évolution à partir de #regenering_state ne dépend que de #regenering_state et non pas de son historique complet.

Introduisons maintenant $#time_before_regen$, le temps *aléatoire* entre deux visites de la chaîne en #regenering_state. Formellement :
$
  #time_before_regen = inf{t > 0 : #chain_limit() = #regenering_state "sachant que" #chain_limit(t: $0$) = #regenering_state}.
$

En partant de #regenering_state, un neurone de notre système limite passe par deux dynamiques successives :
- Croissance *déterministe* du potentiel : le neurone gagne à chaque pas de temps un voltage égal #unknown_expectation(), jusqu'à ce que $#membrane_potential() > #max_potential$. Cette phase dure un temps déterministe égal au nombre de #unknown_expectation() nécessaire pour dépasser #max_potential. Ce nombre a été appelé #max_potential_limit dans la @section_mf, mais nous l'appelerons simplement $K$ dans la suite de cette partie.
#let max_potential_limit = $K$
- Potentiel d'action *aléatoire* : le neurone peut spiker, toujours avec probabilité #spiking_probability. Ce faisant, le temps passé avant d'effectuer ce spike suit une loi géométrique de paramètre #spiking_probability.
Bien sûr, il peut également toujours se désactiver avec probabilité #deactivation_probability.

Ainsi, pour calculer #mean_time_before_regen, il suffit de sommer la durée de ces deux phases, ce qui donne lieu à la remaque suivante :

#remark()[
  $ #mean_time_before_regen = #value_mean_time_before_regen. $
]<valeur_temps_avant_regen>

Avant de pouvoir correctement définir la mesure stationnaire de #chain_limit(), nous devons définir le temps moyen passé en $x$ dans le contexte de notre système de neurones. Soit l'état quelconque $(v, a)$, ce temps vaut classiquement : #mean_time_spent_in_state(state: $(v, a)$)

Avec cette information et la @valeur_temps_avant_regen, nous écrivons maintenant la définition de la mesure stationnaire de #chain_limit() :
$ #mesure_stationnaire() = #mean_time_spent_in_state(state: $(v, a)$) / #value_mean_time_before_regen. $

Maintenant que la définition est correctement posée, nous pouvons calculer cette mesure stationnaire pour les différents états possibles.

== Calcul de la mesure stationnaire
Son calcul va dépendre des valeurs prises par $v$.

=== Cas où $v < #max_potential_limit #unknown_expectation_inf$
#let probability_no_deactivation_before_v = $(1 - #deactivation_probability)^v$
Dans le cas présent, #time_spent_in_state() vaut exactement un si le neurone ne subit aucune désactivation avant la couche $v$, ce qui arrive avec probabilité #probability_no_deactivation_before_v. S'il se désactive avant $v$, alors #time_spent_in_state() est nulle.\
Ainsi, pour $v < #max_potential_limit #unknown_expectation_inf$,
$ #mean_time_spent_in_state() = #probability_no_deactivation_before_v. $

#let probability_deactivation_before_v = $1 - #probability_no_deactivation_before_v$
De façon similaire, pour $a = 0$, #time_spent_in_state(state: $(v, 0)$) vaut un si le neurone subit une désactivation avant la couche $v$, ce qui arrive avec probabilité #probability_deactivation_before_v. Sinon, le temps passé dans l'état $(v, 0)$ est nul. D'où,
$ #mean_time_spent_in_state(state: $(v, 0)$) = #probability_deactivation_before_v. $

Finalelement, nous avons
$
  forall v < K gamma,space #mesure_stationnaire(state: $(v, 1)$) = #probability_no_deactivation_before_v / #value_mean_time_before_regen,
$
ainsi que
$ #mesure_stationnaire(state: $(v, 0)$) = #probability_deactivation_before_v / (#value_mean_time_before_regen). $

=== Cas où $v = #max_potential_limit #unknown_expectation_inf$
#let time_before_spike = $T_#spiking_probability$
#let time_before_deactivation = $T_#deactivation_probability$
Ici, le neurone peut, avec probabilité positive, passer un temps plus long qu'un pas de temps dans l'état $(#max_potential_limit, 1)$. Le neurone quittera l'état $(#max_potential_limit, 1)$ lors de l'émission d'un spike, ou après une désactivation.\
Si nous notons #time_before_spike le temps aléatoire avant l'émission d'un spike et #time_before_deactivation, le temps aléatoire avant la désactivation du neurone, nous pouvons alors écrire que :
$
  #mean_time_spent_in_state(state: $(#max_potential_limit, 1)$) &= bb(E)[min(#time_before_spike, #time_before_deactivation)].
$

Comme #time_before_spike suit une loi géométrique de paramètre #spiking_probability et #time_before_deactivation suit une loi géométrique de paramètre #deactivation_probability, nous avons :
#numbered_equation(
  $
    #mean_time_spent_in_state(state: $(#max_potential_limit, 1)$) = 1 / (#spiking_probability + #deactivation_probability).
  $,
  <valeur_temps_moyen_passe_etat_K_1>,
)

Avec @valeur_temps_avant_regen et @valeur_temps_moyen_passe_etat_K_1, nous aboutissons donc à la mesure stationnaire suivante pour l'état $(#max_potential_limit, 1)$ :
#let mesure_stat_valeur_K_1 = $1 / ((#value_mean_time_before_regen)(#spiking_probability + #deactivation_probability))$
#numbered_equation(
  $ #mesure_stationnaire(state: $(#max_potential_limit, 1)$) = #mesure_stat_valeur_K_1. $,
  <mesure_stationnaire_K_1>,
)

Enfin, pour l'état $(K gamma, 0)$, étant donné que $pi$ est une mesure de probabilité, nous pouvons écrire :
$
  #mesure_stationnaire(state: $(K gamma, 0)$) = 1 - (sum_(a=0)^1 sum_(v=0)^((K-1) gamma) #mesure_stationnaire() + #mesure_stationnaire(state: $(#max_potential_limit, 1)$).
$

Étudions à présent les équilibres de la mesure #mesure_stationnaire(), afin de placer la chaîne #chain_limit() dans un cadre où elle pourrait manifester une activité régulière.

== Équilibres de la mesure stationnaire
L'objectif de cette section est de caractériser les *régimes de mémoire persistante* : les configurations où notre système se maintient dans une configuration constante, pour maintenir indéfiniment une activité neuronale. Nous voulons que le système garde une proportion constante de neurones à chaque niveau de potentiel, garantissant un flux régulier de potentiels d'action.

Dans notre modèle limite (infinité de neurones), la proportion de neurones effectuant un spike les temps $t$ et $t+1$ est égale à #unknown_expectation(). Rappellons-nous (@section_mf) que la proportion inconnue #unknown_expectation() est aussi égale à l'ajout de potentiel entre $t$ et $t+1$ pour tous les neurones. Résumé en une ligne :
$
  "proportion de neurones spikant" = "ajout de potentiel aux potentiels de tous les neurones" = #unknown_expectation().
$

Si, à long-terme, la proportion de neurones dans chaque état est égale à la proportion de neurones spikant, alors le système aura atteint une configuration "constante", se maintenant à l'identique indéfiniment. Cela se traduit par l'équation d'équilibre :
#numbered_equation(
  $ #mesure_stationnaire() = #unknown_expectation(), $,
  <eq_equilibre>,
)

En reprenant la définition de #unknown_expectation(), nous pourrons trouver les conditions sur les paramètres biologiques où @eq_equilibre admet une solution. Cependant, cela nécessite de changer la définition de #max_potential_limit pour utiliser une version utilisable dans nos calculs.

=== Nouvelle définition de #max_potential_limit
#let unknown = unknown_expectation(t: $$)
À la place de @def_max_potentiel_limite, nous allons utiliser la définition suivante, plus maniable :
$ #max_potential_limit = ceil(#max_potential / #unknown_expectation_inf). $
Rappellons que #unknown_expectation_inf représente la plus petite valeur prise par #unknown_expectation() sur l'intervalle #time_window. Ainsi, #max_potential_limit devient le maximum possible de pas à effectuer pour dépasser de façon certaine le seuil de #max_potential. Cela revient par ailleurs à considérer de nouveau #membrane_potential_limit() comme prenant des valeurs sur un "escalier de potentiel", où chaque marche vaut #unknown_expectation_inf.

Pour plus de simplicité, nous noterons par la suite #unknown_expectation_inf = #unknown.

Développons @eq_equilibre en se rappellant de @definition_unknown_expectation :
$
  #unknown = #expectation(network_contributions_limit(t: time_inf)) &= #expectation($#spiking_function(v: membrane_potential_limit(t: time_inf)) #activation_limit(t: time_inf)$),\
  &= sum_(a=0)^1 sum_(k = 0)^#max_potential_limit #spiking_function(v: $k #unknown$) dot a dot #mesure_stationnaire(state: $(k #unknown, a)$).
$
Or, comme #spiking_function(v: $v$) est nulle tant que $v < #max_potential$, tous les termes, sauf celui où $k = #max_potential_limit$ vont s'annuler, laissant ainsi :
$
  #unknown = #spiking_function(v: $#max_potential_limit #unknown$) #mesure_stationnaire(state: $(#max_potential_limit #unknown, 1)$),
$
soit, avec @mesure_stationnaire_K_1 :
$ #unknown = #spiking_probability #mesure_stat_valeur_K_1. $

#let fonction_sauts = $ceil(#max_potential / #unknown)$
#let point_eq = $#spiking_probability / ((#fonction_sauts + 1/#spiking_probability)(#spiking_probability + #deactivation_probability))$
Ainsi trouver les points d'équilibre de la mesure stationnaire revient à résoudre l'équation suivante :
#numbered_equation($ f(#unknown) = #unknown - #point_eq = 0. $, <equation_equilibre>)

À cause de la fonction partie entière, cette équation n'est pas triviale à résoudre.\
Premièrement, pour $#unknown -> 0$, l'@equation_equilibre admet une solution, triviale, correspondant à l'absorption du système en zéro. Cette absorption correspond à l'état d'oubli de l'élément mémoriel.

Cependant, nous sommes à la recherche d'équilibres non nuls qui pourraient correspondre à une configuration constante avec une activité neuronale persistante.

Grâce à @allure_f_gamma, et à @equation_equilibre, nous pouvons voir que $f$ est une fonction *continue par morceau* et *croissante*.

Énonçons la proposition @existence_equilibres, nous donnant une condition suffisante pour assurer l'existence d'un équilibre non trivial à @equation_equilibre.

#figure(
  image("figures/allure_f_gamma.png"),
  caption: [Représentation de $f$ pour #unknown compris entre $0$ et $1$, avec $#max_potential = 3$, $#spiking_probability = 0.9$ et $#deactivation_probability = 0.09$.],
)<allure_f_gamma>

#let point_eq_1 = $#spiking_probability / ((1 + 1/#spiking_probability)(#spiking_probability + #deactivation_probability))$
#proposition()[
  Si
  $ #max_potential < #point_eq_1, $
  alors il existe au moins une solution pour @equation_equilibre.
]<existence_equilibres>
#proof()[
  Suppons que $#unknown > #max_potential$. Ceci implique que $#max_potential_limit_val = 1$. Ainsi, pour tout $#unknown > #max_potential$, le nombre #point_eq devient une *constante*, égale à #point_eq_1.
  #let intervalle_continue = $[#max_potential, 1]$
  Ce qui veut dire que tant que $#unknown$ se trouve dans l'intervalle #intervalle_continue, la fonction $f$ est *continue*.

  Et donc si jamais l'équilibre #point_eq_1 se trouve aussi dans #intervalle_continue, alors il sera nécessairement atteint, puisque la fonction est continue sur ce même intervalle. D'où la condition suffisante suivante :
  $ #max_potential < #point_eq_1, $
  concluant la preuve. Le tout est illustré sur la @f_gamma_un_equilibre.
]

#remark([$f$ peut admettre d'autres équilibres grâce aux sauts de $#fonction_sauts$])[
  Si jamais $#max_potential > #point_eq_1$, un ou plusieurs équilibres peuvent tout de même exister, grâce aux sauts de la fonction $#fonction_sauts$. Ceci est illustré grâce à la @f_gamma_plsrs_equilibres.
]

#let beta = 0.9
#let lambda = 0.09
#let theta = 1
#let point_eq_1_valeur = beta / ((1 + 1 / beta) * (beta + lambda))
#figure(
  image("figures/f_gamma_one_equilibre.png"),
  caption: [Représentation de $f$ pour #unknown compris entre $0$ et $1$. Ici $#max_potential = 0.2$, $#spiking_probability = 0.9$ et $#deactivation_probability = 0.09$. Pour cette combinaison de paramètres, le point d'équilibre est $#unknown = #point_eq_1 = #point_eq_1_valeur$. Nous avons donc bien $#max_potential < #point_eq_1$. et $f$ coupe proprement l'axe des abscisses en #point_eq_1.],
)<f_gamma_un_equilibre>


#figure(
  image("figures/f_gamma_many_equilibres.png"),
  caption: [Illustration de la présence de plusieurs équilibres. Ici $#max_potential = 0.5$, $#spiking_probability = 0.9$ et $#deactivation_probability = 0.09$, donnant $#max_potential > #point_eq_1$. Pourtant, $f(#unknown)$ s'annule deux fois dans l'intervalle $(0, #max_potential]$.],
)<f_gamma_plsrs_equilibres>
