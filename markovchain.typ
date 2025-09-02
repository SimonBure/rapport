#import "rules.typ": *
#import "global_variables.typ": *
// Rule to avoid references error in sub-chapters when compiling local file
// #show: no-ref

// Display settings for theorems and proofs
#show: thmrules.with(qed-symbol: $square$)

Nous disposons maintenant d'un modèle mathématique précis décrivant l'évolution en temps discret de notre système de neurones via des sauts représentant les potentiels d'action et les mécanismes d'activation et de désactivation des synapses. Cette formalisation nous a mené à l'utilisation d'une chaîne de Markov #chain() = #neuron() pour représenter ces dynamiques, reprenant la philosophie de notre article de référence @andreQuasiStationaryApproachMetastability2025.

Cette section répondra à la première question identifée dans @intro en posant les fondations mathématiques nécessaires au maintien de l'activité neuronale persistante. Ces bases seront importantes pour répondre à la seconde question dans les @section_mf et @section_mesure_sta.

Nous commencerons par écrire les transitions formellement les *transitions* de la chaîne #chain() (@section_transitions), ainsi que l'*espace d'états* #chain_space dans lequel elle évolue. Cela nous amenéra à considérer un nouveau point de vue grâce à la *mesure empirique*, pour réduire cet espace d'état et ainsi diminuer la complexité computationnelle. Ensuite, pour maintenir l'activité neuronale sur #chain(), nous aurons besoin d'identifier les *configurations absorbantes* (@espace_absorbant) qu'il faudra éviter pour maintenir la mémoire de travail. Enfin, nous établirons l'*irréductibilité* (@section_irr) de la chaîne sur l'espace non-absorbant, pour assurer un système flexible ne dépendant pas des conditions initiales.


== Transitions de la chaîne de Markov <section_transitions>
Soit $x in #chain_space$ un état possible du système de neurones. Nous notons $ x = vec(x_1, dots.v, x_N) "avec" x_i = (v_i, a_i). $ Nous avons bien sûr $x_i in #space_potentiel times {0, 1}, space forall i in {1, dots, N}$.\
Depuis cet état $x$, nous définissons trois transitions élémentaires possibles, vers un état $y in #chain_space$ :
- *Spike inefficace menant à l'activation d'un neurone* : notons $i$ l'indice du neurone effectuant le spike. La transition suivante survient avec probabilité $beta$ : $ vec((v_1, a_1), (v_2, a_2), dots.v, (v_i, a_i) = (#max_potential, 0), dots.v, (v_N, a_N)) --> vec((v_1, a_1), (v_2, a_2), dots.v, (v_i, a_i) = (0, 1), dots.v, (v_N, a_N)). $

- *Désactivation d'un neurone* : ici aussi, $i$ est l'indice $i$ du neurone se désactivant. Le système subit la transition suivante avec probabilité $lambda$, $ vec((v_1, a_1), dots.v, (v_i, a_i) = (v_i, 1), dots.v, (v_N, a_N)) --> vec((v_1, a_1), dots.v, (v_i, a_i) = (v_i, 0), dots.v, (u_N, f_N)). $

- *Spike efficace* : ici encore, nous notons $i$ l'indice du neurone effectuant le spike. La transition survient avec probabilité #spiking_probability, et s'écrit comme suit :
$
  vec((v_1, a_1), dots.v, (#max_potential, 1), dots.v, (v_N, a_N)) --> vec(([v_1 + 1] and #max_potential, a_1), dots.v, (0, 1), dots.v, ([v_N +1] and #max_potential, a_N)).
$

Ces trois transitions élémentaires sont *mutuellement exclusives*, c'est-à-dire que, dans un même intervalle de temps (entre $t$ et $t+1$), un neurone d'indice $i$ ne peut pas se désactiver puis faire une spike inefficace (ou bien effectuer un spike efficace puis se désactiver). Par contre, les $N$ neurones du système dans son ensemble peuvent tout à fait tous, ou en partie, subir une transition de façon indépendante.
Par exemple, pour un système contenant $N=10$ neurones dans les bonnes configuration, nous pourrions tout à fait avoir $3$ spikes efficaces, $0$ spike inefficace, et $5$ désactivations pendant le même intervalle temporel.


== Espace des états dans lequel évolue la chaîne
Chaque neurone peut prendre des valeurs dans l'espace ${0,1,...,#max_potential} times {0,1}$, ce qui leur donne $2(#max_potential + 1)$ états à leur disposition. Pour un système à N neurones évoluant dans l'espace $#chain_space = ({0,1,...,#max_potential} times {0,1})^N$, le nombre d'états est donc $abs(#chain_space) = (2(#max_potential + 1))^N$.

Problème, pour un système un tant soit peu important ($N = 30$ et $#max_potential = 4$), le coût computationnel explose très rapidement ($abs(#chain_space) = (2(4 + 1))^30 = 10^30$ !). C'est pourquoi nous allons désormais aborder une astuce, un changement de point de vue qui nous permettra de diminuer drastiquement la complexité.


== Mesure empirique <mesure_empirique>
Jusqu'à présent, nous avons analysé notre système en suivant individuellement chaque neurone i avec son état #neuron(). Cette approche "microscopique" fournit une description complète, mais n'est pas optimale, comme nous allons le montrer avec les deux arguments suivants.

Pour aborder la mémoire de travail, il n'est pas nécessaire de connaître précisément l'identité de chaque neurone. Les informations importantes sur la dynamique se trouve au *niveau collectif* ou macroscopique. Ce qui nous intéresse, c'est connaître la quantité de neurones actifs ou le nombre de neurones à chaque "marche" de l'escalier du voltage. Ce changement de point de vue entraînerait de plus une *réduction de la complexité computationnelle*, car le modèle se limiterait aux informations intéressantes.

Pour représenter ce changement de paradigme, nous allons définir la *mesure empirique* de notre système et l'utiliser à la place du modèle "micro". Ce changement est possible grâce à un point fondamental et non-évident, qui découle directement de la construction de notre modèle : *la mesure empirique de notre chaîne de Markov est elle-même une chaîne de Markov* définie sur un espace plus petit. Cela permet de se concentrer sur les informations essentielles tout en gardant la cadre théorique agréable des chaînes de Markov.

=== Définition formelle
La définition de la mesure empirique est classiquement :
$ #mesure_empirique() (v, a) = 1/N sum_(i=1)^N #dirac($(#membrane_potential(), #activation())$) (v, a). $

Cependant, nous trouvons qu'il est plus clair de travailler avec le compte direct des neurones plutôt qu'avec des proportions. Si $#mesure_comptage() (v, a)$ est le nombre de neurones dans l'état $(v, a)$ au temps $t$ alors
$ #mesure_comptage() (v, a) = sum_(i=1)^N #dirac($(#membrane_potential(), #activation())$) (v, a). $


Nous voulons également :
- Pouvoir compter les neurones avec un potentiel $v$, sans regarder leur état d'activation.
- Pouvoir compter le nombre de neurones activés ou inactifs.

Cela nous mène aux notations suivantes :
- #mesure_couche() : pour compter le nombre de neurones ayant un potentiel de $v$. Nous appelerons cela la *couche $v$* dans la suite du mémoire,
  $
    #mesure_couche() = #mesure_comptage() (v, 0) + #mesure_comptage() (v, 1).
  $
- #mesure_activation() : pour compter le nombre de neurones actifs ou inactifs,
  $
    #mesure_activation() = sum_(v = 1)^#max_potential #mesure_comptage() (v, a).
  $


=== Propriété de Markov (intuition)
#remark("Propriété de Markov de la mesure empirique")[
  La représentation de la chaîne #chain() avec la mesure de comptage #mesure_comptage() est elle-même une chaine de Markov.
]

Nous allons donner l'argument de pourquoi nous pensons que cela est vraie. Cependant, cela ne constitue pas une vraie preuve. L'argument est le suivant : comme est construit notre modèle, les neurones sont interchangeables sans que cela impacte la dynamique. La connaissance de la structure macroscopique nous fournit toutes les informations nécessaires pour prédire l'évolution future de la chaîne.\
Les probabilités de transition sont entièrement déterminés par la connaissance de la mesure de comptage :
$
  #proba_conditional(mesure_comptage(t: $t+1$), filtration()) = #proba_conditional(mesure_comptage(t: $t+1$), mesure_comptage()).
$

Dans la suite du mémoire, lorsque nous invoquerons #chain(), cela fera référence à cette nouvelle chaîne de Markov définit à partir du compte des neurones à chaque couche.

=== Taille du nouvel espace #chain_space
Pour déterminer la taille de l'espace d'états de la mesure empirique, nous devons compter le nombre de façons de répartir $N$ neurones parmi les $2(#max_potential + 1)$ états possibles $(v,a)$.

Ce problème équivaut à compter le nombre de façons de placer $N$ objets identiques et interchangeables (les étoiles ★) dans $2(#max_potential + 1)$ boîtes distinctes, ce qui correspond au problème classique des « étoiles et barres ». Pour séparer $2(#max_potential + 1)$ groupes, nous avons besoin de $2(#max_potential + 1) - 1$ séparateurs (les barres |).\
Le nombre total d'arrangements de $N$ étoiles dans $2#max_potential + 1$ boîtes est donné par le coefficient binomial :
$ abs(#chain_space) = vec(N + 2#max_potential + 1, 2#max_potential + 1). $

Comparons les tailles des deux espaces (celui microscopique et celui macroscopique) pour $N = 30$ et $#max_potential = 4$. Rappelons que l'espace du modèle version micro contient $2(#max_potential + 1)^N$ états, soit $10^30$. La version macro, contient "seulement" $vec(N + 2#max_potential + 1, 2#max_potential + 1) = vec(39, 9) = 2.11 times 10^8$, réduisant considérablement la complexité du modèle !


== Modéliser la mémoire de travail
Ce que nous voulons pour représenter un groupe de neurones impliqué dans une tâche de mémorisation à court-terme, c'est qu'ils puissent conjointement soutenir une activité neuronale sur un temps arbitrairement long. L'interruption de cette activité, traduirait une perturbation de cette mémorisation, et donc un oubli de l'information d'intérêt.

Nous avons donc besoin que #chain() soit capable d'émettre en continu des potentiels d'action sur la fenêtre temporelle d'étude #time_window. Comme nous travaillons avec une chaîne de Markov, il vient assez naturellement que nous allons avoir besoin d'étudier l'*absorption* de #chain(). Nous pourrons alors ensuite *conditionner* la chaîne à sa *non-absorption*, impliquant ainsi qu'elle deviendra capable de soutenir une activité persistante de sauts aussi longtemps que nécessaire.

Définissons maintenant les états et espaces absorbants.


== Espace absorbant <espace_absorbant>
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
$ #absorbing_subspace() = {X in #chain_space : space sum_(v = k)^#max_potential #mesure_comptage() (v, 1) <= #max_potential - k }. $
Pour $k = 0$, nous avons le cas particulier suivant :
$
  #absorbing_subspace(k: $0$) = {X in #chain_space : #mesure_comptage() (#max_potential, 0) + sum_(v=0)^#max_potential #mesure_comptage() (v, 1) < #max_potential}.
$

#let complement_absorbing_space = $attach(#absorbing_space, tr: complement)$
Nous venons de caractériser l'espace absorbant #absorbing_space : les configurations où le système finira inévitablement par s'éteindre et perdre toute activité neuronale. Pour modéliser la mémoire de court-terme, nous nous intéressons naturellement au comportement sur l'espace complémentaire #complement_absorbing_space : où le système peut maintenir une activité de spikes indéfiniment.

Cependant, la *non-absorption ne suffit pas*. Imaginons un réseau qui, bien que capable de spiker indéfiniment, se retrouve "piégé" dans une région particulière de l'espace d'états sans pouvoir explorer d'autres configurations. Un tel système pourrait maintenir une activité neuronale, mais cette activité serait rigide, incapable de s'adapter ou de représenter différents items mémoriels. Le comportement d'un tel système serait aussi fortement dépendant des conditions initiales, faisant varier la région piège.

Nous voyons ainsi apparaître un nouveau critère pour notre modèle : la nécessité de "flexibilité"; de pouvoir passer d'une configuration à une autre sans se "coincer" dans une sous-région de l'espace des états. Mathématiquement, cela correspond à la notion d'*irréductibilité* : tous les états communiquent entre eux et les conditions de départ n'importent pas sur le comportement à long-terme de la chaîne de Markov.

Grâce à la propriété d'irréductibilité plus le conditionnement de la chaîne #chain() à la non-absorption, il serait possible d'étudier théoriquement la *distribution quasi-stationnaire* de la chaîne #chain(). C'est un cadre théorique pertinent pour étudier les systèmes *métastables*, c'est-à-dire avec un équilibre (ici l'absorption) mais pouvant évoluer un temps arbitraire loin de cet équilibre avant d'y être attiré indéfiniment. Cette approche a été largement étudiée dans @andreQuasiStationaryApproachMetastability2025, et c'est pour cela qu'elle ne sera pas abordée plus en détail dans ce mémoire. Nous nous démarquerons en proposant une nouvelle vision pour la mémoire de travail, à travers un modèle limite et la mesure stationnaire qui en découlera.

C'est cette propriété d'irréductibilité que nous allons maintenant établir pour #chain() à partir de la structure même de notre modèle.

== Irréductibilité <section_irr>
Comme nous venons de l'expliquer, l'irréducibilité est une propriété essentielle pour garantir la possiblité de #chain() de visiter tous les états de l'espace #complement_absorbing_space. Cependant, du fait de la construction de notre modèle, certains états du système de neurones ne font pas partie de #complement_absorbing_space mais ne sont pourtant pas atteignables à partir d'autres états non-absorbants. C'est par exemple le cas de l'état ne contenant aucun neurone dans la couche $0$ et tous les neurones activés dans la couche $#max_potential$, c'est-à-dire $x$ tel que $x_(0, dot) = 0$ et $x_(#max_potential, 1) = N$. Comme il possède tous ses neurones capables de spiker, c'est bien un état qui n'est pas absorbant. Pourtant, il ne pourra jamais être visité à nouveau car après chaque spike, par définition, il y aura toujours un neurone dans la couche $0$.

Nous appellerons les états de ce types les états _transitoires_, qui ne pourront être atteints autrement que via les conditions initiales du système. Détaillons tout de suite leur définition.

=== États transitoires et espace transitoire
Un autre exemple d'état transitoire est le suivant : $x_(#max_potential, 1) = N - 1$ et $x_(0, 1) = 1$. Plus généralement, *tout état* qui possède plus de $N - #max_potential$ neurones dans une de ses couches *est transitoire*. Cela est dû au fait que notre modélisation impose l'existence de $#max_potential + 1$ couches, ce qui signifie qu'au moins #max_potential spikes efficaces sont nécessaires pour rassembler les neurones dans la couche #max_potential. Ces #max_potential spikes, entraînent la dispersion de #max_potential neurones dans les couches inférieures. Ainsi #max_potential neurones ne pourront jamais être rassemblés avec les autres et donc au maximum, il ne sera possible de rassembler que $N - #max_potential$ neurones dans une même couche.

Nous définissons donc l'*ensemble des états transitoires* comme suit :
$
  cal(T) = {x in #chain_space : x_(0, dot) = 0} union {x in #chain_space : x_(v, dot) > N - #max_potential, forall v = 0, dots, #max_potential}.
$\

#let space_irreducible = $attach(#chain_space, br: "irr")$
Pour prouver formellement l'irréductibilité de la chaîne de Markov, nous nous placerons donc sur l'*ensemble des états irréductibles* $#space_irreducible = cal(A)^complement inter cal(T)^complement$.

#theorem("Irréductibilité chaîne de Markov conditionnellement à la non-absorption")[
  La chaîne de Markov $#chain() = #neuron()$ est *irréductible* sur l'espace #space_irreducible.
]<theoreme_irreductibilite>

// Opérations des sauts élémentaires
#let operation_efficient_spike(k: $k$) = $O_e^#k$
#let operation_inefficient_spike(k: $k$) = $O_i^#k$
#let operation_deactivation(k: $k$, v: $v$) = $O_d^(#k, #v)$

#proof[
  Il nous faut prouver que, pour tout état $x in #space_irreducible$, il est possible d'atteindre n'importe quel autre état $y in #space_irreducible$ avec probabilité positive. Autrement dit, il existe un nombre fini d'opérations de spikes efficaces, de spikes inefficaces ou de désactivations qui permettent d'atteindre n'importe quel état $y$ en partant de $x$. Toutes ces opérations peuvent advenir avec probabilité positive, car la chaîne #chain() évolue sur l'espace #space_irreducible où, nous l'avons vu en @section_irr, elle est capable de soutenir indéfiniment une activité de sauts.

  La preuve se présente comme suit :
  + Définition des notations utilisées pour représenter les opérations élémentaires de sauts de notre chaîne #chain().
  + Introduction d'un état de référence $x'''$, atteignable à partir de n'importe quel état $x$ en quelques opérations.
  + Définition d'une suite d'états $y^l$, où $y^(l+1)$ est atteignable à partir de $y^l$ avec un nombre fini d'opérations.
  + Preuve qu'il est possible d'atteindre $y^0$ à partir de $x'''$.
  + Preuve que $y$ s'atteint grâce à la suite des $y^l$.

  Pour la lisibilité de cette preuve, nous commençons par noter :
  - #operation_efficient_spike() : l'opération de $k$ spikes efficaces,
  - #operation_inefficient_spike() : l'opération de $k$ sauts inefficaces,
  - #operation_deactivation() : l'opération de désactivation de $k$ neurones à la couche $v$.

  Ainsi la notation $#operation_efficient_spike() (x)$ désigne l'opération de $k$ spikes efficaces depuis l'état $x$. Ces $k$ spikes peuvent advenir tous en un seul pas de temps, si l'état $x$ le permet (i.e. s'il possède au moins $k$ neurones en couche #max_potential). Mais ils peuvent être également effectué dans un ordre quelconque. Lorsque la distinction est nécessaire, cela sera précisé.

  Montrons d'abord que nous pouvons toujours atteindre en un nombre fini d'opérations, un état $x'''$ où tous les neurones sont activés (soit $#mesure_activation(state: $x'''$, a: $1$) = N$) et avec $N - #max_potential$ neurones à la couche $#max_potential$ ($#mesure_activation(state: $x'''$, a: $1$) = N - #max_potential$) ainsi qu'un neurone par couche inférieure ($#compte_neurone(state: $x'''$, a: $1$) = 1, space forall v = 0, 1, dots, #max_potential - 1$). Notons $m = #mesure_activation(state: $x'''$, a: $0$)$, le nombre de neurones désactivés de l'état $x$. L'état $x'''$ s'atteint de la façon suivante :
  $
    &x' = #operation_efficient_spike(k: max_potential) (x),\
    & x'' = #operation_inefficient_spike(k: $m$) (x') "où" m "est le nombre de neurones désactivés",\
    & x''' = underbrace(#operation_efficient_spike(k: $1$) compose #operation_efficient_spike(k: $1$) dots compose #operation_efficient_spike(k: $1$), #max_potential "fois") (x'').
  $

  D'où $x'''$ tel que $#compte_neurone(state: $x'''$, v: max_potential, a: $1$) = N - #max_potential$ et $#compte_neurone(state: $x'''$, v: $v$, a: $1$) = 1, space forall v = 0, 1, dots, #max_potential - 1$.

  À partir de cet état $x'''$, montrons que nous pouvons atteindre l'état $y$ en un nombre fini d'opérations à travers une suite d'états $y^l$. Depuis l'état $x'''$, il est possible d'atteindre le premier élément de la suite $y^0$. Puis, à partir de chaque élément $y^l$, l'élement suivant $y^(l+1)$ s'atteint avec toujours la même séquence d'opérations. La suite se poursuit jusqu'à ce que $l = #max_potential - 1$. Enfin, à partir de $y^#max_potential$, l'état quelconque d'arrivée $y$ s'atteint également en quelques opérations de désactivation.

  Cet état $y in #space_irreducible$ se définit de façon très générale par son nombre de neurones dans chaque couche. Ainsi, $forall v in #space_potentiel$ :
  $
    y = vec((#compte_neurone(state: $y$, v: max_potential, a: 0), #compte_neurone(state: $y$, v: max_potential, a: 0)), dots.v, (#compte_neurone(state: $y$, a: 0), #compte_neurone(state: $y$, a: 0)), dots.v, (#compte_neurone(state: $y$, v: $0$, a: 0), #compte_neurone(state: $y$, v: $0$, a: 0))).
  $

  Définissons tout d'abord la suite d'états $y^l$. Pour obtenir $y^(l+1)$ à partir de $y^l$, on désactive à la couche #max_potential le nombre $#mesure_couche(state: $y$, v: $#max_potential - l$) - 1$ de neurones (soit le nombre total de neurones à la couche $#max_potential - l$ moins un) puis on fait *ce même nombre de spikes inefficaces*. Ces deux opérations permettent de récupérer $#mesure_couche(state: $y$, v: $#max_potential - l$) - 1$ neurones en couche $(0, 1)$.\
  Nous construisons de cette façon progressivement l'état $y$ en amenant l'exacte quantité de neurones qu'il possède à chaque couche à la bonne couche finale. Cela commence par ailleurs pour l'étape $l=0$ par amener #mesure_couche(state: $y$, v: max_potential) en $(0, 1)$.\
  Enfin, on fait *un spike efficace* pour monter les #mesure_couche(state: $y$, v: $#max_potential - l$) neurones à la couche supérieure.\

  Formellement, cela donne initialement :
  $
    y^0 = #operation_inefficient_spike(k: mesure_couche(state: $y$, v: max_potential)) compose #operation_deactivation(k: mesure_couche(state: $y$, v: max_potential), v: max_potential) (x'''),
  $
  ainsi que plus généralement :
  $
    forall l in {0, dots, #max_potential - 1}, space y^(l+1) = #operation_efficient_spike(k: $1$) compose #operation_inefficient_spike(k: $#mesure_couche(state: $y$, v: $#max_potential - l$) - 1$) compose #operation_deactivation(k: $#mesure_couche(state: $y$, v: $#max_potential - l$) - 1$, v: max_potential) (y^l).
  $

  Enfin, nous désactivons le bon nombre de neurones dans toutes les couches pour arriver à $y$ :
  $ forall v = 0, dots, #max_potential, space y = #operation_deactivation(k: 1, v: $v$) (y^#max_potential). $

  Ce qui conclut la preuve.
]
