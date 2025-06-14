#import "@preview/ctheorems:1.1.3": *

#import "rules.typ": *

// Theorem box and proof box
#show: thmrules.with(qed-symbol: $square$)
#let theorem = thmbox("theorem", "Théorème", base_level: 1, stroke: red+1.4pt)
#let lemma = thmbox("theorem", "Lemme", base_level: 1, stroke: 1.4pt)
#let proposition = thmbox("theorem", "Proposition", base_level: 1, stroke: blue+1.4pt)
#let proof = thmproof("proof", "Preuve")

L'hypothèse de champ moyen que nous allons faire dans cette partie consiste à considérer un grand nombre de neurones $N$ et à les considérer comme étant tous identiques. Cela permet plusieurs simplifications :
#set math.vec(delim: none)
- Au lieu d'écrire $sum_vec(j = 0, j != i)^N$, nous écrirons $sum_(j = 1)^N$.
- Nous allons poser $Y_t^i = A_t^i bold(1)_(U_(t+1)^j <= phi.alt(V_t^i)).$

Nous allons supposer l'existence d'une "loi des grands nombres" permettant d'affirmer que $ 1/N sum_(i=0)^N V_i^t ~ bb(E)[V_i^t]. $
et que $ 1/N sum_(i=0)^N Y_i^t ~ bb(E)[Y_i^t]. $

=== Processus limites
Nous allons noter $overline(V)_t^i$ et $overline(A)_t^i$ les processus limites de potentiel de membrane et d'activation pour le neurone $i$. Leur dynamique obéit aux équations suivantes :
$ overline(V)_(t+1)^i = bold(1)_(U_(t+1)^i > phi.alt(overline(V)_t^i))(overline(V)_t^i + sum_vec(j = 0, j != i)^N overline(Y)_t^j), $
$ overline(A)_(t+1)^i = overline(A)_t^i + (1 - overline(A)_t^i)bold(1)_(U_(t+1)^i <= phi.alt(overline(V)_t^i)) - overline(A)_t^i bold(1)_(phi.alt(overline(V)_t^i) <= U_(t+1)^i <= lambda + phi.alt(overline(V)_t^i)). $

=== Existence des processus limites


=== Convergence vers les processus limites
Commençons par définir la distance entre les processus limites et les processus classiques :
$ D^i_(t+1) = abs(d^i_(t+1)) + abs(delta^i_(t+1)), $ avec $d^i_(t+1) = bb(E)abs(V^i_(t+1) - overline(V)^i_(t+1))$ et $delta^i_(t+1) = bb(E)abs(A_(t+1)^i - overline(A)^i_(t+1))$.

#set math.equation(numbering: "(1)")
#theorem("Convergence vers les processus limites")[
    Pour tout $i in {1, dots, N}$, nous avons :
    $ lim_(N->oo) D^i_(t+1) = 0. $ c'est-à-dire que :
    $ lim_(N->oo) abs(d^i_(t+1)) = 0 $ <conv_potentiel> et
    $ lim_(N->oo) abs(delta^i_(t+1)) = 0. $ <conv_activation>
] <convergence>

#proof("de la convergence du processus d'activation")[
    Rappellons les équations de la dynamique de l'activation, pour le processus classique et le processus limite sous les hypothèses de champ moyen :
    $ A_(t+1)^i = A_t^i + (1 - A_t^i)bold(1)_(U_(t+1)^i <= phi.alt(V_t^i)) - A_t^i bold(1)_(phi.alt(V_t^i) <= U_(t+1)^i <= lambda + phi.alt(V_t^i)),\
    overline(A)_(t+1)^i = overline(A)_t^i + (1 - overline(A)_t^i)bold(1)_(U_(t+1)^i <= phi.alt(overline(V)_t^i)) - overline(A)_t^i bold(1)_(phi.alt(overline(V)_t^i) <= U_(t+1)^i <= lambda + phi.alt(overline(V)_t^i)). $
    Ainsi, $ delta_(t+1)^i = bb(E)abs(A_(t+1)^i - overline(A)_(t+1)^i) <= bb(E)abs(A_t^i - overline(A)_t^i) +\
    bb(E)abs((1 - A_t^i)bold(1)_(U_(t+1)^i <= phi.alt(V_t^i)) - (1 - overline(A)_t^i)bold(1)_(U_(t+1)^i <= phi.alt(overline(V)_t^i)) - (A_t^i bold(1)_(phi.alt(V_t^i) <= U_(t+1)^i <= lambda + phi.alt(V_t^i)) - overline(A)_t^i bold(1)_(phi.alt(overline(V)_t^i) <= U_(t+1)^i <= lambda + phi.alt(overline(V)_t^i)))) $
    
    Nous pouvons, en distinguant trois événements disjoints, écrire que :

    $ delta_(t+1)^i <= delta_t^i + bb(P)("I") delta_(t+1)^(i,"I") + bb(P)("II") delta_(t+1)^(i,"II") + bb(P)("III") delta_(t+1)^(i,"III") $

    Les trois événements sont :
    #set enum(numbering: "I.")
    + Les 2 processus spikent en t+1, c'est-à-dire que $U_(t+1)^i > phi.alt(V_t^i)$ et $U_(t+1)^i > phi.alt(overline(V)_t^i).$ Dans ce cas :
        $ bold(1)_(phi.alt(V_t^i) <= U_(t+1)^i <= phi.alt(overline(V)_t^i) + lambda) = bold(1)_(phi.alt(overline(V)_t^i) <= U_(t+1)^i <= phi.alt(overline(V)_t^i) + lambda) = 0 $
        et
        $ bold(1)_(U_(t+1)^i <= phi.alt(V_t^i)) = bold(1)_(U_(t+1)^i <= phi.alt(overline(V)_t^i)) = 1. $
        Nous avons alors : $ delta_(t+1)^(i,"I") = bb(E)abs((1 - overline(A)_t^i) - (1 - overline(A)_t^i)) = abs(delta_t^i). $
    
    + Le 2 processus ne spikent pas, c'est-à-dire que $U_(t+1)^i > phi.alt(V_t^i)$ et $U_(t+1)^i > phi.alt(overline(V)_t^i)$. Nous obtenons : 
        $ delta_(t+1)^(i,"II") = bb(E)abs(A_t^i bold(1)_(phi.alt(V_t^i) <= U_(t+1)^i <= phi.alt(V_t^i) + lambda) - overline(A)_t^i bold(1)_(phi.alt(overline(V)_t^i) <= U_(t+1)^i <= phi.alt(overline(V)_t^i) + lambda)). $

    + Un seul spike, soit 
        $ min(phi.alt(V_t^i), phi.alt(overline(V)_t^i)) < U_(t+1)^i < max(phi.alt(V_t^i), phi.alt(overline(V)_t^i)). $
        Dans ce cas :
        $ delta_(t+1)^(i,"III") <= 1. $

    Nous pouvons donc majorer la distance $delta_(t+1)^i$ avec :
    $ delta_(t+1)^i <= delta_t^i + bb(P)("I") abs(delta_t^i) + bb(P)("II") bb(E)abs(A_t^i bold(1)_(phi.alt(V_t^i) <= U_(t+1)^i <= phi.alt(V_t^i) + lambda) - overline(A)_t^i bold(1)_(phi.alt(overline(V)_t^i) <= U_(t+1)^i <= phi.alt(overline(V)_t^i) + lambda)) + bb(P)("III"), $ où $bb(P)(min[phi.alt(V_t^i), phi.alt(overline(V)_t^i)] < U_(t+1)^i < max[phi.alt(V_t^i), phi.alt(overline(V)_t^i)])$

    L'expression précédente peut se simplifier encore, en remarquant la proposition qui suit, provenant de la structure discrète de notre processus. 
    #proposition()[
        $ bb(P)(min[phi.alt(V_t^i), phi.alt(overline(V)_t^i)] < U_(t+1)^i < max[phi.alt(V_t^i), phi.alt(overline(V)_t^i)]) <= beta abs(d_t^i). $
    ] <majoration_discrete>
    #proof("de la majoration ")[
        Notons, pour simplifier, par $e$ l'événement suivant $ e = {min[phi.alt(V_t^i), phi.alt(overline(V)_t^i)] < U_(t+1)^i < max[phi.alt(V_t^i), phi.alt(overline(V)_t^i)]}. $

        Écrivons, en utilisant la formule de l'espérance totale :
        $ bb(P)(e) = bb(E)[bold(1)_e] = bb(E)[bb(E)(bold(1)_e | V_t^i, overline(V)_t^i)] = bb(E)[bb(P)(e | V_t^i, overline(V)_t^i)]. $
        
        Or,
        $ bb(P)(e| V_t^i, overline(V)_t^i) = max(phi.alt(V_t^i), phi.alt(overline(V)_t^i)) - min(phi.alt(V_t^i), phi.alt(overline(V)_t^i)) "car" U_(t+1)^i ~ "Unif"(0, 1),\
        => bb(P)(e | V_t^i, overline(V)_t^i)  = abs(phi.alt(V_t^i) - phi.alt(overline(V)_t^i)) = beta abs(bold(1)_(V_t^i = theta) - bold(1)_(overline(V)_t^i = theta)). $

        Ensuite, remarquons que $abs(bold(1)_(V_t^i = theta) - bold(1)_(overline(V)_t^i = theta))$ ne peut prendre que deux valeurs, 0 ou 1. Dans le premier cas, trivialement :
        $ abs(bold(1)_(V_t^i = theta) - bold(1)_(overline(V)_t^i = theta)) = 0 <= abs(V_t^i - overline(V)_t^i). $

        Dans le second cas $abs(bold(1)_(V_t^i = theta) - bold(1)_(overline(V)_t^i = theta)) = 1$
        implique nécessairement que $V_t^i ≠ overline(V)_t^i$.\
        Or, comme $V_t^i$ et $overline(V)_t^i in {0, 1, ..., theta}$, par construction :
        $ V_t^i ≠ overline(V)_t^i => abs(V_t^i - overline(V)_t^i) >= 1,\
        => abs(bold(1)_(V_t^i = theta) - bold(1)_(overline(V)_t^i = theta)) <= 1 <= abs(V_t^i - overline(V)_t^i). $
        Nous avons donc $ abs(bold(1)_(V_t^i = theta) - bold(1)_(overline(V)_t^i = theta)) <= abs(V_t^i - overline(V)_t^i), $
        que nous pouvons utiliser pour majorer $bb(P)(e | V_t^i, overline(V)_t^i)$ :
        $ bb(P)(e | V_t^i, overline(V)_t^i) <= beta abs(V_t^i - overline(V)_t^i), $
        $ => bb(P)(e) <= beta bb(E)abs(V_t^i - overline(V)_t^i) = beta abs(d_t^i). $
    ]

    En utilisant la @majoration_discrete, nous arrivons à la majoration suivante pour $delta_(t+1)^i$ :
    $ => delta_(t+1)^i <= 2 abs(delta_t^i) + beta abs(d_t^i) + delta_(t+1)^(i, "II") + lambda)). $

    Trouvons une majoration pour $delta_(t+1)^(i,"II")$. De nouveau, nous pouvons séparer l'espérance en utilisant trois événements distincts : 

    $ delta_(t+1)^(i,"II") = bb(P)("IV") delta_(t+1)^(i,"IV") + bb(P)("V") delta_(t+1)^(i,"V") + bb(P)("VI") delta_(t+1)^(i,"VI"). $

    + Les deux synapses se désactivent à t+1, soit $phi.alt(V_t^i) <= U_(t+1)^i <= phi.alt(V_t^i)+ lambda$ et $phi.alt(overline(V)_t^i) <= U_(t+1)^i <= phi.alt(overline(V)_t^i)+ lambda$.  
        Nous aurons donc :  
        $ delta_(t+1)^(i,"IV") = delta_t^i. $

    + Aucune ne se désactive, c'est-à-dire que $U_(t+1)^i > phi.alt(V_t^i)+ lambda$ et $U_(t+1)^i > phi.alt(overline(V)_t^i)+ lambda$.  
        Nous obtenons :
        $ delta_(t+1)^(i,"V") = 0 $

    + Une seule synapse est désactivée :  
        $ min(phi.alt(V_t^i), phi.alt(overline(V)_t^i))+ lambda <= U_(t+1)^i <= max(phi.alt(V_t^i), phi.alt(overline(V)_t^i))+ lambda. $  
        Alors  
        $ delta_(t+1)^(i,"VI") <= 1. $

    Nous aboutissons à :  
    $ delta_(t+1)^(i,"II") <= delta_t^i + bb(P)("VI"). $

    Or, nous pouvons remarquer que :
    $ &bb(P)("VI") = bb(P)(min[phi.alt(V_t^i), phi.alt(overline(V)_t^i)]+ lambda <= U_(t+1)^i <= max[phi.alt(V_t^i), phi.alt(overline(V)_t^i)]+ lambda) \
    &=> bb(P)("VI") = max[phi.alt(V_t^i), phi.alt(overline(V)_t^i)] - min[phi.alt(V_t^i), phi.alt(overline(V)_t^i)] + lambda - lambda \
    &=> bb(P)("VI") = bb(P)(min[phi.alt(V_t^i), phi.alt(overline(V)_t^i)] < U_(t+1)^i < max[phi.alt(V_t^i), phi.alt(overline(V)_t^i)]). $

    D'où nous pouvons utiliser la @majoration_discrete pour écrire :
    $ bb(P)("VI") <= beta d_t^i. $
    Enfin,
    $ delta_(t+1)^(i,"II") <= delta_t^i + beta d_t^i, \
    => delta_(t+1)^i <= 3 delta_t^i + 2 beta d_t^i. $

    À t=0, nous avons $d_0^i = delta_0^i = 0$ car nous avons supposé $A_0^i = overline(A)_0^i$ et $V_0^i = overline(V)_0^i$.  
    Ainsi,
    $ &delta_1^i <= 0,\
    &delta_2^i <= 2beta d_1^i,\
    &delta_3^i <= 6beta d_1^i + 2beta d_2^i,\
    dots.v\
    &delta_(t+1)^i <= 2beta sum_(n=1)^t 3^(n-1) d_(t-n)^i. $
    Nous voyons ainsi que nous avons besoin de majorer la distance $d_t^i$ pour conclure la preuve.
]

#proof("de la convergence du processus de potentiel de membrane")[
    On rappelle les équations de la dynamique du potentiel de membrane, pour le processus classique et le processus limite sous les hypothèses de champ moyen :
$ V_(t+1)^i = bold(1)_(U_(t+1)^i > phi.alt(V_t^i)) [V_t^i + 1/N sum_(j≠i)^N Y_t^j], $
$ overline(V)_(t+1)^i = bold(1)_(U_(t+1)^i > phi.alt(overline(V)_t^i)) [overline(V)_t^i + bb(E)[overline(Y)_t^j]]. $
Développons la distance entre ces deux processus :
$ d^i_(t+1) &= bb(E)abs(V^i_(t+1) - overline(V)^i_(t+1)),\
    &=bb(E)abs( bold(1)_(U_(t+1)^i > phi.alt(V_t^i)) (V_t^i + 1/N sum_(j≠i)^N Y_t^j) - bold(1)_(U_(t+1)^i > phi.alt(overline(V)_t^i)) (overline(V)_t^i + bb(E)[overline(Y)_t^j]) ). $

Nous pouvons distinguer de nouveau les trois même événements disjoints pour écrire que $ d_(t+1)^i = bb(E)[bold(1)_"I" 0] + bb(E)[bold(1)_"II" d_(t+1)^(i,"II")] + bb(E)[bold(1)_"III" d_(t+1)^(i,"III")], $
et majorer la distance $d^i_(t+1)$ :

+ Les deux processus sautent en même temps, c'est-à-dire que $U_(t+1)^i < phi.alt(V_t^i) $ et $ U_(t+1)^i < phi.alt(overline(V)_t^i)$. Dans ce cas, les indicatrices s'annulent et $d_(t+1)^(i, "I") = 0$.

+ Les deux processus ne sautent pas, c'est-à-dire que $U_(t+1)^i > phi.alt(V_t^i)$ et $U_(t+1)^i > phi.alt(overline(V)_t^i). $ Dans ce cas, on se retrouve avec :
    $ d_(t+1)^(i,"II") = abs(V_t^i - overline(V)_t^i + 1/N sum_(j≠i)^N Y_t^j - bb(E)[overline(Y)_t^j]). $

+ Un seul des processus saute, c'est-à-dire que $ min(phi.alt(V_t^i), phi.alt(overline(V)_t^i)) < U_(t+1)^i < max(phi.alt(V_t^i), phi.alt(overline(V)_t^i)). $
    Dans ce cas, on obtient : $d_(t+1)^(i,"III") = abs(V_t^i) "ou" abs(overline(V)_t^i)$, que l'on peut majorer par $theta$ :
    $ d_(t+1)^(i,"III") <= theta. $

Finalement,
$ d_(t+1)^i <= bb(P)("II") bb(E)[d_(t+1)^(i,"II")] + bb(P)("III") theta. $

\
En reprenant la majoration de $d_(t+1)^i$ avec la @majoration_discrete, nous avons :
$ d_(t+1)^i <= bb(P)("II")space bb(E)[d_(t+1)^(i,"II")] + beta abs(d_t^i) theta. $\

Calculons maintenant $bb(E)[d_(t+1)^(i,"II")]$. On rappelle que :

$ d_(t+1)^(i,"II") = abs(V_t^i - overline(V)_t^i + 1/N sum_(j≠i)^N Y_t^j - bb(E)[overline(Y)_t^j]). $

Si on ajoute et retire $1/N sum_(j≠i)^N Y_t^j $ à $ overline(V)_(t+1)^i$ :

$ &overline(V)_(t+1)^i = V_t^i + 1/N sum_(j≠i)^N overline(Y)_(t+1)^j - 1/N [ sum_(j≠i)^N overline(Y)_(t+1)^j - bb(E)[overline(Y)_(t+1)^j] ],\
&=> overline(V)_(t+1)^i = V_t^i + 1/N sum_(j≠i)^N overline(Y)_(t+1)^j - 1/N overline(M)_(t+1)^i, $

en posant $overline(M)_(t+1)^i = sum_(j≠i)^N (overline(Y)_(t+1)^j - bb(E)[overline(Y)_(t+1)^j]).$ Nous avons donc :

$ d_(t+1)^(i,"II") &= abs(V_t^i - overline(V)_t^i + 1/N sum_(j≠i)^N Y_t^j - 1/N sum_(j≠i)^N overline(Y)_t^j + 1/N overline(M)_(t+1)^i)\
d_(t+1)^(i,"II") &<= abs(V_t^i - overline(V)_t^i) + 1/N sum_(j≠i)^N abs(Y_t^j - overline(Y)_t^j) + 1/N abs(overline(M)_(t+1)^i). $

Soit,  
$ bb(E)[d_(t+1)^(i,"II")] <= abs(d_t^i) + 1/N sum_(j≠i)^N bb(E)abs(Y_t^j - overline(Y)_t^j) + 1/N bb(E)abs(overline(M)_(t+1)^i). $

L'objectif est de trouver une majoration pertinente pour $bb(E)[d_(t+1)^(i,"II")]$. Cela commence par remarquer la proposition suivante :
#proposition()[
    $ bb(E)abs(overline(M)_(t+1)^i) <= sqrt(N/4). $
] <majoration_martingale>
#proof()[
    Nous pouvons écrire :
    $ abs(overline(M)_(t+1)^i) &= sqrt(abs(overline(M)_(t+1)^i)^2),\
    => bb(E)abs(overline(M)_(t+1)^i) &= bb(E)[sqrt(abs(overline(M)_(t+1)^i)^2)],\
    => bb(E)abs(overline(M)_(t+1)^i) &<= sqrt(bb(E)[ abs(overline(M)_(t+1)^i)^2]) "par Jensen concave." $

    $  bb(E)[ abs(overline(M)_(t+1)^i)^2] &= bb(E)[(sum_(j≠i)^N overline(Y)_(t+1)^j - bb(E)[overline(Y)_(t+1)^j])^2],\
    &= bb(E)[sum_(j≠i)^N (overline(Y)_(t+1)^j - bb(E)[overline(Y)_(t+1)^j])^2 + 2 sum_(0<=k<j<=N) (overline(Y)_(t+1)^k - bb(E)[overline(Y)_(t+1)^k]) (overline(Y)_(t+1)^j - bb(E)[overline(Y)_(t+1)^j])],\
    &= sum_(j≠i)^N bb(E)[(overline(Y)_(t+1)^j - bb(E)[overline(Y)_(t+1)^j])^2] + 2 sum_(0<=k<j<=N) bb(E)[(overline(Y)_(t+1)^k - bb(E)[overline(Y)_(t+1)^k]) (overline(Y)_(t+1)^j - bb(E)[overline(Y)_(t+1)^j])],\
    &= sum_(j≠i)^N "Var"[overline(Y)_(t+1)^j] + 2 sum_(0<=k<j<=N) "Cov"(overline(Y)_(t+1)^k, overline(Y)_(t+1)^j). $

    Or, comme nous travaillons dans le cadre champ moyen, les neurones sont des copies indépendantes les uns des autres. Ainsi $"Cov"(overline(Y)_(t+1)^k, overline(Y)_(t+1)^j) = 0$ et
    $ bb(E)[ abs(overline(M)_(t+1)^i)^2] = sum_(j≠i)^N "Var"[overline(Y)_(t+1)^j] = N "Var"[overline(Y)_(t+1)^j]. $

    Comme $overline(Y)_(t+1)^j in {0, 1}$, alors $0 <= bb(E)[overline(Y)_(t+1)^j] <= 1$, ce qui implique que :

    $ &"Var"[overline(Y)_(t+1)^j] = bb(E)[overline(Y)_(t+1)^j](1 - bb(E)[overline(Y)_(t+1)^j]) <= 1/4,\
    &=> bb(E)[ abs(overline(M)_(t+1)^i)^2] <= N/4,\
    &=> sqrt(bb(E)[ abs(overline(M)_(t+1)^i)^2]) <= sqrt(N/4),\
    &"d'où" bb(E)abs(overline(M)_(t+1)^i) <= sqrt(N/4). $
]

En reprenant l'expression de $bb(E)[d_(t+1)^(i,"II")]$ et en utilisant la @majoration_martingale, nous obtenons :
$ bb(E)[d_(t+1)^(i,"II")] <= d_t^i + 1/N sum_(j≠i)^N bb(E)abs(Y_t^j - overline(Y)_t^j) + 1/(4sqrt(N)). $

Il reste désormais à majorer le terme $bb(E)abs(Y_t^j - overline(Y)_t^j)$. On rappelle que :

]