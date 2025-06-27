#import "../rules.typ": *
#import "../global_variables.typ": *

// Display settings for theorems and proofs
#show: thmrules.with(qed-symbol: $square$)

// Variables for this section
#let distance_activation(t: $t$, i: $i$) = $delta_#t^(#i, N)$
#let distance_potential(t: $t$) = $d_#t^(i, N)$
#let distance_globale(t: $t$) = $D_#t^(i, N)$
#let simplification_variable(t: $t$, i: $i$) = $Y_#t^#i$
#let simplification_variable_limit(t: $t$, i: $i$) = $overline(Y)_#t^#i$
#let potential_limit_dynamics = $#membrane_potential_limit(t: $t+1$) = #non_spiking_indicator_limit (#membrane_potential_limit() + bb(E)[#simplification_variable()])$
#let non_spiking_indicator_limit = $bold(1)_(#auxiliary_uniform(t: $t+1$) > #spiking_function(v: membrane_potential_limit()))$

L'hypothèse de champ moyen que nous allons faire dans cette partie consiste à considérer un grand nombre de neurones $N$ et à les considérer comme étant tous *identiques*, c'est-à-dire indiscernables et avec les même valeurs pour conditions initiales :
$ forall (v, a) in {0, 1, dots, #max_potential} times {0, 1},\
X_0^N = vec((v, a), (v, a), dots.v, (v, a)). $

#set math.vec(delim: none)
Comme les neurones sont indiscernables, nous pouvons les compter simplement et au lieu d'écrire $sum_vec(j = 0, j != i)^N$, écrire directement $sum_(j = 1)^N$.

Avec le modèle utilisé dans les parties précédentes, lorsque nous ferons tendre $N$ vers l'infini, la somme $sum_(j = 1)^N #activation()#spiking_indicator()$ explosera. Pour conserver l'intégrité du modèle, nous allons ajouter un facteur $1/N$ pour normaliser cette somme. Enfin, pour alléger l'écriture, nous noterons à partir de maintenant
$ #simplification_variable() = #activation()#spiking_indicator(). $

Ainsi l'équation de la dynamique du potentiel de membrane,
#potential_dynamics
#let potential_dynamics_meanfield = $#membrane_potential(t: $t+1$) = #non_spiking_indicator (#membrane_potential() + 1/N sum_(j=1)^N #simplification_variable(i: $j$))$
s'écrit désormais
$ #potential_dynamics_meanfield. $


== Processus limites
Nous allons noter #membrane_potential_limit() et #activation_limit() les valeurs des *processus limites* de potentiel de membrane et d'activation pour le neurone $i$ au temps $t$. Pour suivre cette notation, posons également que $#simplification_variable_limit() = #activation_limit()#spiking_indicator_limit()$.

La dynamique du processus limite de l'activation de la synapse du neurone $i$ reste défini de façon similaire que la dynamique du processus classique :
$ #activation_limit(t: $t+1$) = #spiking_indicator_limit() + #non_spiking_indicator_limit #activation_limit() (1 - #deactivation_indicator). $ 

Cependant, la variable aléatoire #membrane_potential_limit() se voit modifiée plus profondément par l'hypothèse de champ moyen. En effet, le champ moyen suppose l'existence d'une certaine "loi des grands nombres" stipulant que
$ 1/N sum_(i=0)^N #simplification_variable_limit() ->_(N -> oo) bb(E)[#simplification_variable_limit()]. $

Ainsi la dynamique du processus limite du potentiel de membrane s'écrit :
$ #potential_limit_dynamics. $

Faisons la remarque que les processus #membrane_potential() et #membrane_potential_limit() partagent tous les deux la même variable #auxiliary_uniform().

#let max_potential_limit = $K gamma$
#let space_value_potential_limit = ${0, gamma, 2 gamma, dots, #max_potential_limit}$
La variable aléatoire #membrane_potential() avait été définie comme à valeurs dans $#space_value_potential subset bb(N)$. Or nous voyons désormais que #membrane_potential_limit() ne respecte plus cette définition, notamment car $bb(E)[#simplification_variable_limit()]$ est un *nombre réel* et dépendant du temps $t$.\
Supposons que $gamma_t = bb(E)[#simplification_variable_limit()]$. Intuitivement, cela signifie qu'à chaque pas de temps, le potentiel de membrane limite #membrane_potential_limit() augmente d'une quantité fixée $gamma_t$, dépendante du temps.\
Nous pouvons même calculer la valeur de $gamma_t$ :
$ gamma_t &= bb(E)[#activation_limit()#spiking_indicator_limit()],\
&= bb(P)(#auxiliary_uniform(t: $t+1$) > #spiking_function(v: membrane_potential_limit())) bb(E)[#activation_limit()|#auxiliary_uniform(t: $t+1$) > #spiking_function(v: membrane_potential_limit())],\
&= #spiking_function(v: membrane_potential_limit()) bb(E)[#activation_limit()]. $

Ce qui nous permet d'écrire la majoration suivante :
#numbered_equation($ gamma_t <= #spiking_probability. $, <majoration_gamma_t>)

Comme nous sommes placés sur une fenêtre temporelle de taille $T$, nous sommes donc en capactié de minorer la valeur de $gamma_t$.\
Soit $t^*$ le temps critique où $gamma_t = 0$, c'est à dire le temps où la chaîne #chain() est absorbée. En effet, $gamma_t = 0$ implique que tous les neurones du processus limite soient désactivés ou qu'ils soient tous dans une couche inférieure à $K gamma$.\
Ainsi, 
$ t^* = inf{t > 0 : gamma_t = 0}. $

Comme nous travaillons en temps discret, cela nous permet de maintenir la valeur de $gamma_t$ supérieure à un certain seuil $epsilon > 0$ pour tout $t < t^*$.\
D'après @majoration_gamma_t, nous avons donc pour toute valeur de $t < t^*$,
#numbered_equation($ epsilon <= gamma_t <= #spiking_probability. $, <encadrement_gamma_t>)

Ainsi *TODO: Écrire l'espace des valeurs possibles de #membrane_potential_limit().*


Comme #membrane_potential(), le potentiel limite #membrane_potential_limit() sera en capacité d'émettre un potentiel d'action après avoir dépassé le potentiel seuil $#max_potential$.\
Notons #max_potential_limit, la valeur maximale que peut prendre le potentiel de membrane limite, où $K$ correspond au nombre minimal de pas nécessaires pour dépasser #max_potential. $K$ est donc un *entier positif*, défini de la façon suivante : 
$ K = ceil(#max_potential / gamma). $


== Existence des processus limites
Comme les deux processus limites #neuron_limit() prennent leurs valeurs dans des espaces discrets et finis, ils sont tous les deux bien définis. L'existence des processus ne pose ainsi aucun problème.


== Convergence vers les processus limites
Nous allons démontrer que les processus classiques convergent vers les processus limites. Les processus de voltage et d'activation doivent tous deux converger vers leurs processus limites respectifs.\
Ainsi, si nous définissons la *distance entre les processus de potentiel de membrane* 
$ #distance_potential() = bb(E)abs(#membrane_potential() - #membrane_potential_limit()), $ ainsi que *distance entre les processus d'activation* 
$ #distance_activation() = bb(E)abs(#activation() - #activation_limit()), $ nous pouvons écrire la *distance globale* entre le processus de neurone et sa limite comme 
#numbered_equation($ #distance_globale() = #distance_potential() + #distance_activation(). $, <distance_globale>)

#theorem("Convergence des processus classiques vers les processsus limites")[
    Pour tout $i in #indexes_interval$, et pour un $t in #time_interval$, avec $T$ nombre entier positif,
    $ (#membrane_potential(), #activation()) ->_(N -> oo) (#membrane_potential_limit(), #activation_limit()), $
    ce qui revient à dire que :
    $ lim #distance_globale() ->_(N -> oo) 0. $
] <theoreme_convergence_processus>

#proof()[
    Pour prouver le @theoreme_convergence_processus, nous allons  consiste à trouver une majoration de #distance_globale(t: $t+1$) par une fonction de $N$ qui puisse disparaître lorsque $N -> oo$.\

    La trame de la preuve est la suivante :
    + Trouver des majorations de #distance_activation(t: $t+1$) et #distance_potential(t: $t+1$) qui utilisent #distance_globale().
    + Utiliser ces majorations pour trouver une majoration de #distance_globale(t: $t+1$) en fonction de #distance_globale() et d'une fonction de $N$ qui pourra disparaître lorsque $N$ deviendra grand.
    + Montrer par récurrence que #distance_globale(t: $t+1$) est bornée par une fonction de $N$ qui tend vers zéro lorsque $N$ tend vers l'infini.

    === Majoration de #distance_activation(t: $t+1$)
    Commençons par majorer #distance_activation(t: $t+1$). De la définition, il vient :
    $ #distance_activation(t: $t+1$) &= bb(E)abs(#activation(t: $t+1$) - #activation_limit(t: $t+1$))\
    &= bb(E)underbrace(abs(#spiking_indicator() - #spiking_indicator_limit() + #activation()#non_spiking_indicator (1 - #deactivation_indicator) - #activation_limit()#non_spiking_indicator_limit (1 - #deactivation_indicator)),"= e pour simplifier l'écriture pour les lignes suivantes"). $
    
    #let simultaneous_spikes_event = $bold(2)$
    #let alone_spike_event = $bold(1)$
    #let no_spike_event = $bold(0)$
    Remarquons que les trois événements suivants sont disjoints :
    - L'événement $#simultaneous_spikes_event = {"processus classique et limite spikent simultanément en" t+1}$ peut s'écrire formellement :
        #numbered_equation($ #simultaneous_spikes_event = {0 < #auxiliary_uniform(t: $t+1$) < #spiking_probability} inter {#membrane_potential() = #membrane_potential_limit() = #max_potential}. $, <definition_simultaneous_spikes_event>)

    - L'évévement $#alone_spike_event = {"processus classique ou limitespike en" t+1} = {0 < #auxiliary_uniform(t: $t+1$) < #spiking_probability} inter {#membrane_potential() < #max_potential "ou" #membrane_potential_limit() < #max_potential}.$

    - L'événement $#no_spike_event = {"aucun processus ne spike au temps" t+1} = {#auxiliary_uniform(t: $t+1$) > #spiking_probability} union {#membrane_potential() < #max_potential "et" #membrane_potential_limit() < #max_potential}.$
    <evenements_spike>

    Nous pouvons donc écrire
    #numbered_equation(
        $ #distance_activation(t: $t+1$) =bb(P)(#simultaneous_spikes_event)bb(E)[e|#simultaneous_spikes_event] + bb(P)(#alone_spike_event)bb(E)[e|#alone_spike_event] + bb(P)(#no_spike_event)bb(E)[e|#no_spike_event]. $, <majoration_distance_activation>
    )

    - Si #simultaneous_spikes_event est vérifié, alors seules les indicatrices de spike valent un, et les autres sont nulles, soit $#spiking_indicator() = #spiking_indicator_limit() = 1$ et donc forcément $#non_spiking_indicator = #non_spiking_indicator_limit = 0$.\
        Dans ce cas, très simplement, 
        $ bb(E)[e|#simultaneous_spikes_event] = bb(E)abs(1 - 1) = 0. $

    - Si #alone_spike_event est vérifié, nous avons alors $#spiking_indicator() != #spiking_indicator_limit()$ où l'une des deux indicatrices de spike vaut un, et l'autre zéro.\
        Le fait que l'une des deux indicatrices de spike vale un, implique nécessaire que $0 < #auxiliary_uniform(t: $t+1$) < #spiking_probability$. Comme les événements de saut et de désactivation sont mutuellement exclusifs nous avons également dans ce cas là $#deactivation_indicator = 0$.\
        Nous avons donc deux possibilités, selon lequel des processus spikent :
        $ bb(E)[e|#alone_spike_event] &= cases(bb(E)abs(1- #activation()) "si le processus limite spike", bb(E)abs(1 - #activation_limit()) "si le processus normal spike"),\
        &<= 1. $

    - Si #no_spike_event est vérifié, alors seulent $#non_spiking_indicator = #non_spiking_indicator_limit = 1$ dans $bb(E)[e|#no_spike_event]$.\
        Ainsi,
        $ bb(E)[e|#no_spike_event] &= bb(E)abs(#activation() (1 - #deactivation_indicator) - #activation_limit() (1 - #deactivation_indicator)),\
        &<= bb(E)abs(#activation() - #activation_limit()) + bb(E)abs((#activation() - #activation_limit())#deactivation_indicator),\
        &<= #distance_activation() + bb(E)abs((#activation() - #activation_limit())#deactivation_indicator). $
        Rappellons-nous que la variable auxiliaire uniforme #auxiliary_uniform() est distribuée uniformément sur $[0, 1]$ de façon indépendante du reste des variables aléatoires. Ainsi, nous pouvons continuer de simplifier comme suit :
        $ bb(E)[e|#no_spike_event] &<= #distance_activation() + bb(E)abs(#activation() - #activation_limit())bb(E)[#deactivation_indicator],\
        &<= #distance_activation() + #distance_activation() bb(P)(#spiking_probability < #auxiliary_uniform(t: $t+1$) < #spiking_probability + #deactivation_probability),\
        &<= (1+ #deactivation_probability) #distance_activation(). $        

    #let probability_spike_alone_event = $bb(P)(#membrane_potential() < #max_potential "ou" #membrane_potential_limit() < #max_potential)$

    En reprenant @majoration_distance_activation, nous aboutissons à :
    #numbered_equation(
        $ #distance_activation(t : $t+1$) <= bb(P)(#alone_spike_event) + bb(P)(#no_spike_event)(1 + #deactivation_probability)#distance_activation(). $, <majoration_distance_activation_2>
    )

    La probabilité $bb(P)(#alone_spike_event)$ peut s'écrire :
    #numbered_equation($ bb(P)(#alone_spike_event) = bb(P)({0 < #auxiliary_uniform(t: $t+1$) < #spiking_probability} inter {#membrane_potential() < #max_potential "ou" #membrane_potential_limit() < #max_potential}) = #spiking_probability #probability_spike_alone_event. $,
    <majoration_probability_alone_spike_event>
    )

    Remarquons la proposition suivante, qui nous permet d'introduire #distance_potential() dans la majoration de $bb(P)(#alone_spike_event)$.

    #proposition()[
        $ #probability_spike_alone_event <= #distance_potential(). $
    ] <proposition_majoration_probability_different_voltage>
    #proof[
        Commençons par réécrire #probability_spike_alone_event :
        $ #probability_spike_alone_event = bb(E)[bold(1)_(#membrane_potential() < #max_potential "ou" #membrane_potential_limit() < #max_potential)]. $
        Remarquons ensuite que l'événement ${#membrane_potential() < #max_potential "ou" #membrane_potential_limit() < #max_potential}$ implique que les potentiels de membrane des processus classique et limite sont différents, c'est-à-dire que $#membrane_potential() ≠ #membrane_potential_limit()$.\
        Par construction, #membrane_potential() et #membrane_potential_limit() ne peuvent prendre que des valeurs discrètes comprises entre zéro et #max_potential. Il en découle que la distance entre les deux potentiels de membrane est nécessairement supérieure ou égale à 1, soit $abs(#membrane_potential() - #membrane_potential_limit()) >= 1$.\
        Ainsi, nous avons :
        $ abs(#membrane_potential() - #membrane_potential_limit()) >= bold(1)_(#membrane_potential() < #max_potential "ou" #membrane_potential_limit() < #max_potential),\
        "et donc" bb(E)[bold(1)_(#membrane_potential() < #max_potential "ou" #membrane_potential_limit() < #max_potential)] <= bb(E)abs(#membrane_potential() - #membrane_potential_limit()) = #distance_potential(). $
    ]

    Si nous appliquons la @proposition_majoration_probability_different_voltage à @majoration_probability_alone_spike_event, nous obtenons :
    #numbered_equation(
        $ bb(P)(#alone_spike_event) <= #spiking_probability #distance_potential(). $, <majoration_probability_alone_spike_event_final>
    )
    Introduisons dans @majoration_distance_activation_2 et il vient :
    #numbered_equation(
        $ #distance_activation(t: $t+1$) <= #spiking_probability #distance_potential() + bb(P)(#no_spike_event)(1 + #deactivation_probability)#distance_activation(). $, <majoration_distance_activation_3>
    )

    Concernant $bb(P)(#no_spike_event)$, nous pouvons tout simplement la majorer par $1$. Nous obtenons finalement :
    $ #distance_activation(t: $t+1$) <= #spiking_probability #distance_potential() + (1 + #deactivation_probability)#distance_activation(). $
    
    Soit, en posant $c = max(#spiking_probability, (1 + #deactivation_probability)) $ :
    $ #distance_activation(t: $t+1$) &<= max(#spiking_probability, 1 + #deactivation_probability) (#distance_potential() + #distance_activation()),\
    &<= c #distance_globale(). $

    Grâce à cette dernière ligne, nous avons désormais la première pièce du puzzle. Si nous réécrivons @distance_globale, nous pouvons dire que :
    #numbered_equation(
        $ #distance_globale(t: $t+1$) <= #distance_potential(t: $t+1$) + c#distance_globale(). $, <majoration_distance_globale_1>
    )

    === Majoration de #distance_potential(t: $t+1$)
    À présent, nous allons nous attaquer à la majoration de #distance_potential(t: $t+1$). De la définition, il vient :
    $ #distance_potential(t: $t+1$) &= bb(E)abs(#membrane_potential(t: $t+1$) - #membrane_potential_limit(t: $t+1$)),\
    &= bb(E)underbrace(abs(#non_spiking_indicator (#membrane_potential() + 1/N sum_(j=1)^N #simplification_variable(i: $j$)) - #non_spiking_indicator_limit (#membrane_potential_limit() + bb(E)[#simplification_variable_limit()])), "= f pour simplifier l'écriture par la suite"). $

    Nous pouvons ici aussi utiliser les trois événements disjoints #simultaneous_spikes_event, #alone_spike_event et #no_spike_event définis précédemment pour écrire :
    #numbered_equation(
        $ #distance_potential(t: $t+1$) = bb(P)(#simultaneous_spikes_event)bb(E)[f|#simultaneous_spikes_event] + bb(P)(#alone_spike_event)bb(E)[f|#alone_spike_event] + bb(P)(#no_spike_event)bb(E)[f|#no_spike_event]. $,
        <majoration_distance_potential_1>
    )


    - Si l'événement #simultaneous_spikes_event est vérifié, alors les indicatrices d'absence de spike sont nulles, c'est-à-dire $#non_spiking_indicator = #non_spiking_indicator_limit = 0$), ce qui nous donne :
        $ bb(E)[f|#simultaneous_spikes_event] = 0. $

    - Si l'événement #alone_spike_event est vérifié, alors seule une des indicatrices d'absence de spike est nulle, soit $#non_spiking_indicator = 0$ ou $#non_spiking_indicator_limit = 0$.\
        Il reste donc dans $bb(E)[f|#alone_spike_event]$ :
        $ bb(E)[f|#alone_spike_event] = cases(bb(E)abs(#membrane_potential() + 1/N sum_(j=1)^N #simplification_variable(i: $j$)) "si le processus limite spike", bb(E)abs(#membrane_potential_limit() + bb(E)[#simplification_variable_limit()]) "si le processus classique spike"). $
        Dans tous les cas, nous pouvons majorer par #max_potential car #membrane_potential() est borné par #max_potential.\
        *TO-DO Véridique ?*
        $ bb(E)[f|#alone_spike_event] <= #max_potential "par construction". $        

    - Si l'événement #no_spike_event est vérifié, alors les indicatrices d'absence de spike valent toutes deux un, c'est-à-dire $#non_spiking_indicator = #non_spiking_indicator_limit = 1$. Cela nous permet d'écrire :
        $ bb(E)[f|#no_spike_event] = bb(E)abs(#membrane_potential() + 1/N sum_(j=1)^N #simplification_variable(i: $j$) - (#membrane_potential_limit() + bb(E)[#simplification_variable_limit()])). $
        Cette quantité sera majorée plus loin, car son développement est un peu plus long.

    En reprenant @majoration_distance_potential_1, et en utilisant @majoration_probability_alone_spike_event_final et $bb(P)(#no_spike_event) <= 1$, nous obtenons :
    #numbered_equation(
        $ #distance_potential(t: $t+1$) <= #spiking_probability #max_potential #distance_potential() + bb(E)[f|#no_spike_event]. $,
        <majoration_distance_potential_2>
    )

    Maintenant, nous allons développer $bb(E)[f|#no_spike_event]$. Ajoutons et retirons $1/N sum_(j=1)^N #simplification_variable_limit(i: $j$)$ :
    $ bb(E)[f|#no_spike_event] &= bb(E)abs(#membrane_potential() + 1/N sum_(j=1)^N #simplification_variable(i: $j$) - (#membrane_potential_limit() + bb(E)[#simplification_variable_limit()]) + 1/N sum_(j=1)^N #simplification_variable_limit(i: $j$) - 1/N sum_(j=1)^N #simplification_variable_limit(i: $j$) ), $

    #let martingale(i: $i$) = $overline(M)_(t)^#i$
    Posons 
    $ #martingale() = sum_(i=1)^N (#simplification_variable_limit(i: $j$) - bb(E)[#simplification_variable_limit(i: $j$)]), $
    nous avons alors,

    #let distance_simplification_variables = $abs(#simplification_variable(i: $j$) - #simplification_variable_limit(i: $j$))$
    #let esperance_distance_simplification_variables = $bb(E)#distance_simplification_variables$
    #numbered_equation(
        $ bb(E)[f|#no_spike_event] &= bb(E)abs(#membrane_potential() - #membrane_potential_limit() + 1/N sum_(j=1)^N #simplification_variable(i: $j$) - 1/N sum_(j=1)^N #simplification_variable_limit(i: $j$) + 1/N #martingale()),\
    &<= bb(E)abs(#membrane_potential() - #membrane_potential_limit()) + 1/N sum_(j=1)^N #esperance_distance_simplification_variables + 1/N bb(E)abs(#martingale()). $,
    <majoration_distance_potential_3>
    )

    Pour majorer cette quantité, énonçons tout d'abord la proposition suivante :

    #proposition()[
        $ bb(E)abs(#martingale()) <= sqrt(N)/2. $
    ] <proposition_majoration_martingale>
    #proof()[
        Nous pouvons écrire :
        $ abs(#martingale()) &= sqrt(abs(#martingale())^2),\
        => bb(E)abs(#martingale()) &= bb(E)[sqrt(abs(#martingale())^2)],\
        => bb(E)abs(#martingale()) &<= sqrt(bb(E)[ abs(#martingale())^2]) "par Jensen concave." $

        $  bb(E)[ abs(#martingale())^2] &= bb(E)[(sum_(j=1)^N #simplification_variable_limit(i: $j$) - bb(E)[#simplification_variable_limit(i: $j$)])^2],\
        &= bb(E)[sum_(j=1)^N (#simplification_variable_limit(i: $j$) - bb(E)[#simplification_variable_limit(i: $j$)])^2 + 2 sum_(0<=k<j<=N) (#simplification_variable_limit(i: $k$) - bb(E)[#simplification_variable_limit(i: $k$)]) (#simplification_variable_limit(i: $j$) - bb(E)[#simplification_variable_limit(i: $j$)])],\
        &= sum_(j=1)^N bb(E)[(#simplification_variable_limit(i: $j$) - bb(E)[#simplification_variable_limit(i: $j$)])^2] + 2 sum_(0<=k<j<=N) bb(E)[(#simplification_variable_limit(i: $k$) - bb(E)[#simplification_variable_limit(i: $k$)]) (#simplification_variable_limit(i: $j$) - bb(E)[#simplification_variable_limit(i: $j$)])],\
        &= sum_(j=1)^N "Var"[#simplification_variable_limit(i: $j$)] + 2 sum_(0<=k<j<=N) "Cov"(#simplification_variable_limit(i: $k$), #simplification_variable_limit(i: $j$)). $

        Or, comme nous travaillons dans le cadre champ moyen, les neurones sont des copies indépendantes les uns des autres. Ainsi $"Cov"(#simplification_variable_limit(i: $k$), #simplification_variable_limit(i: $j$)) = 0$ et
        $ bb(E)[ abs(#martingale())^2] = sum_(j=1)^N "Var"[#simplification_variable_limit(i: $j$)] = N "Var"[#simplification_variable_limit(i: $j$)]. $

        Comme $#simplification_variable_limit(i: $j$) in {0, 1}$, alors $0 <= bb(E)[#simplification_variable_limit(i: $j$)] <= 1$, ce qui implique que :

        $ &"Var"[#simplification_variable_limit(i: $j$)] = bb(E)[#simplification_variable_limit(i: $j$)](1 - bb(E)[#simplification_variable_limit(i: $j$)]) <= 1/4,\
        &=> bb(E)[ abs(#martingale())^2] <= N/4,\
        &=> sqrt(bb(E)[ abs(#martingale())^2]) <= sqrt(N/4),\
        &"d'où" bb(E)abs(#martingale()) <= sqrt(N)/2. $
    ]
    On reprend @majoration_distance_potential_3, avec la @proposition_majoration_martingale, pour écrire :
    #numbered_equation(
        $ bb(E)[f|#no_spike_event] <= #distance_potential() + bb(E)abs(#simplification_variable() - #simplification_variable_limit()) + 1/(2 sqrt(N)). $,
        <majoration_distance_potential_4>
    )

    Pour conclure la majoration de $bb(E)[f|#no_spike_event]$, il reste uniquement à majorer le terme #esperance_distance_simplification_variables.

    #proposition()[
        $ #esperance_distance_simplification_variables <= #spiking_probability (#distance_activation() + #distance_potential()). $
    ] <proposition_majoration_esperance_distance_simplification_variables>
    #proof()[
        Commençons par réécrire #esperance_distance_simplification_variables :
        $ #esperance_distance_simplification_variables = bb(E)abs(#activation(i: $j$)#spiking_indicator(i: $j$) - #activation_limit(i: $j$)#spiking_indicator_limit(i: $j$)). $
        Dans ce cas également, il est possible d'utiliser les trois événements #simultaneous_spikes_event, #alone_spike_event et #no_spike_event mais cette fois appliqués au neurone $j$.\
        Écrivons grâce à ces événements :
        #let decomposition_esperance_evenements(valeur_esperance, events) = {
            let eq = $$
            let i = 0
            for e in events {
                // Don't add a plus if it's the last event
                if i != events.len() - 1 {
                    eq += $bb(P)(#e)bb(E)[#valeur_esperance|#e] +$
                } else {
                    eq += $bb(P)(#e)bb(E)[#valeur_esperance|#e]$
                }
                i += 1
            }
            return eq
        }
        #numbered_equation($ #esperance_distance_simplification_variables = #decomposition_esperance_evenements($abs(#simplification_variable(i: $j$) - #simplification_variable_limit(i: $j$))$, (simultaneous_spikes_event, alone_spike_event, no_spike_event)). $,
        <decomposition_esperance_distance_simplification_variables>
        )

        - Si l'événement #simultaneous_spikes_event est vérifié, alors les indicatrices de spike valent toutes les deux un ($#spiking_indicator(i: $j$) = #spiking_indicator_limit(i: $j$) = 1$), ce qui nous donne :
            $ bb(E)[#distance_simplification_variables|#simultaneous_spikes_event] = bb(E)abs(#activation(i: $j$) - #activation_limit(i: $j$)) = #distance_activation(i: $j$). $
        
        - Si l'événement #alone_spike_event est vérifié, alors une des indicatrices de spike vaut zéro et l'autre un. Il reste donc dans $bb(E)[#distance_simplification_variables|#alone_spike_event]$ :
            $ bb(E)[#distance_simplification_variables|#alone_spike_event] = cases(bb(E)abs(#activation(i: $j$)), bb(E)abs(#activation_limit(i: $j$))) <= 1 "dans tous les cas". $

        - Si l'événement #no_spike_event est vérifié, alors les indicatrices de spike valent toutes les deux zéro, aboutissant à :
            $ bb(E)[#distance_simplification_variables|#no_spike_event] = 0. $

        Reprenons à présent @decomposition_esperance_distance_simplification_variables :
        #numbered_equation(
            $ #esperance_distance_simplification_variables = bb(P)(#simultaneous_spikes_event)#distance_activation(i : $j$) + bb(P)(#alone_spike_event). $,
            <decomposition_esperance_distance_simplification_variables_2>
        )

        Pour borner $bb(P)(#simultaneous_spikes_event)$, repartons de sa définition @definition_simultaneous_spikes_event et utilisons le fait que la variable #auxiliary_uniform() est indépendante de toutes les autres variables aléatoires.\
        Ainsi,  
        $ bb(P)(#simultaneous_spikes_event) &= bb(P)(0 < #auxiliary_uniform(t: $t+1$) < #spiking_probability) bb(P)(#membrane_potential() = #membrane_potential_limit() = #max_potential),\
        &= #spiking_probability bb(P)(#membrane_potential() = #membrane_potential_limit() = #max_potential). $
        D'où,
        #numbered_equation($ bb(P)(#simultaneous_spikes_event) <= #spiking_probability. $, <majoration_probability_simultaneous_spikes_event>)

        En utilisant @majoration_probability_alone_spike_event_final pour majorer $bb(P)(#alone_spike_event)$, et @majoration_probability_simultaneous_spikes_event pour borner $bb(P)(#simultaneous_spikes_event)$, nous transformons @decomposition_esperance_distance_simplification_variables_2 en :
        #numbered_equation($ #esperance_distance_simplification_variables <= #spiking_probability (#distance_activation(i: $j$) + #distance_potential()), $, 
        <majoration_esperance_distance_simplification_variables>
        )
        ce qui conclut la preuve.
    ]

    Enfin, en reprenant @majoration_distance_potential_4 avec les éléments précédents et @proposition_majoration_esperance_distance_simplification_variables, nous avons :
    #numbered_equation(
        $ bb(E)[f|#no_spike_event] <= #distance_potential() + #spiking_probability (#distance_activation() + #distance_potential()) + 1/(2 sqrt(N)). $,
        <majoration_distance_potential_knowing_no_spike_event_final>
    )

    Ultimement, pour écrire la majoration définitive de #distance_potential(t: $t+1$), nous pouvons repartir de @majoration_distance_potential_2 et utiliser @majoration_distance_potential_knowing_no_spike_event_final pour écrire :
    $ #distance_potential(t: $t+1$) &<= #spiking_probability#max_potential#distance_potential() + (#distance_potential() + #spiking_probability (#distance_activation() + #distance_potential()) + 1 /(2 sqrt(N))), $
    #numbered_equation(
        $ #distance_potential(t: $t+1$) <= (#spiking_probability #max_potential + (1 + #spiking_probability))#distance_potential() + #spiking_probability #distance_activation() + 1/(2 sqrt(N)). $,
        <majoration_distance_potential_finale>
    )

    Nous pouvons écrire que
    #numbered_equation($ #distance_potential(t: $t+1$) <= c'#distance_globale() + 1/(2 sqrt(N)), $, <majoration_distance_globale_2>)
    où $c' = #spiking_probability #max_potential + 1 + #spiking_probability$.

    Si nous combinons la première pièce @majoration_distance_globale_1 avec la seconde pièce du puzzle @majoration_distance_globale_2, nous obtenons enfin,

    $ #distance_globale(t: $t+1$) &<= c'#distance_globale() + c#distance_globale() + 1/(2 sqrt(N)),\
    &<= C #distance_globale() + 1/(2 sqrt(N)), $
    avec $C$ la constante suivante : $C = max(c', c)$.

    Rappellons-nous que les processus sont initialisés de la même façon, ce qui signifique que $#distance_globale(t: $0$) = 0$.\
    Ainsi, en $t=1$ : 
    $ #distance_globale(t: $1$) <= 1/(2 sqrt(N)). $
    Poursuivant l'itération, nous avons :
    $ #distance_globale(t: $2$) &<= C #distance_globale(t: $1$) + 1/(2 sqrt(N)) = (C +1) 1/(2 sqrt(N)) "puis",\
    #distance_globale(t: $3$) &<= C #distance_globale(t: $2$) + 1/(2 sqrt(N)) <= C (C +1) 1/(2 sqrt(N)) + 1/(2 sqrt(N)) = (C^2 + C + 1) 1/(2 sqrt(N)).\ $

    Ce qui nous fait aboutir à :
    $ #distance_globale() <= (sum_(k=0)^(t-1)C^k) 1/(2 sqrt(N)). $

    Or puisque $C$ est une combinaison finie d'opérations sur des paramètres finis de notre modèle, et que nous nous sommes placés sur une fenêtre temporelle finie, soit $t in [0, T]$, pour tout $T in bb(N) "avec" T > 0$.\
    Ainsi un polynôme en $C$ de degré $t-1$ est nécessairement fini, c'est-à-dire $sum_(k=0)^(t-1)C^k < oo$, impliquant finalement que,
    $ #distance_globale() ->_(N -> oo) 0. $

    Ce qui parachève la preuve du @theoreme_convergence_processus ! #place(right, $square.stroked$)
]

== Mesure invariante
#include "invariant.typ"
