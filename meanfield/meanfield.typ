#import "../rules.typ": *
#import "../global_variables.typ": *
// Rule to avoid references error in sub-chapters when compiling local file
// #show: no-ref

// Display settings for theorems and proofs
#show: thmrules.with(qed-symbol: $square$)

// Variables for this section
#let membrane_potential(t: $t$, i: $i$) = $V_#t^(#i, N)$
#let activation(t: $t$, i: $i$) = $A_#t^(#i, N)$

#let distance_activation(t: $t$, i: $i$) = $delta_#t^(#i, N)$
#let distance_potential(t: $t$) = $d_#t^(i, N)$
#let distance_globale(t: $t$) = $D_#t^(i, N)$

#let network_contributions(t: $t$, i: $i$) = $#spiking_indicator(t: t, i: i)#activation(t: t, i: i)$
#let network_contributions_limit(t: $t$, i: $i$) = $#spiking_indicator_limit(i: i)#activation_limit(t: t, i: i)$
#let non_spiking_indicator_limit = $#indicator($#auxiliary_uniform(t: $t+1$) > #spiking_function(v: membrane_potential_limit())$)$

#let unknown_expectation(t: $t$) = $gamma_#t$
#let unknown_expectation_inf = $#unknown_expectation(t: $$)^*$
#let max_potential_limit = $K^#unknown_expectation(t: $$)$
#let max_potential_limit_val = $ceil(#max_potential/#unknown_expectation_inf)$


L'hypothèse de champ moyen que nous allons faire dans cette partie consiste à considérer un grand nombre de neurones $N$ et à les considérer comme étant tous *identiques*, c'est-à-dire indiscernables et avec les même valeurs pour conditions initiales :
$ forall (v, a) in {0, 1, dots, #max_potential} times {0, 1},\
X_0^N = vec((v, a), (v, a), dots.v, (v, a)). $

#set math.vec(delim: none)

Comme les neurones sont indiscernables, nous pouvons les compter simplement et au lieu d'écrire $sum_vec(j = 0, j != i)^N$, écrire directement $sum_(j = 1)^N$.

#let space_potentiel_mf = $attach(#space_potentiel, tr: N)$
Avec le modèle utilisé dans les parties précédentes, lorsque nous ferons tendre $N$ vers l'infini, la somme $sum_(j = 1)^N #activation()#spiking_indicator()$ explosera. Pour conserver l'intégrité du modèle, nous allons ajouter un facteur $1/N$ pour normaliser cette somme.\
Conséquemment à l'ajout de ce terme, l'espace de #membrane_potential() se voit altéré. De $#space_potentiel = #space_value_potential$, discret et incrémenté de 1, il deviendra incrémenté de $1/N$, soit $#space_potentiel_mf = {0, 1/N, 2/N, dots, 1, dots, theta}$. $N$ allant à l'infini, l'espace #space_potentiel_mf deviendra *continu*.

Ainsi l'équation de la dynamique du potentiel de membrane,
#potential_dynamics
s'écrit désormais 
$ #membrane_potential(t: $t+1$) = #non_spiking_indicator (#membrane_potential() + 1/N sum_(j=1)^N #network_contributions(i: $j$)) $


== Processus limites
Nous allons noter #membrane_potential_limit() et #activation_limit() les valeurs des *processus limites* de potentiel de membrane et d'activation pour le neurone $i$ au temps $t$. Remarquons de suite que les processus #membrane_potential() et #membrane_potential_limit() partagent tous les deux la même variable #auxiliary_uniform().

La dynamique du processus limite de l'activation de la synapse du neurone $i$ reste définie de façon similaire que la dynamique du processus fini :
$ #activation_limit(t: $t+1$) = #spiking_indicator_limit() + #non_spiking_indicator_limit #activation_limit() (1 - #deactivation_indicator). $ 

Cependant, la variable aléatoire #membrane_potential_limit() se voit modifiée plus profondément par l'hypothèse de champ moyen. En effet, le champ moyen suppose l'existence d'une certaine "loi des grands nombres" stipulant que
$ 1/N sum_(i=0)^N #network_contributions_limit() ->_(N -> oo) bb(E)[#network_contributions_limit()]. $

Ainsi la dynamique du processus limite du potentiel de membrane s'écrit :
$ #membrane_potential_limit(t: $t+1$) = #non_spiking_indicator_limit (#membrane_potential_limit() + expectation(#network_contributions_limit())). $

#let space_value_potential_limit = ${0, gamma, 2 gamma, dots, #max_potential_limit}$
La variable aléatoire #membrane_potential() avait été définie comme à valeurs dans $#space_value_potential subset bb(N)$. Or nous voyons désormais que #membrane_potential_limit() ne respecte plus cette définition, notamment car #expectation(network_contributions_limit()) est un *nombre réel* et dépendant du temps $t$.\
Supposons que
#numbered_equation($ #unknown_expectation() = #expectation(network_contributions_limit()). $, <definition_unknown_expectation>)
Intuitivement, cela signifie qu'à chaque pas de temps, le potentiel de membrane limite #membrane_potential_limit() augmente d'une quantité fixée #unknown_expectation(), inconnue et dépendante du temps.

Cependant, comme nous travaillons sur une fenêtre temporelle fixée #time_window, les valeurs de #unknown_expectation() sont fixées, et au nombre de $T+1$. Elles peuvent s'écrire, par exemple,
$ #unknown_expectation(t: $0$), #unknown_expectation(t: $1$), dots, #unknown_expectation(t: $T$). $

#let time_inf = $t^*$
Parmi ces $T+1$ valeurs, notons #unknown_expectation_inf la plus petite :
$ #unknown_expectation_inf = inf{#unknown_expectation(), forall t in #time_window}, $
et #time_inf le temps où $#unknown_expectation() = #unknown_expectation_inf.$


Ceci permet de fixer les valeurs prises par la variable aléatoire #membrane_potential_limit() sur la fenêtre temporelle #time_window. Notons d'ailleurs #space_potentiel_limite(), l'espace de ces valeurs.

Le potentiel limite #membrane_potential_limit() se comporte de la même façon que le potentiel fini. Comme lui, il sera en capacité d'émettre un potentiel d'action après avoir dépassé le potentiel seuil $#max_potential$.\
Notons #max_potential_limit, la valeur maximale, qui dépendra des #unknown_expectation(), que peut prendre le potentiel de membrane limite. #max_potential_limit correspond au nombre minimal de pas nécessaires à #membrane_potential_limit() pour dépasser #max_potential. #max_potential_limit est donc un *entier positif*, défini de la façon suivante : 
$ #max_potential_limit = #max_potential_limit_val. $

/*
Nous pouvons même calculer la valeur de #unknown_expectation() :
$ #unknown_expectation() &= bb(E)[#activation_limit()#spiking_indicator_limit()],\
&= bb(P)(#auxiliary_uniform(t: $t+1$) > #spiking_function(v: membrane_potential_limit())) bb(E)[#activation_limit()|#auxiliary_uniform(t: $t+1$) > #spiking_function(v: membrane_potential_limit())],\
&= #spiking_function(v: membrane_potential_limit()) bb(E)[#activation_limit()]. $

Ce qui nous permet d'écrire la majoration suivante :
#numbered_equation($ #unknown_expectation() <= #spiking_probability. $, <majoration_gamma_t>)

Comme nous sommes placés sur une fenêtre temporelle de taille $T$, nous sommes donc en capactié de minorer la valeur de #unknown_expectation().\
Soit $t^*$ le temps critique où $#unknown_expectation() = 0$, c'est à dire le temps où la chaîne #chain() est absorbée. En effet, $#unknown_expectation() = 0$ implique que tous les neurones du processus limite soient désactivés ou qu'ils soient tous dans une couche inférieure à $K #unknown_expectation()$.\
Ainsi, 
$ t^* = inf{t > 0 : #unknown_expectation() = 0}. $

Comme nous travaillons en temps discret, cela nous permet de maintenir la valeur de $gamma_t$ supérieure à un certain seuil $epsilon > 0$ pour tout $t < t^*$.\
D'après @majoration_gamma_t, nous avons donc pour toute valeur de $t < t^*$,
#numbered_equation($ epsilon <= gamma_t <= #spiking_probability. $, <encadrement_gamma_t>)
*/


== Existence des processus limites
Comme les deux processus limites #neuron_limit() prennent leurs valeurs dans des espaces discrets et finis, ils sont tous les deux bien définis. L'existence des processus ne pose ainsi aucun problème, et nous pouvons écrire le théorème suivant :

#theorem("Existence des processus limites")[
    Pour tout $t in #time_window$, il existe un unique processus #neuron_limit() avec un #unknown_expectation() associé.
]<theorem_existence_processus_limite>

#theorem([Propagation du chaos avec $phi$ modifiée])[
    Étant donné l'existence du processus limite donné dans le @theorem_existence_processus_limite et son #unknown_expectation() associé, et une nouvelle fonction $phi^*$, prise lipschitz, et approchant $phi$, nous avons
    $ #expectation_absolute($#membrane_potential() - #membrane_potential_limit()$) + #expectation_absolute($#activation() - #activation_limit()$) <= C_T (epsilon) / sqrt(N). $
    $C_T$ est ici une constante qui fait intervenir les #unknown_expectation() et donc qui dépend de la fenêtre temporelle #time_window.
]<theorem_propagation_chaos>

#corrolary("Convergence des processus finis vers les processus limites")[
    $ lim_(N -> oo) #expectation_absolute($#membrane_potential() - #membrane_potential_limit()$) + #expectation_absolute($#activation() - #activation_limit()$) = 0, $
    ce qui revient à dire que, pour tout $i in #indexes_interval$, et pour un $t in #time_interval$, avec $T$ nombre entier positif :
    $ (#membrane_potential(), #activation()) ->_(N -> oo) (#membrane_potential_limit(), #activation_limit()). $
]<theoreme_convergence_processus>

#todo("À développer et à terminer")


== Convergence vers les processus limites
#todo("À mettre à jour puisque la preuve s'est effondrée")
Nous allons démontrer que les processus finis convergent vers les processus limites. Les processus de voltage et d'activation doivent tous deux converger vers leurs processus limites respectifs.\
Ainsi, si nous définissons la *distance entre les processus de potentiel de membrane* 
$ #distance_potential() = bb(E)abs(#membrane_potential() - #membrane_potential_limit()), $ ainsi que *distance entre les processus d'activation* 
$ #distance_activation() = bb(E)abs(#activation() - #activation_limit()), $ nous pouvons écrire la *distance globale* entre le processus de neurone et sa limite comme 
#numbered_equation($ #distance_globale() = #distance_potential() + #distance_activation(). $, <distance_globale>)

Étant donné @theorem_propagation_chaos, 

#theorem("Convergence des processus finis vers les processsus limites")[
    Pour tout $i in #indexes_interval$, et pour un $t in #time_interval$, avec $T$ nombre entier positif,
    $ (#membrane_potential(), #activation()) ->_(N -> oo) (#membrane_potential_limit(), #activation_limit()), $
    ce qui revient à dire que :
    $ lim #distance_globale() ->_(N -> oo) 0. $
]

#proof()[
    Pour prouver le @theoreme_convergence_processus, nous allons  consiste à trouver une majoration de #distance_globale(t: $t+1$) par une fonction de $N$ qui puisse disparaître lorsque $N -> oo$.\

    La trame de la preuve est la suivante :
    + Trouver des majorations de #distance_activation(t: $t+1$) et #distance_potential(t: $t+1$) qui utilisent #distance_globale().
    + Utiliser ces majorations pour trouver une majoration de #distance_globale(t: $t+1$) en fonction de #distance_globale() et d'une fonction de $N$ qui pourra disparaître lorsque $N$ deviendra grand.
    + Montrer par récurrence que #distance_globale(t: $t+1$) est bornée par une fonction de $N$ qui tend vers zéro lorsque $N$ tend vers l'infini.

    === Majoration de #distance_activation(t: $t+1$)
    #todo("Afficher correctement l'équation")
    Commençons par majorer #distance_activation(t: $t+1$). De la définition, il vient :
    $ #distance_activation(t: $t+1$) &= bb(E)abs(#activation(t: $t+1$) - #activation_limit(t: $t+1$)),\
    &= bb(E)abs(#spiking_indicator() - #spiking_indicator_limit()\
    &+ #activation()#non_spiking_indicator (1 - #deactivation_indicator) - #activation_limit()#non_spiking_indicator_limit (1 - #deactivation_indicator)),\
    &= expectation(e) "pour simplifier l'écriture pour la suite." $
    
    #let simultaneous_spikes_event = $bold(2)$
    #let alone_spike_event = $bold(1)$
    #let alone_spike_event_def = ${#membrane_potential() < #max_potential xor #membrane_potential_limit() < #max_potential}$
    #let no_spike_event = $bold(0)$
    Remarquons que les trois événements suivants sont disjoints :
    - L'événement $#simultaneous_spikes_event = {"processus fini et limite spikent simultanément en" t+1}$ peut s'écrire formellement :
        #numbered_equation($ #simultaneous_spikes_event = {0 < #auxiliary_uniform(t: $t+1$) < #spiking_probability} inter {#membrane_potential() = #membrane_potential_limit() = #max_potential}. $, <definition_simultaneous_spikes_event>)

    - L'évévement $#alone_spike_event = {"processus fini ou (exclusif) limite spike en" t+1} = {0 < #auxiliary_uniform(t: $t+1$) < #spiking_probability} inter #alone_spike_event_def.$

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

    #let probability_spike_alone_event = $bb(P)(#alone_spike_event_def)$
    En reprenant @majoration_distance_activation, nous aboutissons à :
    #numbered_equation(
        $ #distance_activation(t : $t+1$) <= bb(P)(#alone_spike_event) + bb(P)(#no_spike_event)(1 + #deactivation_probability)#distance_activation(). $, <majoration_distance_activation_2>
    )

    #todo("Adapter la preuve en supposant phi lipschitz")

    La probabilité $bb(P)(#alone_spike_event)$ peut s'écrire :
    #numbered_equation($ bb(P)(#alone_spike_event) = bb(P)({0 < #auxiliary_uniform(t: $t+1$) < #spiking_probability} inter #alone_spike_event_def) = #spiking_probability #probability_spike_alone_event. $,
    <majoration_probability_alone_spike_event>
    )

    Remarquons la proposition suivante, qui nous permet d'introduire #distance_potential() dans la majoration de $bb(P)(#alone_spike_event)$.

    #let min_distance_processes = $$
    #proposition()[
        $ #probability_spike_alone_event <= C^N #distance_potential(). $
        où $C^N = 1 / (min(1/N, abs(#max_potential - sum_(t=L)^(L + K + 1/#spiking_probability) gamma_t)))$
    ] <proposition_majoration_probability_different_voltage>
    #proof[
        Commençons par réécrire #probability_spike_alone_event :
        $ #probability_spike_alone_event = bb(E)[bold(1)_(#alone_spike_event_def)]. $
        Remarquons ensuite que l'événement $#alone_spike_event_def$ implique que les potentiels de membrane des processus fini et limite sont différents, c'est-à-dire que $#membrane_potential() ≠ #membrane_potential_limit()$.\
        Par construction, #membrane_potential() et #membrane_potential_limit() ne peuvent prendre que des valeurs discrètes comprises entre zéro et #max_potential. Il en découle que la distance entre les deux potentiels de membrane est nécessairement supérieure ou égale à 1, soit $abs(#membrane_potential() - #membrane_potential_limit()) >= 1$.\
        Ainsi, nous avons :
        $ abs(#membrane_potential() - #membrane_potential_limit()) >= bold(1)_(#alone_spike_event_def),\
        "et donc" bb(E)[bold(1)_(#alone_spike_event_def)] <= bb(E)abs(#membrane_potential() - #membrane_potential_limit()) = #distance_potential(). $
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
    &= bb(E)underbrace(abs(#non_spiking_indicator (#membrane_potential() + 1/N sum_(j=1)^N #network_contributions(i: $j$)) - #non_spiking_indicator_limit (#membrane_potential_limit() + bb(E)[#network_contributions_limit()])), "= f pour simplifier l'écriture par la suite"). $

    Nous pouvons ici aussi utiliser les trois événements disjoints #simultaneous_spikes_event, #alone_spike_event et #no_spike_event définis précédemment pour écrire :
    #numbered_equation(
        $ #distance_potential(t: $t+1$) = bb(P)(#simultaneous_spikes_event)bb(E)[f|#simultaneous_spikes_event] + bb(P)(#alone_spike_event)bb(E)[f|#alone_spike_event] + bb(P)(#no_spike_event)bb(E)[f|#no_spike_event]. $,
        <majoration_distance_potential_1>
    )


    - Si l'événement #simultaneous_spikes_event est vérifié, alors les indicatrices d'absence de spike sont nulles, c'est-à-dire $#non_spiking_indicator = #non_spiking_indicator_limit = 0$), ce qui nous donne :
        $ bb(E)[f|#simultaneous_spikes_event] = 0. $

    - Si l'événement #alone_spike_event est vérifié, alors seule une des indicatrices d'absence de spike est nulle, soit $#non_spiking_indicator = 0$ ou $#non_spiking_indicator_limit = 0$.\
        Il reste donc dans $bb(E)[f|#alone_spike_event]$ :
        $ bb(E)[f|#alone_spike_event] = cases(bb(E)abs(#membrane_potential() + 1/N sum_(j=1)^N #network_contributions(i: $j$)) "si le processus limite spike", bb(E)abs(#membrane_potential_limit() + bb(E)[#network_contributions_limit()]) "si le processus fini spike"). $
        Dans tous les cas, nous pouvons majorer par #max_potential car #membrane_potential() est borné par #max_potential.\
        *TO-DO Véridique ?*
        $ bb(E)[f|#alone_spike_event] <= #max_potential "par construction". $        

    - Si l'événement #no_spike_event est vérifié, alors les indicatrices d'absence de spike valent toutes deux un, c'est-à-dire $#non_spiking_indicator = #non_spiking_indicator_limit = 1$. Cela nous permet d'écrire :
        $ bb(E)[f|#no_spike_event] = bb(E)abs(#membrane_potential() + 1/N sum_(j=1)^N #network_contributions(i: $j$) - (#membrane_potential_limit() + bb(E)[#network_contributions_limit()])). $
        Cette quantité sera majorée plus loin, car son développement est un peu plus long.

    En reprenant @majoration_distance_potential_1, et en utilisant @majoration_probability_alone_spike_event_final et $bb(P)(#no_spike_event) <= 1$, nous obtenons :
    #numbered_equation(
        $ #distance_potential(t: $t+1$) <= #spiking_probability #max_potential #distance_potential() + bb(E)[f|#no_spike_event]. $,
        <majoration_distance_potential_2>
    )

    Maintenant, nous allons développer $bb(E)[f|#no_spike_event]$. Ajoutons et retirons $1/N sum_(j=1)^N #network_contributions_limit(i: $j$)$ :
    $ bb(E)[f|#no_spike_event] &= bb(E)abs(#membrane_potential() + 1/N sum_(j=1)^N #network_contributions(i: $j$) - (#membrane_potential_limit() + bb(E)[#network_contributions_limit()]) + 1/N sum_(j=1)^N #network_contributions_limit(i: $j$) - 1/N sum_(j=1)^N #network_contributions_limit(i: $j$) ), $

    #let martingale(i: $i$) = $overline(M)_(t)^#i$
    Posons 
    $ #martingale() = sum_(i=1)^N (#network_contributions_limit(i: $j$) - bb(E)[#network_contributions_limit(i: $j$)]), $
    nous avons alors,

    #let distance_simplification_variables = $abs(#network_contributions(i: $j$) - #network_contributions_limit(i: $j$))$
    #let esperance_distance_simplification_variables = $bb(E)#distance_simplification_variables$
    #numbered_equation(
        $ bb(E)[f|#no_spike_event] &= bb(E)abs(#membrane_potential() - #membrane_potential_limit() + 1/N sum_(j=1)^N #network_contributions(i: $j$) - 1/N sum_(j=1)^N #network_contributions_limit(i: $j$) + 1/N #martingale()),\
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

        $  bb(E)[ abs(#martingale())^2] &= bb(E)[(sum_(j=1)^N #network_contributions_limit(i: $j$) - bb(E)[#network_contributions_limit(i: $j$)])^2],\
        &= bb(E)[sum_(j=1)^N (#network_contributions_limit(i: $j$) - bb(E)[#network_contributions_limit(i: $j$)])^2 + 2 sum_(0<=k<j<=N) (#network_contributions_limit(i: $k$) - bb(E)[#network_contributions_limit(i: $k$)]) (#network_contributions_limit(i: $j$) - bb(E)[#network_contributions_limit(i: $j$)])],\
        &= sum_(j=1)^N bb(E)[(#network_contributions_limit(i: $j$) - bb(E)[#network_contributions_limit(i: $j$)])^2] + 2 sum_(0<=k<j<=N) bb(E)[(#network_contributions_limit(i: $k$) - bb(E)[#network_contributions_limit(i: $k$)]) (#network_contributions_limit(i: $j$) - bb(E)[#network_contributions_limit(i: $j$)])],\
        &= sum_(j=1)^N "Var"[#network_contributions_limit(i: $j$)] + 2 sum_(0<=k<j<=N) "Cov"(#network_contributions_limit(i: $k$), #network_contributions_limit(i: $j$)). $

        Or, comme nous travaillons dans le cadre champ moyen, les neurones sont des copies indépendantes les uns des autres. Ainsi $"Cov"(#network_contributions_limit(i: $k$), #network_contributions_limit(i: $j$)) = 0$ et
        $ bb(E)[ abs(#martingale())^2] = sum_(j=1)^N "Var"[#network_contributions_limit(i: $j$)] = N "Var"[#network_contributions_limit(i: $j$)]. $

        Comme $#network_contributions_limit(i: $j$) in {0, 1}$, alors $0 <= bb(E)[#network_contributions_limit(i: $j$)] <= 1$, ce qui implique que :

        $ &"Var"[#network_contributions_limit(i: $j$)] = bb(E)[#network_contributions_limit(i: $j$)](1 - bb(E)[#network_contributions_limit(i: $j$)]) <= 1/4,\
        &=> bb(E)[ abs(#martingale())^2] <= N/4,\
        &=> sqrt(bb(E)[ abs(#martingale())^2]) <= sqrt(N/4),\
        &"d'où" bb(E)abs(#martingale()) <= sqrt(N)/2. $
    ]
    On reprend @majoration_distance_potential_3, avec la @proposition_majoration_martingale, pour écrire :
    #numbered_equation(
        $ bb(E)[f|#no_spike_event] <= #distance_potential() + bb(E)abs(#network_contributions() - #network_contributions_limit()) + 1/(2 sqrt(N)). $,
        <majoration_distance_potential_4>
    )

    Pour conclure la majoration de $bb(E)[f|#no_spike_event]$, il reste uniquement à majorer le terme #esperance_distance_simplification_variables.

    #proposition()[
        $ #esperance_distance_simplification_variables <= #spiking_probability (#distance_activation() + #distance_potential()). $
    ] <proposition_majoration_esperance_distance_simplification_variables>
    #proof()[
        Commençons par réécrire #esperance_distance_simplification_variables en utilisant les trois événements #simultaneous_spikes_event, #alone_spike_event et #no_spike_event mais cette fois appliqués au neurone $j$.\
        Pour alléger l'écriture, notons également $g = abs(#activation(i: $j$)#spiking_indicator(i: $j$) - #activation_limit(i: $j$)#spiking_indicator_limit(i: $j$))$
    
        Écrivons grâce à ces événements :
        #numbered_equation($ #proba(simultaneous_spikes_event)#expectation_conditional($g$, simultaneous_spikes_event) + #proba(alone_spike_event)#expectation_conditional($g$, alone_spike_event) + #proba(no_spike_event)#expectation_conditional($g$, no_spike_event) $,
        <decomposition_esperance_distance_simplification_variables>
        )

        - Si l'événement #simultaneous_spikes_event est vérifié, alors les indicatrices de spike valent toutes les deux un ($#spiking_indicator(i: $j$) = #spiking_indicator_limit(i: $j$) = 1$), ce qui nous donne :
            $ #expectation_conditional($g$, simultaneous_spikes_event) = #expectation_absolute($#activation(i: $j$) - #activation_limit(i: $j$)$) = #distance_activation(i: $j$). $
        
        - Si l'événement #alone_spike_event est vérifié, alors une des indicatrices de spike vaut zéro et l'autre un. Il reste donc dans #expectation_conditional($g$, alone_spike_event) :
            $ #expectation_conditional($g$, alone_spike_event) = cases(#expectation_absolute(activation(i: $j$)), #expectation_absolute(activation_limit(i: $j$))) <= 1 "dans tous les cas". $

        - Si l'événement #no_spike_event est vérifié, alors les indicatrices de spike valent toutes les deux zéro, aboutissant à :
            $ #expectation_conditional($g$, no_spike_event) = 0. $

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
#let regenering_state = $(0, 1)$
#let time_before_regen = $T_#regenering_state$

#let indicator_chain(state: $(v, 1)$) = $bold(1)_{X_k= #state}$
#let time_spent_in_state(state: $(v, 1)$) = $sum_(t=1)^(#time_before_regen) #indicator_chain(state: state)$
#let mean_time_spent_in_state(state: $(v, 1)$) = $bb(E)[#time_spent_in_state(state: state)]$

#let mean_time_before_regen = $bb(E)_(#regenering_state)[T_(#regenering_state)]$
#let value_mean_time_before_regen = $#max_potential_limit + 1/#spiking_probability$

#let mesure_stationnaire(state: $(v, a)$) = $pi^#max_potential_limit (#state)$

L'objectif de cette section est de calculer la mesure invariante, ou stationnaire, associée à la chaîne de Markov limite $#chain_limit() = #neuron_limit()$ étudiée dans la partie précédente.

Pour la chaîne de Markov $#chain() = #neuron()$, l'état #regenering_state est un *état de régénération*, pour lequel la chaîne perd tout lien avec le passé.

Introduisons maintenant $#time_before_regen$, le temps, *aléatoire*, que met #chain() pour arriver à l'état #regenering_state en partant de celui-ci. Formellement :
$ #time_before_regen = inf{t > 0 : #chain() = #regenering_state "sachant que" #chain(t: $0$) = #regenering_state}. $

Pour calculer #mean_time_before_regen, il suffit de remarquer que la chaîne #chain(), pour retourner en #regenering_state en partant de #regenering_state va nécessairement d'abord effectuer #max_potential_limit sauts successifs, de taille #unknown_expectation_inf chacun. Ensuite, elle devra attendre un temps aléatoire avant d'émettre un potentiel d'action. Ce temps aléatoire suit une loi géométrique de paramètre #spiking_probability.\
Alors,
#numbered_equation($ #mean_time_before_regen = #value_mean_time_before_regen. $ , <valeur_temps_avant_regen>)

// Pour plus de clarté, notons à partir de maintenant $#max_potential_limit = K$.
// #let max_potential_limit = $K$

Cela nous permet de définir la *mesure stationnaire* de notre processus limite de la façon suivante. Prenons $v in #space_value_potential$ et $a in #space_value_activation$ :
#numbered_equation(
  $ #mesure_stationnaire() = 1 / #mean_time_before_regen #mean_time_spent_in_state(state: $(v, a)$). $, <definition_mesure_stationnaire>
)
#todo("Justifier définition mesure stationnaire")

La variable aléatoire #time_spent_in_state() représente le *temps passsé* dans l'état $(v, 1)$ par la chaîne.\

Son calcul, et celui de #mean_time_spent_in_state() va dépendre des valeurs prises par $v$.

=== Cas où $v < #max_potential_limit #unknown_expectation_inf$
#let probability_no_deactivation_before_v = $(1 - #deactivation_probability)^v$
Dans le cas présent, #time_spent_in_state() vaut exactement un si le neurone ne subit aucune désactivation avant la couche $v$, ce qui arrive avec probabilité #probability_no_deactivation_before_v. S'il se désactive avant $v$, alors #time_spent_in_state() est nulle.\
Ainsi, pour $v < #max_potential_limit #unknown_expectation_inf$,
#numbered_equation($ #mean_time_spent_in_state() = #probability_no_deactivation_before_v. $, <valeur_temps_moyen_passe_etat_v_1>)

#let probability_deactivation_before_v = $1 - #probability_no_deactivation_before_v$
De façon similaire, pour $a = 0$, #time_spent_in_state(state: $(v, 0)$) vaut un si le neurone subit une désactivation avant la couche $v$, ce qui arrive avec probabilité #probability_deactivation_before_v. Sinon, le temps passé dans l'état $(v, 0)$ est nul. D'où,
#numbered_equation($ #mean_time_spent_in_state(state: $(v, 0)$) = #probability_deactivation_before_v. $, <valeur_temps_moyen_passe_etat_v_0>)

Finalelement, nous avons
$ forall v < K gamma,space  #mesure_stationnaire(state: $(v, 1)$) = #probability_no_deactivation_before_v / #value_mean_time_before_regen, $
ainsi que
$ #mesure_stationnaire(state: $(v, 0)$) = #probability_deactivation_before_v / (#value_mean_time_before_regen). $

=== Cas où $v = #max_potential_limit #unknown_expectation_inf$
#let time_before_spike = $T_#spiking_probability$
#let time_before_deactivation = $T_#deactivation_probability$
Ici, le neurone peut, avec probabilité positive, passer un temps plus long qu'un pas de temps dans l'état $(#max_potential_limit, 1)$. Le neurone quittera l'état $(#max_potential_limit, 1)$ lors de l'émission d'un spike, ou après une désactivation.\
Si nous notons #time_before_spike le temps aléatoire avant l'émission d'un spike et #time_before_deactivation, le temps aléatoire avant la désactivation du neurone, nous pouvons alors écrire que :
$ #mean_time_spent_in_state(state: $(#max_potential_limit, 1)$) &= bb(E)[min(#time_before_spike, #time_before_deactivation)]. $

Comme #time_before_spike suit une loi géométrique de paramètre #spiking_probability et #time_before_deactivation suit une loi géométrique de paramètre #deactivation_probability, nous avons :
#numbered_equation($ #mean_time_spent_in_state(state: $(#max_potential_limit, 1)$) = 1 / (#spiking_probability + #deactivation_probability). $, <valeur_temps_moyen_passe_etat_K_1>)

Avec @valeur_temps_avant_regen et @valeur_temps_moyen_passe_etat_K_1, nous aboutissons donc à la mesure stationnaire suivante pour l'état $(#max_potential_limit, 1)$ :
#let mesure_stat_valeur_K_1 = $1 / ((#value_mean_time_before_regen)(#spiking_probability + #deactivation_probability))$ 
#numbered_equation($ #mesure_stationnaire(state: $(#max_potential_limit, 1)$) = #mesure_stat_valeur_K_1. $, <mesure_stationnaire_K_1>)


Enfin, pour l'état $(K gamma, 0)$, étant donné que $pi$ est une mesure de probabilité, nous pouvons écrire :
$ #mesure_stationnaire(state: $(K gamma, 0)$) = 1 - (sum_(a=0)^1 sum_(v=0)^((K-1) gamma) #mesure_stationnaire() + #mesure_stationnaire(state: $(#max_potential_limit, 1)$). $

=== Équilibres de la mesure stationnaire
Trouver les équilibres de la mesure stationnaire revient à (...)
#todo("Justifier l'étude des équilibres avec la mémoire")

#let unknown = $gamma$
Nous cherchons donc les points tel que
$ #mesure_stationnaire() = #unknown. $


Développons en se rappellant de @definition_unknown_expectation :
$ #unknown = #expectation(network_contributions_limit(t: time_inf)) &= #expectation($#spiking_function(v: membrane_potential_limit(t: time_inf)) #activation_limit(t: time_inf)$),\
&= sum_(a=0)^1 sum_(k = 0)^#max_potential_limit #spiking_function(v: $k #unknown$) dot a dot #mesure_stationnaire(state: $(k #unknown, a)$). $
Or, comme #spiking_function(v: $v$) est nulle tant que $v < #max_potential$, tous les termes, sauf celui où $k = #max_potential_limit$ vont s'annuler, laissant ainsi :
$ #unknown = #spiking_function(v: $#max_potential_limit #unknown$) #mesure_stationnaire(state: $(#max_potential_limit #unknown, 1)$), $
soit, avec @mesure_stationnaire_K_1 :
$ #unknown = #spiking_probability #mesure_stat_valeur_K_1. $

#let fonction_sauts = $ceil(#max_potential / #unknown)$
#let point_eq = $#spiking_probability / ((#fonction_sauts + 1/#spiking_probability)(#spiking_probability + #deactivation_probability))$
Ainsi trouver les points d'équilibre de la mesure stationnaire revient à résoudre l'équation suivante :
#numbered_equation($ f(#unknown) = #unknown - #point_eq = 0. $, <equation_equilibre>)

À cause de la fonction partie entière, cette équation n'est pas triviale à résoudre.\
Premièrement, pour $#unknown -> 0$, l'@equation_equilibre admet une solution, triviale, correspondant à l'absorption du système en zéro.

Cependant, nous sommes à la recherche d'équilibres non nuls, qui pourraient correspondre à (...).
#todo([Interpréter solution des équilibres])

Grâce à @allure_f_gamma, et à @equation_equilibre, nous pouvons voir que $f$ est une fonction *croissante* et *continue par morceau*. Pour annuler $f$, nous allons chercher des valeurs de #unknown, où $f < 0$. Puis, #unknown augmentant, la croissance linéaire de $f$ la fera nécessairement croise l'axe des abscisses.

#figure(image("../figures/allure_f_gamma.png"), caption: [Représentation de $f$ pour #unknown compris entre $0$ et $1$, avec $#max_potential = 3$, $#spiking_probability = 0.9$ et $#deactivation_probability = 0.09$.])<allure_f_gamma>

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
    concluant la preuve. Le tout est illustré 
]

#remark([$f$ peut admettre d'autres équilibres grâce aux sauts de $#fonction_sauts$])[
    Si jamais $#max_potential > #point_eq_1$, un ou plusieurs équilibres peuvent tout de même exister, grâce aux sauts de la fonction $#fonction_sauts$. Ceci est illustré grâce à la @f_gamma_plsrs_equilibres.
]

#let beta = 0.9
#let lambda = 0.09
#let theta = 1
#let point_eq_1_valeur = beta / ((1 + 1/beta) * (beta + lambda))
#figure(image("../figures/f_gamma_one_equilibre.png"), caption: [Représentation de $f$ pour #unknown compris entre $0$ et $1$. Ici $#max_potential = 0.2$, $#spiking_probability = 0.9$ et $#deactivation_probability = 0.09$. Pour cette combinaison de paramètres, le point d'équilibre est $#unknown = #point_eq_1 = #point_eq_1_valeur$. Nous avons donc bien $#max_potential < #point_eq_1$. et $f$ coupe proprement l'axe des abscisses en #point_eq_1.])<f_gamma_un_equilibre>


#figure(image("../figures/f_gamma_many_equilibres.png"), caption: [Illustration de la présence de plusieurs équilibres. Ici $#max_potential = 0.5$, $#spiking_probability = 0.9$ et $#deactivation_probability = 0.09$, donnant $#max_potential > #point_eq_1$. Pourtant, $f(#unknown)$ s'annule deux fois dans l'intervalle $(0, #max_potential]$.])<f_gamma_plsrs_equilibres>


