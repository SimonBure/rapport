#import "rules.typ": *
#import "global_variables.typ": *
// Rule to avoid references error in sub-chapters when compiling local file
#show: no-ref

// Display settings for theorems and proofs
#show: thmrules.with(qed-symbol: $square$)

== Espace des états dans lequel évolue la chaîne
Chaque neurone peut prendre des valeurs dans l'espace ${0,1,...,#max_potential}times{0,1}$. Le nombre d'état possible est ainsi $2(#max_potential + 1)$. Pour un système à N neurones évoluant dans l'espace $cal(X) = ({0,1,...,#max_potential}times{0,1})^N$, le nombre d'états est donc $abs(cal(X)) = 2(#max_potential + 1)N$.

== Transitions de la chaîne de Markov
Soit $x in cal(X)$ un état possible du système de neurones. Nous notons $ x = vec(x_1, dots.v, x_N) "avec" x_i = (v_i, a_i). $ Nous avons bien sûr $x_i in {0, 1, dots, #max_potential}times{0, 1}, space forall i in {1, dots, N}$.\
Depuis cet état $x$, nous définissons trois transitions élémentaires possibles, vers un état $y in cal(X)$ :
- *Spike inefficace menant à l'activation d'un neurone* : notons $i$ l'indice du neurone effectuant le spike. La transition suivante survient avec probabilité $beta$ : $ vec((v_1, a_1), (v_2, a_2), dots.v, (v_i, a_i) = (#max_potential, 0), dots.v, (v_N, a_N)) --> vec((v_1, a_1), (v_2, a_2), dots.v, (v_i, a_i) = (0, 1), dots.v, (v_N, a_N)). $

- *Désactivation d'un neurone* : ici aussi, $i$ est l'indice $i$ du neurone se désactivant. Le système subit la transition suivante avec probabilité $lambda$, $ vec((v_1, a_1), dots.v, (v_i, a_i) = (v_i, 1), dots.v, (v_N, a_N)) --> vec((v_1, a_1), dots.v, (v_i, a_i) = (v_i, 0), dots.v, (u_N, f_N)). $

- *Spike efficace* : ici encore, nous notons $i$ l'indice du neurone effectuant le spike. La transition survient avec probabilité #spiking_probability, et s'écrit comme suit :
$ vec((v_1, a_1), dots.v, (#max_potential, 1), dots.v, (v_N, a_N)) --> vec(([v_1 + 1] and #max_potential, a_1), dots.v, (0, 1), dots.v, ([v_N +1] and #max_potential, a_N)). $

Ces trois transitions élémentaires sont *mutuellement exclusives*, c'est-à-dire que, dans un même intervalle de temps (entre $t$ et $t+1$), un neurone d'indice $i$ ne peut pas se désactiver puis faire une spike inefficace (ou bien effectuer un spike efficace puis se désactiver). Par contre, les $N$ neurones du système dans son ensemble peuvent tout à fait tous, ou en partie, subir une transition de façon indépendante. 
Par exemple, pour un système contenant $N=10$ neurones dans les bonnes configuration, nous pourrions tout à fait avoir $3$ spikes efficaces, $0$ spike inefficace, et $5$ désactivations pendant le même intervalle temporel.


== Mesure empirique
// Variables
#let mesure_empirique(state: $x$, v: $v$, a: $a$) = $#state^N_(#v, #a)$
#let mesure_couche(state: $x$, v: $v$) = mesure_empirique(state: state, v: v, a: $dot$)

La mesure empirique associée à une chaîne de Markov permet de représenter d'une nouvelle façon notre système de neurones. Cette représentation se focalise sur les _couches_ de potentiel de membrane plutôt que sur les neurones individuels (total de $#max_potential + 1$ couches).\
En language classique, notre mesure empirique permet de compter le nombre de neurones présent à une couche $v$ et dans un état d'activation $a$ quelconques.\
Dans le cas présent, la mesure empirique est elle-même une chaîne de Markov définie en plus sur un espace d'états plus petit. L'explication sera donnée un peu plus tard.
#todo("Expliquer pourquoi la mesure empirique est aussi une chaîne de Markov")

Soit $x$ un état arbitraire de notre chaîne de Markov #chain() à $N$ neurones. En notant #mesure_empirique(), la mesure empirique du système, nous écrivons la définition suivante, pour tout $v in #space_value_potential$ et tout $a in #space_value_activation$ :
#numbered_equation($ #mesure_empirique() = sum_(i=1)^N #dirac($(#membrane_potential(), #activation())$) (v, a). $, <def_mesure_empirique>)

Introduisons également la notation suivante #mesure_couche(), qui nous sera utile pour compter le nombre de neurones possédant un potentiel de membrane $v$, toute variable d'activation confondue. Elle se définit par
#numbered_equation($ #mesure_couche() = sum_(i = 1)^N #dirac($(#membrane_potential(), #activation())$) (v, 0) + #dirac($(#membrane_potential(), #activation())$) (v, 1). $, <def_mesure_couche>)
 
Pour compter le nombre d'états possibles, il suffit de se référer au problème canonique de combinatoire : le nombre de façon de séparer un nombre $n$ de $star$ par un nombre $m$ de $|$. Cela donne
$ abs(cal(X)) = vec(N - 2#max_potential + 1, 2#max_potential + 1). $
#todo("Donner exemple avec 5 étoiles et 2 barres ?")

== Espace absorbant
=== États absorbants
Le système n'émettra plus aucun saut lorsque :
- aucun neurone ne se trouve dans un état permettant un spike,
- tous les neurones sont désactivés.
Un état absorbant $cal(a)$ se définit donc de la façon suivante :
$ cal(a) = vec((v_1, 0), (v_2, 0), dots.v, (v_N, 0)), space forall v_i < #max_potential. $

=== États presque-absorbants
Autour de ces états absorbants existent aussi des états qui mènent nécessairement vers un état absorbant après quelques pas de temps. Nous les appellerons les états _presque-absorbants_.\
C'est le cas par exemple des systèmes où aucun neurone n'est en capacité de spiker où tous les potentiels de membrane sont inférieurs à #max_potential. En temps fini, les neurones vont se désactiver un à un jusqu'à atteindre l'état absorbant.\
Un autre exemple est celui du système ayant deux neurones actifs dans la couche #max_potential, mais dont le reste des neurones se trouvent éparpillés dans les couches inférieures à $#max_potential - 2$. Après les deux spikes, le système se retrouve dans l'état précédent, où aucun neurone ne peut émettre de spike.

=== Définition de l'espace absorbant
#let absorbing_space = $cal(A)$
Nous notons #absorbing_space, l'*espace rassemblant les états absorbants et presque-absorbants*.\
#absorbing_space désigne les états à partir desquels le système est déjà absorbé ou finira nécessairement par l'être en un temps fini. Autrement dit, ce sont des configurations où l'activité neuronale est insuffisante pour maintenir une dynamique soutenue : la chaîne de Markov évolue alors inévitablement vers un état stable et inactif.\

#let absorbing_subspace(k: $k$) = $attach(#absorbing_space, br: #k)$
Pour chaque couche $k$ du système de neurones, nous allons définir un sous-ensemble #absorbing_subspace() et définir #absorbing_space de la façon suivante :
$ #absorbing_space = union.big_(k=0)^#max_potential #absorbing_subspace(). $

Chaque sous-ensemble #absorbing_subspace() impose une contrainte sur le nombre de neurones actifs dans les couches $l <= k$, de façon à ce que le système ne puisse pas se maintenir dans le temps et finisse nécessairement par tomber dans un état réellement absorbant.\
Définissons à présent les #absorbing_subspace(). $forall k <= #max_potential$ :
$ #absorbing_subspace() = {X in #chain_space : space sum_(l = k)^#max_potential mu (l, 1) <= #max_potential - k }. $
Pour $k = 0$, nous avons le cas particulier suivant :
$ #absorbing_subspace(k: $0$) = {X in #chain_space : mu(#max_potential, 0) + sum_(l=0)^#max_potential mu(l, 1) < #max_potential}. $
 
#let complement_absorbing_space = $attach(#absorbing_space, tr: complement)$
Ce que nous voulons pour représenter un groupe de neurones impliqué dans une tâche de mémorisation à court terme, c'est qu'ils puissent conjointement soutenir une activité neuronale sur un temps arbitrairement long. L'interruption de cette activité, traduirait une perturbation de cette mémorisation, et donc un oubli de l'information d'intérêt.\
Nous allons petit à petit définir ce que "soutenir une activité neuronale sur un temps arbitrairement long" signifie en termes mathématiques.\
Tout d'abord, cela signifie que la chaîne de Markov représentant notre système de neurones, ne doit pas être absorbée sur la fenêtre temporelle #time_window sur laquelle nous l'étudions. Ensuite, cela veut dire que sur #time_window, #chain() doit être capable d'émettre en continu des potentiels d'action :

Pour modéliser la fonction de mémoire court-terme, nous étudierons notre chaîne de Markov neuronale sur l'espace complémentaire #complement_absorbing_space. , où elle pourra effectivement connaître une activité de spikes indéfiniment. Mais cela n'est pas suffisant

#todo("TERMINER L'INTERPRÉTATION MÉMORIELLE & PLACER AU BON ENDROIT")

Étudions maintenant l'irréductibilité de la chaîne de Markov sur cet espace .

== Irréductibilité
=== États transitoires et espace transitoire
Certains états du système de neurones ne font pas partie de $cal(A)^complement$ mais ne sont pourtant pas atteignables à partir d'autres états non-absorbants. Nous appellerons les états de ce types les états _transitoires_. Le seul moyen pour notre système de se trouver dans un état transitoire, c'est de commencer dans cet état via les conditions initiales.\

Pour illustrer notre propos, prenons l'état ne contenant aucun neurone dans la couche $0$ et tous les neurones activés dans la couche $#max_potential$, c'est-à-dire $x$ tel que $x_(0, dot) = 0$ et $x_(#max_potential, 1) = N$. Comme il possède tous ses neurones capables de spiker, c'est bien un état qui n'est pas absorbant. Il est pourtant transitoire car après son premier spike, et pour toujours après, il y aura toujours un neurone dans la couche $0$, par définition des spikes.\
Autre exemple : l'état tel que $x_(#max_potential, 1) = N - 1$ et $x_(0, 1) = 1$ est aussi transitoire. En fait, *tout état* qui possède plus de $N - #max_potential$ neurones dans une de ses couches *est transitoire*. Cela est dû au fait qu'il n'est possible de rassembler au maximum que $N - #max_potential$ neurones dans la couche $#max_potential$. À cause des $#max_potential + 1$ couches, il faut un nombre de spikes égal à $#max_potential$ pour amener tous les neurones dans la couche $#max_potential$. Cependant, les $#max_potential$ spikes qui viennt d'être effectués entraînent la dispersion de $#max_potential$ neurones dans les couches inférieures (de $0$ à $#max_potential - 1$).

Nous définissons donc l'*ensemble des états transitoires* comme suit :
$ cal(T) = {x in cal(X) : x_(0, dot) = 0} union {x in cal(X) : x_(v, dot) > N - #max_potential, forall v = 0, dots, #max_potential}. $\

#let space_irreducible = $cal(X)_("irr")$
Pour prouver l'irréductibilité de la chaîne de Markov, nous nous placerons donc sur l'*ensemble des états irréductibles* $#space_irreducible = cal(A)^complement inter cal(T)^complement$.

#theorem("Irréductibilité chaîne de Markov conditionnellement à la non-absorption")[
  Conditionnellement à sa présence sur #space_irreducible, la chaîne de Markov $#chain() = #neuron()$ est *irréductible*.
]<theoreme_irreductibilite>

// Opérations des sauts élémentaires
#let operation_efficient_spike(k: $k$)= $O_e^#k$
#let operation_inefficient_spike(k: $k$) = $O_i^#k$
#let operation_deactivation(k: $k$, v: $v$) = $O_d^(#k, #v)$

#proof[
  Pour la lisibilité de cette preuve, nous commençons par noter : 
  - #operation_efficient_spike() : l'opération de $k$ spikes efficaces,
  - #operation_inefficient_spike() : l'opération de $k$ sauts inefficaces,
  - #operation_deactivation() : l'opération de désactivation de $k$ neurones à la couche $v$.

  Pour un état $x in #space_irreducible$, ces opérations peuvent advenir avec une probabilité positive puisque l'espace #space_irreducible peut supporter un nombre $k$ arbitraire de spikes.

  Ainsi la notation $#operation_efficient_spike() (x)$ désigne l'opération de $k$ spikes efficaces depuis l'état $x$. Ces $k$ spikes peuvent advenir tous en un seul pas de temps, si l'état $x$ le permet (i.e. s'il possède au moins $k$ neurones en couche #max_potential). Mais ils peuvent être également effectué dans un ordre quelconque. Lorsque la distinction est nécessaire, cela sera précisé.\

  Soit $x, y in #space_irreducible$. Notons $m = x_(dot, 0)$, le nombre de neurones désactivés de l'état $x$. Nous allons montrer que nous pouvons toujours atteindre en un nombre fini d'opérations, un état $x'''$ où tous les neurones sont activés (soit $x'''_(dot, 1) = N$) et avec $N - #max_potential$ neurones à la couche $#max_potential$ ($x'''_(#max_potential, 1) = N - #max_potential$) ainsi qu'un neurone par couche inférieure ($x'''_(v, 1) = 1, space forall v = 0, 1, dots, #max_potential - 1$). Cela se produit comme suit :
  $ &x' = #operation_efficient_spike(k: max_potential) (x),\
  & x'' =  #operation_inefficient_spike(k: $m$) (x') "où" m "est le nombre de neurones désactivés",\
  & x''' = underbrace(#operation_efficient_spike(k: $1$) compose #operation_efficient_spike(k: $1$) dots compose #operation_efficient_spike(k: $1$), #max_potential "fois") (x''). $

  D'où $x'''$ tel que $x'''_(#max_potential, 1) = N - #max_potential$ et $x'''_(v, 1) = 1, space forall v = 0, 1, dots, #max_potential - 1$.
  
  À partir de cet état $x'''$, montrons que nous pouvons atteindre l'état $y$ en un nombre fini d'opérations. Cet état $y in #space_irreducible$ se définit de façon très générale par son nombre de neurones dans chaque couche.\
  Ainsi, $forall v in #space_potentiel$ :
  $ y = vec((#mesure_empirique(state: $y$, v: max_potential, a: 0), #mesure_empirique(state: $y$, v: max_potential, a: 0)), dots.v, (#mesure_empirique(state: $y$, a: 0), #mesure_empirique(state: $y$, a: 0)), dots.v, (#mesure_empirique(state: $y$, v: $0$, a: 0), #mesure_empirique(state: $y$, v: $0$, a: 0))) $

  Nous allons prouver cela en définissant une suite $y^l$ qui permet, depuis $x'''$, d'atteindre l'état $y$ avec une probabilité positive. La suite se définit de la façon suivante : pour obtenir $y^(l+1)$ à partir de $y^l$, on désactive à la couche #max_potential $#mesure_couche(state: $y$, v: $#max_potential - l$) - 1$ neurones (soit le nombre total de neurones à la couche $#max_potential - l$ moins un) puis on fait *ce même nombre de spikes inefficaces*. Ces deux opérations permettent de récupérer $#mesure_couche(state: $y$, v: $#max_potential - l$) - 1$ neurones en couche $(0, 1)$.
  Nous construisons de cette façon progressivement l'état $y$ en amenant l'exacte quantité de neurones qu'il possède à chaque couche à la bonne couche finale. Cela commence par ailleurs pour l'étape $l=0$ par amener #mesure_couche(state: $y$, v: max_potential) en $(0, 1)$.
  Enfin, on fait *un spike efficace* pour monter les #mesure_couche(state: $y$, v: $#max_potential - l$) neurones à la couche supérieure.\ Formellement, cela donne initialement :
  $ y^0 = #operation_inefficient_spike(k: mesure_couche(state: $y$, v: max_potential)) compose #operation_deactivation(k: mesure_couche(state: $y$, v: max_potential), v: max_potential) (x'''), $
  ainsi que plus généralement :
  $ forall l in {0, dots, #max_potential - 1}, space y^(l+1) = #operation_efficient_spike(k: $1$) compose #operation_inefficient_spike(k: $#mesure_couche(state: $y$, v: $#max_potential - l$) - 1$) compose #operation_deactivation(k: $#mesure_couche(state: $y$, v: $#max_potential - l$) - 1$, v: max_potential) (y^l). $

  Enfin, nous désactivons le bon nombre de neurones dans toutes les couches pour arriver à $y$ : $ y = O_(d, v)^(y_(v, 0)) (y^#max_potential), space forall v = 0, dots, #max_potential. $

  Ce qui conclut la preuve.
]