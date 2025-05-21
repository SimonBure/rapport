#import "style.typ": *

// Text set up
#set text(lang: "fr")

// Paragraph set up
#set par(justify: true)

// Math set up
#set math.equation(numbering: "(1)")

= Introduction
== Sujets

== Intérêts et objectfifs


= Modèle d'un système de neurones excitateurs
== Défintion du système
Nous définissons l'état du système de neurones par le processus stochastique suivant $ X_t = vec(X_t^1, dots.v, X_t^N) $ où $ X_t^i = (V_t^i, A_t^i). $
Chaque neurone $i$ est donc représenté par un couple $(V_t^i, A_t^i)$ où :
- La variable aléatoire $V_t^i$ représente le _voltage_ de sa membrane au temps $t$, avec $V_t^i in {0, ..., theta}$.
- La variable aléatoire $A_t^i$ représente l'état d'_activation_ de la synapse du neurone au temps $t$, avec $A_t^i in {0, 1}$.
Notons $cal(F_t)$ la filtration associée au processus global.\
Notre modélisation se fait en temps discret. Pour un $T in bb(R)_+^*$, nous définissons : $ t in {0, 1, 2, dots, T-1, T}. $


== Modélisation des sauts du système
En plus des deux variables aléatoires $V_t^i$ et $A_t^i$, nous avons besoin d'une variable aléatoire auxiliaire par neurone, que nous noterons $U_t^i$. Tous les $U_t^i$ sont distribuées _uniformément_ sur $[0, 1]$, qui nous permettra de simuler les processus de spike et de désactivation des neurones. Nous avons donc $ forall t, forall i, space U_t^i ~^("i.i.d.") "Unif"(0, 1). $
Commençons par définir les spikes du système.

=== Spike
Un neurone d'indice $i$ est en capacité d'effectuer un spike au temps $t+1$ si et seulement si son voltage $V_t^i = theta$. Un neurone capable de "spiker", spike avec probabilité $beta$ telle que $beta + lambda <= 1$, indépendamment de l'état du système et des autres variables aléatoires. Après son spike, le voltage du neurone est remis à zéro.\
Pour résumer ces informations, nous allons introduire la fonction $phi.alt$, qui associera la probabilité de spiker à un voltage $v$ donné : $ phi.alt : cases(v in {0, 1, dots, theta} --> [0, 1], phi.alt(v) = beta bold(1)_(v = theta)). $
Ainsi en utilisant $phi.alt$ et la variable auxiliaire uniforme $U_t^i$ définie plus haut, le neurone $i$ effectuera un spike au temps $t+1$ ssi $ U_(t+1)^i <= phi.alt(V_t^i). $

=== Désactivation
Un neurone $i$ avec un voltage $v in {0, 1, dots, theta}$ quelconque qui se désactive au temps $t+1$ voit sa variable d'activation $A_(t+1)^i = 0$. Pour qu'un tel événement se produise, il fallait nécessairement que ce neurone $i$ soit activé au temps $t$ : $A_t^i = 1$. Un neurone actif se désactive avec probabilité $lambda in [0, 1]$, de façon indépendante du reste du système. Les événements de spike et de désactivations sont *mutuellement exclusifs*. Le neurone $i$ se désactive donc au temps $t+1$ ssi
$ bold(1)_(phi.alt(V_t^i) <= U_(t+1)^i <= lambda A_t^i + phi.alt(V_t^i)). $

== Évolution du voltage
#set math.vec(delim: none)

$ forall t, forall i, space V_(t+1)^i = underbrace(bold(1)_(U_(t+1)^i > phi.alt(V_t^i)), "= 0 si spike")(V_t^i + sum_vec(j = 0, j != i)^N A_t^j bold(1)_(U_(t+1)^j <= phi.alt(V_t^j))). $

#set math.vec(delim: "(")

== Évolution de l'activation
$ forall t, forall i, space A_(t+1)^i = A_t^i + underbrace((1 - A_t^i)bold(1)_(U_(t+1)^i <= phi.alt(V_t^i)), "Réactivation par le spike") - underbrace(A_t^i bold(1)_(phi.alt(V_t^i) <= U_(t+1)^i <= lambda + phi.alt(V_t^i)), "Désactivation spontanée"). $
 
== Espace des états dans lequel évolue la chaîne
Chaque neurone peut prendre des valeurs dans l'espace ${0,1,...,theta}times{0,1}$. Le nombre d'état possible est ainsi $2(theta + 1)$. Pour un système à N neurones évoluant dans l'espace $cal(X) = ({0,1,...,theta}times{0,1})^N$, le nombre d'états est donc $abs(cal(X)) = 2(theta + 1)N$.

== Transitions de la chaîne de Markov
Soit $x in cal(X)$ un état possible du système de neurones. Nous notons $ x = vec(x_1, dots.v, x_N) "avec" x_i = (v_i, a_i). $ Nous avons bien sûr $x_i in {0, 1, dots, theta}times{0, 1}, space forall i in {1, dots, N}$.\
Depuis cet état $x$, nous définissons trois transitions élémentaires possibles, vers un état $y in cal(X)$ :
- *Spike inefficace menant à l'activation d'un neurone* : notons $i$ l'indice du neurone effectuant le spike. La transition suivante survient avec probabilité $beta$ : $ vec((v_1, a_1), (v_2, a_2), dots.v, (v_i, a_i) = (theta, 0), dots.v, (v_N, a_N)) --> vec((v_1, a_1), (v_2, a_2), dots.v, (v_i, a_i) = (0, 1), dots.v, (v_N, a_N)). $
- *Désactivation d'un neurone* : ici aussi, $i$ est l'indice $i$ du neurone se désactivant. Le système subit la transition suivante avec probabilité $lambda$, $ vec((v_1, a_1), dots.v, (v_i, a_i), dots.v, (v_N, a_N)) --> vec((v_1, a_1), dots.v, (v_i, a_i), dots.v, (u_N, f_N)). $
- *Spike efficace* : ici encore, nous notons $i$ l'indice du neurone effectuant le spike. On écrit la transition la façon suivante, $ vec((v_1, a_1), dots.v, (theta, 1), dots.v, (v_N, a_N)) --> vec(([v_1 + 1] and theta, a_1), dots.v, (0, 1), dots.v, ([v_N +1] and theta, a_N)) "avec probabilité "beta. $
Ces trois transitions élémentaires sont *mutuellement exclusives*, c'est-à-dire que, dans un même intervalle de temps (entre $t$ et $t+1$), un neurone d'indice $i$ ne peut pas se désactiver puis faire une spike inefficace (ou bien effectuer un spike efficace puis se désactiver). Par contre, les $N$ neurones du système dans son ensemble peuvent tout à fait tous, ou en partie, subir une transition de façon indépendante. 
Par exemple, pour un système contenant $N=10$ neurones dans les bonnes configuration, nous pourrions tout à fait avoir $3$ spikes efficaces, $0$ spike inefficace, et $5$ désactivations.


== Mesure empirique
Pour représenter le système autrement, nous introduisons sa mesure empirique, $ mu_t^N = 1/N sum_(i=1)^N delta_((V_t^i, A_t^i)). $

Si le système se trouve dans l'état $x$, nous définissons la mesure de comptage du nombre de neurones dans l'état $(v, a)$ par :
$ forall u in {0, dots, theta} "et " f in {0, 1},\ mu_x (v, f) = sum_(i=1)^N bold(1)_(v_i = v)bold(1)_(a_i = a). $ // écrire avec des mesures ponctuelles ?
Écrit avec des mesures de Dirac : $ mu_x (v, a) = 1/N sum_(i=1)^N delta_((V_t^i, A_t^i)) (v, a). $
$ mu_x (v, dot) = sum_(i=1)^N delta_((V_t^i, A_t^i)) (v, 0) + delta_((V_t^i, A_t^i)) (v, 1). $

// À réécrire
Cette représentation permet de réduire la taille de l'espace $cal(X)$ des états possibles en considérant tous les neurones comme identiques et en prenant en compte que le nombre total de neurones est fixé à $N$. En utilisant un peu de combinatoire, nous obtenons désormais $ abs(cal(X)) = vec(N - 2theta + 1, 2theta + 1). $ (nombre de représentation possible de n étoiles avec m barres)

Pour simplifier la notation, nous noterons $x_(v, f) = mu_x (v, f)$ et $x_(v, dot) = mu_x(v, dot)$. 
Pour parler plus simplement, nous utiliserons le terme de _couche_ $v$ pour désigner les neurones ayant un potentiel de membrane $V_t^i = v$, càd $mu_x (v, dot) "ou" x_(v, dot)$.

== Espace absorbant
=== États absorbants
Le système n'émettra plus aucun saut lorsque :
- aucun neurone ne se trouve dans un état permettant un spike,
- tous les neurones sont désactivés.
Un état absorbant $cal(a)$ se définit donc de la façon suivante :
$ cal(a) = vec((v_1, 0), (v_2, 0), dots.v, (v_N, 0)), space forall v_i < theta. $

=== États presque-absorbants
Autour de ces états absorbants existent aussi des états qui mènent presque-sûrement vers ces états absorbants en temps fini. Nous les appellerons les états _presque-absorbants_. C'est le cas par exemple des états où aucun neurone n'est en capacité de spiker. En temps fini, les neurones vont se désactivé un à un jusqu'à atteindre l'état absorbant.\
C'est aussi le cas pour un état moins trivial, qui est celui (...)

=== Espace absorbant
Nous notons $cal(A)$, l'*espace rassemblant les états absorbants et presque-absorbants* :
$ cal(A) = union.big_(k=0)^theta A_k, $ avec $ cal(A)_k = {X in cal(X) : space sum_(l = k)^theta mu (l, 1) <= theta - k } space forall k in {1, dots}, $
et le cas particulier suivant :
$ cal(A)_0 = {X in cal(X) : mu(theta, 0) + sum_(l=0)^theta mu(l, 1) < theta}. $


Étudions maintenant l'irréductibilité de la chaîne de Markov sur cet espace $cal(A)^complement$.

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
À partir de cet état $x'''$, montrons que nous pouvons atteindre l'état $y$ en un nombre fini d'opérations. Cet état $y in cal(X)_"irr"$ se définit de façon très générale : $ forall v = 0, dots, theta, space vec((y_(0, 0), y_(0, 1)), dots.v, (y_(v, 0), y_(v, 1)), dots.v, (y_(theta, 0), y_(theta, 1))). $ Nous allons prouver cela en définissant une suite $y^l$ qui permet, depuis $x'''$, d'atteindre l'état $y$ avec une probabilité positive. La suite se définit de la façon suivante : on commence par désactive le bon nombre de neurones dans la couche $theta$, puis on fait ce même nombre de spikes inefficaces et on fait un spike efficace. Formellement, cela donne :
$ y^0 = O_i^(y_(theta, dot) - 1) compose O_(d, theta)^(y_(theta, dot) - 1) (x'''), $ et 
$ forall l in {0, dots, theta - 1}, space y^(l+1) = O_i^(y_(theta - l, dot) - 1) compose O_(d, theta)^(y_(theta - l, dot) - 1) compose O_e^1 (y^l). $

Enfin, nous désactivons le bon nombre de neurones dans toutes les couches pour arriver à $y$ : $ y = O_(d, v)^(y_(v, 0)) (y^theta), space forall v = 0, dots, theta. $
Par construction, les états $y^l$ sont tous bien dans $cal(X)_"irr"$.\

== Distribution quasi-stationnaire


== Limite en champ moyen
L'hypothèse de champ moyen que nous allons faire dans cette partie consiste à considérer un grand nombre de neurones $N$ et à les considérer comme étant tous identiques. Cela permet plusieurs simplifications :
#set math.vec(delim: none)
- Au lieu d'écrire $sum_vec(j = 0, j != i)^N$, nous écrirons $sum_(j = 1)^N$.
- Nous allons poser $Y_t^i = A_t^i bold(1)_(U_(t+1)^j <= phi.alt(V_t^i)).$

Nous allons supposer l'existence d'une "loi des grands nombres" permettant d'affirmer que $ 1/N sum_(i=0)^N V_i^t ~ bb(E)[V_i^t]. $
et que $ 1/N sum_(i=0)^N Y_i^t ~ bb(E)[Y_i^t]. $

=== Processus limites
Nous allons noter $overline(V)_t^i$ et $overline(A)_t^i$ les processus limites de voltage et d'activation pour le neurone $i$. Leur dynamique obéit aux équations suivantes :
$ overline(V)_(t+1)^i = bold(1)_(U_(t+1)^i > phi.alt(overline(V)_t^i))(overline(V)_t^i + sum_vec(j = 0, j != i)^N overline(Y)_t^j), $
$ overline(A)_(t+1)^i = overline(A)_t^i + (1 - overline(A)_t^i)bold(1)_(U_(t+1)^i <= phi.alt(overline(V)_t^i)) - overline(A)_t^i bold(1)_(phi.alt(overline(V)_t^i) <= U_(t+1)^i <= lambda + phi.alt(overline(V)_t^i)). $

=== Existence des processus limites


=== Convergence vers les processus limites
Commençons par définir la distance entre les processus limites et les processus classiques :
$ D^i_(t+1) = d^i_(t+1) + delta^i_(t+1), $ avec $d^i_(t+1) = bb(E)|V^i_(t+1) - overline(V)^i_(t+1)|$ et $delta^i_(t+1) = bb(E)|A_(t+1)^i - overline(A)^i_(t+1)|$.
Nous allons prouver que cette distance converge $D^i_(t+1)$ vers $0$ presque-sûrement.


$ V_(t+1)^i = bold(1)_(U_(t+1)^i > phi.alt(V_t^i)) [V_t^i + 1/N sum_(j≠i)^N Y_t^j] $

$ overline(V)_(t+1)^i = bold(1)_(U_(t+1)^i > phi.alt(overline(V)_t^i)) [overline(V)_t^i + bb(E)[overline(Y)_t^j]] $

$ d_(t+1)^i = bb(E)| bold(1)_(U_(t+1)^i > phi.alt(V_t^i)) (V_t^i + (1/N) sum_(j≠i)^N Y_t^j) - bold(1)_(U_(t+1)^i > phi.alt(overline(V)_t^i)) (overline(V)_t^i + bb(E)[overline(Y)_t^j]) | $

Nous pouvons distinguer trois événements disjoints :

#set enum(numbering: "I")
+ Les deux processus sautent en même temps, c'est-à-dire que $U_(t+1)^i < phi.alt(V_t^i) $ et $ U_(t+1)^i < phi.alt(overline(V)_t^i)$. Dans ce cas, les indicatrices s'annulent et $d_(t+1)^(i, "I") = 0$.

+ Les deux processus ne sautent pas, c'est-à-dire que $U_(t+1)^i > phi.alt(V_t^i)$ et $U_(t+1)^i > phi.alt(overline(V)_t^i). $ Dans ce cas, on se retrouve avec :
    $ d_(t+1)^(i,"II") = |V_t^i - overline(V)_t^i + 1/N sum_(j≠i)^N Y_t^j - bb(E)[overline(Y)_t^j]|. $

+ Un seul des processus saute, c'est-à-dire que $ min(phi.alt(V_t^i), phi.alt(overline(V)_t^i)) < U_(t+1)^i < max(phi.alt(V_t^i), phi.alt(overline(V)_t^i)). $
    Dans ce cas, on obtient : $d_(t+1)^(i,"III") = |V_t^i| "ou" |overline(V)_t^i|$, que l'on peut majorer par $theta$ :
    $ d_(t+1)^(i,"III") <= theta. $

En utilisant les propriétés de l'espérance, nous pouvons écrire :
$ d_(t+1)^i &= bb(E)[bold(1)_"I" 0] + bb(E)[bold(1)_"II" d_(t+1)^(i,"II")] + bb(E)[bold(1)_"III" d_(t+1)^(i,"III")]\
d_(t+1)^i &<= bb(P)("II") bb(E)[d_(t+1)^(i,"II")] + bb(P)("III") theta "car les événements sont indépendants." $

Or nous savons que :
$ bb(P)("III") &= bb(P)(min(phi.alt(V_t^i), phi.alt(overline(V)_t^i)) < U_(t+1)^i < max(phi.alt(V_t^i), phi.alt(overline(V)_t^i))),\
bb(P)("III") &= max(phi.alt(V_t^i), phi.alt(overline(V)_t^i)) - min(phi.alt(V_t^i), phi.alt(overline(V)_t^i)) "car" U_(t+1)^i ~ "Unif"(0, 1). $
Nous pouvons bien sûr écrire :
$ bb(P)("III") &= bb(E)[bb(P)("III" | V_t^i, overline(V)_t^i)],\ 
"où" bb(P)("III" | V_t^i, overline(V)_t^i) &= |phi.alt(V_t^i) - phi.alt(overline(V)_t^i)| = beta |bold(1)[V_t^i = 0] - bold(1)[overline(V)_t^i = 0]|. $

Montrons que $ |bold(1)_(V_t^i = 0) - bold(1)_(overline(V)_t^i = 0)| <= |V_t^i - overline(V)_t^i| $

En effet, $|bold(1)_(V_t^i = 0) - bold(1)_(overline(V)_t^i = 0)|$ ne peut prendre que deux valeurs, 0 ou 1. Dans le premier cas, trivialement :
$ |bold(1)_(V_t^i = 0) - bold(1)_(overline(V)_t^i = 0)| = 0 <= |V_t^i - overline(V)_t^i|. $

Dans le second cas $|bold(1)_(V_t^i = 0) - bold(1)_(overline(V)_t^i = 0)| = 1$
implique nécessairement que $V_t^i ≠ overline(V)_t^i$.\
Or, comme $V_t^i$ et $overline(V)_t^i in {0, 1, ..., theta}$, par construction :
$ V_t^i ≠ overline(V)_t^i => |V_t^i - overline(V)_t^i| >= 1, $
ce qui conclut la preuve. 

Nous avons donc :
$ bb(P)("III" | V_t^i, overline(V)_t^i) <= beta |V_t^i - overline(V)_t^i|, $
soit :
$ bb(P)("III") <= beta d_t^i. $


#set math.vec(delim: "(")

= Modèle en temps continu et équation différentielle stochastique associée
$ d X_t^i &= integral_bb(R)_+ bold(1)_(z<=beta) Delta_a (X^i_t) pi^i (d t, d z) + integral_bb(R)_+ bold(1)_(beta <= z <= beta + lambda)F_(t_-)^i vec(0, -1)pi^i (d t, d z)  \
&+ sum_(j!=i) integral_bb(R)_+ bold(1)_(z<=beta) F_(t_-)^j bold(1)_(U^j_(t_-)= theta) Delta_"ex"(X^i_t_-) pi^j (d t, d z). $
Avec les sauts associés à un spike du neurone lui-même, dit *autonome* :
$ Delta_a (x) = bold(1)_(u = theta)[vec(-u, 1)bold(1)_(f=0) + vec(-u, 0)f],space"pour tout " x = vec(u, f), $
et les sauts déclenchés par un autre neurone *extérieur* : $ Delta_"ex" (x) = vec(u+1 and theta, f),space"pour tout " x = vec(u, f). $
$pi^i$ mesures de Poisson.

$ abs(Y_(t+1)^j - overline(Y)_(t+1)) &= abs(A_t^j  bold(1)_(U_(t+1)^j <= phi.alt(V_r^j)) - overline(A)_t^j  bold(1)_(U_(t+1)^j <= phi.alt(overline(V)_r^j)))\
&= abs(bold(1)_(U_(t+1)^j <= phi.alt(V_r^j)) - bold(1)_(U_(t+1)^j <= phi.alt(overline(V)_r^j)))\
&= bold(1)_(phi.alt(V_r^j) and phi.alt(overline(V)_r^j) <= U_(t+1)^j <= phi.alt(V_r^j) or phi.alt(overline(V)_r^j)).
$

