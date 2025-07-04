#import "rules.typ": *
#import "global_variables.typ": *
// Rule to avoid references error in sub-chapters when compiling local file
#show: no-ref

== Espace des états dans lequel évolue la chaîne
Chaque neurone peut prendre des valeurs dans l'espace ${0,1,...,theta}times{0,1}$. Le nombre d'état possible est ainsi $2(theta + 1)$. Pour un système à N neurones évoluant dans l'espace $cal(X) = ({0,1,...,theta}times{0,1})^N$, le nombre d'états est donc $abs(cal(X)) = 2(theta + 1)N$.

== Transitions de la chaîne de Markov
Soit $x in cal(X)$ un état possible du système de neurones. Nous notons $ x = vec(x_1, dots.v, x_N) "avec" x_i = (v_i, a_i). $ Nous avons bien sûr $x_i in {0, 1, dots, theta}times{0, 1}, space forall i in {1, dots, N}$.\
Depuis cet état $x$, nous définissons trois transitions élémentaires possibles, vers un état $y in cal(X)$ :
- *Spike inefficace menant à l'activation d'un neurone* : notons $i$ l'indice du neurone effectuant le spike. La transition suivante survient avec probabilité $beta$ : $ vec((v_1, a_1), (v_2, a_2), dots.v, (v_i, a_i) = (theta, 0), dots.v, (v_N, a_N)) --> vec((v_1, a_1), (v_2, a_2), dots.v, (v_i, a_i) = (0, 1), dots.v, (v_N, a_N)). $

- *Désactivation d'un neurone* : ici aussi, $i$ est l'indice $i$ du neurone se désactivant. Le système subit la transition suivante avec probabilité $lambda$, $ vec((v_1, a_1), dots.v, (v_i, a_i) = (v_i, 1), dots.v, (v_N, a_N)) --> vec((v_1, a_1), dots.v, (v_i, a_i) = (v_i, 0), dots.v, (u_N, f_N)). $

- *Spike efficace* : ici encore, nous notons $i$ l'indice du neurone effectuant le spike. La transition survient avec probabilité #spiking_probability, et s'écrit comme suit :
$ vec((v_1, a_1), dots.v, (theta, 1), dots.v, (v_N, a_N)) --> vec(([v_1 + 1] and theta, a_1), dots.v, (0, 1), dots.v, ([v_N +1] and theta, a_N)). $

Ces trois transitions élémentaires sont *mutuellement exclusives*, c'est-à-dire que, dans un même intervalle de temps (entre $t$ et $t+1$), un neurone d'indice $i$ ne peut pas se désactiver puis faire une spike inefficace (ou bien effectuer un spike efficace puis se désactiver). Par contre, les $N$ neurones du système dans son ensemble peuvent tout à fait tous, ou en partie, subir une transition de façon indépendante. 
Par exemple, pour un système contenant $N=10$ neurones dans les bonnes configuration, nous pourrions tout à fait avoir $3$ spikes efficaces, $0$ spike inefficace, et $5$ désactivations pendant le même intervalle temporel.


== Mesure empirique
// Variables
#let mesure_empirique(state: $x$, v: $v$, a: $a$) = $#state^N_((#v, #a))$
#let mesure_couche(state: $x$, v: $v$) = mesure_empirique(state: state, v: v, a: $dot$)

La mesure empirique associée à une chaîne de Markov permet de représenter d'une nouvelle façon notre système de neurones. Cette représentation se focalise sur les _couches_ de potentiel de membrane plutôt que sur les neurones individuels (total de $#max_potential + 1$ couches).\
En language classique, notre mesure empirique permet de compter le nombre de neurones présent à une couche $v$ et dans un état d'activation $a$ quelconques.\
Dans le cas présent, la mesure empirique est elle-même une chaîne de Markov définie en plus sur un espace d'états plus petit. L'explication sera donnée un peu plus tard.

Soit $x$ un état arbitraire de notre système à $N$ neurones.En notant #mesure_empirique(), la mesure empirique associée à notre système de neurones stochastiques en interaction, nous écrivons la définition suivante, pour tout $v in #space_value_potential$ et tout $a in #space_value_activation$ :
#numbered_equation($ #mesure_empirique() = sum_(i=1)^N #dirac($(#membrane_potential(), #activation())$) (v, a). $, <def_mesure_empirique>)

Introduisons également la notation suivante #mesure_couche(), qui nous sera utile pour compter le nombre de neurones possédant un potentiel de membrane $v$, toute variable d'activation confondue. Elle se définit par
#numbered_equation($ #mesure_couche() = sum_(i = 1)^N #dirac($(#membrane_potential(), #activation())$) (v, 0) + #dirac($(#membrane_potential(), #activation())$) (v, 1). $, <def_mesure_couche>)
 
Pour compter le nombre d'états possibles, il suffit de se référer au problème canonique de combinatoire : le nombre de façon de séparer un nombre $n$ de $star$ par un nombre $m$ de $|$. Cela donne
$ abs(cal(X)) = vec(N - 2theta + 1, 2theta + 1). $
#todo("Donner exemple avec 5 étoiles et 2 barres ?")

== Espace absorbant
=== États absorbants
Le système n'émettra plus aucun saut lorsque :
- aucun neurone ne se trouve dans un état permettant un spike,
- tous les neurones sont désactivés.
Un état absorbant $cal(a)$ se définit donc de la façon suivante :
$ cal(a) = vec((v_1, 0), (v_2, 0), dots.v, (v_N, 0)), space forall v_i < theta. $

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
$ #absorbing_space = union.big_(k=0)^theta #absorbing_subspace(). $

Chaque sous-ensemble #absorbing_subspace() impose une contrainte sur le nombre de neurones actifs dans les couches $l <= k$, de façon à ce que le système ne puisse pas se maintenir dans le temps et finisse nécessairement par tomber dans un état réellement absorbant.\
Définissons à présent les #absorbing_subspace(). $forall k <= #max_potential$ :
$ #absorbing_subspace() = {X in #chain_space : space sum_(l = k)^theta mu (l, 1) <= theta - k }. $
Pour $k = 0$, nous avons le cas particulier suivant :
$ #absorbing_subspace(k: $0$) = {X in #chain_space : mu(theta, 0) + sum_(l=0)^theta mu(l, 1) < theta}. $
 
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

Pour illustrer notre propos, prenons l'état ne contenant aucun neurone dans la couche $0$ et tous les neurones activés dans la couche $theta$, c'est-à-dire $x$ tel que $x_(0, dot) = 0$ et $x_(theta, 1) = N$. Comme il possède tous ses neurones capables de spiker, c'est bien un état qui n'est pas absorbant. Il est pourtant transitoire car après son premier spike, et pour toujours après, il y aura toujours un neurone dans la couche $0$, par définition des spikes. Autre exemple : l'état tel que $x_(theta, 1) = N - 1$ et $x_(0, 1) = 1$ est aussi transitoire. En fait, tout état qui possède plus de $N- theta$ neurones dans une de ses couches est transitoire. Cela est dû au fait qu'il n'est possible de rassembler au maximum que $N - theta$ neurones dans la couche $theta$. À cause des $theta + 1$ couches, il faut un nombre de spikes égal à $theta$ pour amener tous les neurones dans la couche $theta$. Cependant, les $theta$ spikes qui viennt d'être effectués entraînent la dispersion de $theta$ neurones  dans les couches inférieures (de $0$ à $theta - 1$).\
Nous définissons donc l'*ensemble des états transitoires* comme suit :
$ cal(T) = {x in cal(X) : x_(0, dot) = 0} union {x in cal(X) : x_(v, dot) > N - theta, forall v = 0, dots, theta}. $\

Pour prouver l'irréductibilité de la chaîne de Markov, nous nous placerons donc sur l'*ensemble des états irréductibles* $cal(X)_("irr") = cal(A)^complement inter cal(T)^complement$.

=== Preuve de l'irréductibilité
Pour la lisibilité de cette preuve, nous commençons par noter : 
- $O_e^k$ : l'opération de $k$ spikes efficaces en un seul pas de temps,
- $O_i^k$ : l'opération de $k$ sauts inefficaces en un seul pas de temps,
- $O_(d, v)^k$ : l'opération de désactivation de $k$ neurones à la couche $v$.
Ainsi la notation $O_e^k (x)$ désigne l'opération de $k$ spikes efficaces depuis l'état $x$. Pour un état $x in cal(X)_"irr"$, ces opérations peuvent advenir avec une probabilité positive puisque l'espace $cal(A)^complement$ peut supporter un nombre $k$ arbitraire de spikes.\
Soit $x, y in cal(X)_("irr")$. Notons $m = x_(dot, 0)$, le nombre de neurones désactivés de l'état $x$. Nous allons montrer que nous pouvons toujours atteindre en un nombre fini d'opérations, un état $x'''$ où tous les neurones sont activés ($x'''_(dot, 1) = N$) et avec $N- theta$ neurones à la couche $theta$ ($x'''_(theta, 1) = N - theta$) ainsi qu'un neurone par couche inférieure ($x'''_(v, 1) = 1, space forall v = 0, 1, dots, theta - 1$). Cela se produit comme suit :
$ &x' = O_e^theta (x),\
& x'' =  O_i^m (x') "où" m "est le nombre de neurones désactivés",\
& x''' = underbrace(O_e^1 compose O_e^1 dots compose O_e^1, theta "fois") (x''). $ d'où $x'''$ tel que $x'''_(theta, 1) = N - theta$ et $x'''_(v, 1) = 1, space forall v = 0, 1, dots, theta - 1$.\
À partir de cet état $x'''$, montrons que nous pouvons atteindre l'état $y$ en un nombre fini d'opérations. Cet état $y in cal(X)_"irr"$ se définit de façon très générale : $ forall v = 0, dots, theta, space vec((y_(0, 0), y_(0, 1)), dots.v, (y_(v, 0), y_(v, 1)), dots.v, (y_(theta, 0), y_(theta, 1))). $ Nous allons prouver cela en définissant une suite $y^l$ qui permet, depuis $x'''$, d'atteindre l'état $y$ avec une probabilité positive. La suite se définit de la façon suivante : on commence par désactiver le bon nombre de neurones dans la couche $theta$, puis on fait ce même nombre de spikes inefficaces et on fait un spike efficace. Formellement, cela donne :
$ y^0 = O_i^(y_(theta, dot) - 1) compose O_(d, theta)^(y_(theta, dot) - 1) (x'''), $ et 
$ forall l in {0, dots, theta - 1}, space y^(l+1) = O_i^(y_(theta - l, dot) - 1) compose O_(d, theta)^(y_(theta - l, dot) - 1) compose O_e^1 (y^l). $

Enfin, nous désactivons le bon nombre de neurones dans toutes les couches pour arriver à $y$ : $ y = O_(d, v)^(y_(v, 0)) (y^theta), space forall v = 0, dots, theta. $
Par construction, les états $y^l$ sont tous bien dans $cal(X)_"irr"$.\

== Distribution quasi-stationnaire