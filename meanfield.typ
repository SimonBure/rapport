#import "rules.typ": *
#import "global_variables.typ": *

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

Nous allons supposer l'existence d'une "loi des grands nombres" permettant d'affirmer que
$ 1/N sum_(i=0)^N #simplification_variable_limit() ->_(N -> oo) bb(E)[#simplification_variable_limit()]. $

À la lueur de ces hypothèses et de ces définitions, écrivons désormais les équations régissant les dynamiques de ces deux processus limites en spécifiant que les processus classiques et limites *partagent la même variable auxiliaire uniforme* #auxiliary_uniform().\
Pour le processus limite du potentiel de membrane nous avons
$ #potential_limit_dynamics, $
et pour le processus limite de la variable d'activation
$ #activation_limit(t: $t+1$) = #spiking_indicator_limit() + #non_spiking_indicator_limit #activation_limit() (1 - #deactivation_indicator). $


== Existence des processus limites


== Convergence vers les processus limites
Nous allons démontrer que les processus classiques convergent vers les processus limites. Les processus de voltage et d'activation doivent tous deux converger vers leurs processus limites respectifs.\
Ainsi, si nous définissons la *distance entre les processus de potentiel de membrane* 
$ #distance_potential() = bb(E)abs(#membrane_potential() - #membrane_potential_limit()), $ ainsi que *distance entre les processus d'activation* 
$ #distance_activation() = bb(E)abs(#activation() - #activation_limit()), $ nous pouvons écrire la *distance globale* entre le processus de neurone et sa limite comme 
#numbered_equation($ #distance_globale() = #distance_potential() + #distance_activation(). $, <distance_globale>)

#theorem("Convergence des processus classiques vers les processsus limites")[
    Pour tout $i in {1, dots, N}$, et pour un $t in bb(N)$,
    $ (#membrane_potential(), #activation()) ->_(N -> oo) (#membrane_potential_limit(), #activation_limit()), $
    ce qui revient à dire que :
    $ lim #distance_globale() ->_(N -> oo) 0. $
] <theoreme_convergence_processus>

*TO-DO Condition sur t ?*

/*#theorem("La suite des distances globales est une contraction")[
    Pour tout $i in {1, dots, N}$, et $forall kappa < 1$, la suite des distances #distance_globale(t: $0$), #distance_globale(t: $1$), $dots,$ #distance_globale(), #distance_globale(t: $t+1$) est une *contraction* :
    $ #distance_globale(t: $t+1$) <= kappa . $
] <theoreme_convergence_distance_globale>*/

#proof()[
    Pour prouver le @theoreme_convergence_processus, nous allons  consiste à trouver une majoration de #distance_globale(t: $t+1$) par une fonction de $N$ qui puisse disparaître lorsque $N -> oo$.\

    La trame de la preuve est la suivante :
    + Trouver des majorations de #distance_activation(t: $t+1$) et #distance_potential(t: $t+1$) qui utilisent #distance_globale().
    + Utiliser ces majorations pour trouver une majoration de #distance_globale(t: $t+1$) en fonction de #distance_globale() et d'une fonction de $N$ qui pourra disparaître lorsque $N$ deviendra grand.
    + Montrer par récurrence que #distance_globale(t: $t+1$) est bornée par une fonction de $N$ qui tend vers zéro lorsque $N$ tend vers l'infini.
    
    *TO-DO Pas besoin de l'argument de contraction ?*
    /*
    L'idée de cette preuve est de montrer que la suite des distances #distance_globale(t: $0$), #distance_globale(t: $1$), $dots,$ #distance_globale(), #distance_globale(t: $t+1$) subit une contraction, soit
    $ forall kappa < 1, space #distance_globale(t: $t+1$) <= kappa #distance_globale(). $
    Nous pourrons ensuite utiliser l'hypothèse que tous les neurones commencent avec les même conditions initiales pour dire que $#distance_globale(t: $0$) = 0$ et puis finalement utiliser un argument de récurrence pour conclure la preuve.
    
    L'objectif est donc de trouver une majoration de #distance_globale(t: $t+1$) par #distance_globale()\
    Cela passe évidemment par trouver des */

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

    Concernant $bb(P)(#no_spike_event)$, nous pouvons écrire :
    $ bb(P)(#no_spike_event) &= bb(P)({#auxiliary_uniform(t: $t+1$) > #spiking_probability} union {#membrane_potential() < #max_potential "et" #membrane_potential_limit() < #max_potential}),\
    &= bb(P)(#auxiliary_uniform(t: $t+1$) > #spiking_probability) + bb(P)(#membrane_potential() < #max_potential "et" #membrane_potential_limit() < #max_potential) - bb(P)({#auxiliary_uniform(t: $t+1$) > #spiking_probability} inter {#membrane_potential() < #max_potential "et" #membrane_potential_limit() < #max_potential}),\
    &= 1 - #spiking_probability + #spiking_probability bb(P)(#membrane_potential() < #max_potential "et" #membrane_potential_limit() < #max_potential). $
    Par construction, nous avons nécessairement $bb(P)(#membrane_potential() < #max_potential "et" #membrane_potential_limit() < #max_potential) < 1$ car le neurone $i$ se trouve nécessairement, pour certains temps $t$, dans la couche #max_potential.\
    Ainsi,
    #numbered_equation($ bb(P)(#no_spike_event) = c < 1. $, <majoration_probability_no_spike_event>)

    *TO-DO Est-ce que cet argument est vrai ? Est-ce que l'on peut être plus rigoureux dans son utilisation ?*
    

    Reprenant @majoration_distance_activation_3 et @majoration_probability_no_spike_event, nous arrivons enfin à :
    $ #distance_activation(t: $t+1$) <= #spiking_probability #distance_potential() + c (1 + #deactivation_probability)#distance_activation(). $

    Si nous faisons l'hypothèse que $c (1 + #deactivation_probability) < 1$, alors nous pouvons dire que 
    $ #distance_activation(t: $t+1$) &<= max(#spiking_probability, c (1 + #deactivation_probability)) (#distance_potential() + #distance_activation()),\
    &<= c' #distance_globale(), "où" c' = max(#spiking_probability, c (1 + #deactivation_probability)) < 1. $

    Grâce à cette dernière ligne, nous avons désormais la première pièce du puzzle. Si nous réécrivons @distance_globale, nous pouvons dire que :
    #numbered_equation(
        $ #distance_globale(t: $t+1$) <= #distance_potential(t: $t+1$) + c'#distance_globale(). $, <majoration_distance_globale_1>
    )

    /*
    #let both_deactivation_event = $bb(2)$
    #let alone_deactivation_event = $bb(1)$
    #let no_deactivation_event = $bb(0)$
    Maintenant, nous allons majorer $bb(E)[e|#no_spike_event]$. Remarquons une nouvelle fois que trois nouveaux événements sont disjoints :

    #let both_deactivation_event_definition = ${#spiking_probability <= #auxiliary_uniform(t: $t+1$) <= #spiking_probability + #deactivation_probability} inter {#activation() = #activation_limit() = 1}$
    - L'événement $#both_deactivation_event = {"les deux synapses se désactivent au temps" $t+1$} = #both_deactivation_event_definition.$

    #let alone_deactivation_event_definition = ${#spiking_probability <= #auxiliary_uniform(t: $t+1$) <= #spiking_probability + #deactivation_probability} inter {#activation() = 1 "ou" #activation_limit() = 1}$
    - L'événement $#alone_deactivation_event = {"une seule synapse se désactive au temps" $t+1$} = #alone_deactivation_event_definition.$

    #let no_deactivation_event_definition = ${#auxiliary_uniform(t: $t+1$) < beta "ou" #auxiliary_uniform(t: $t+1$) > #spiking_probability + #deactivation_probability} union {#activation() = #activation_limit() = 0}$
    - L'événement $#no_deactivation_event = {"aucune synapse ne se désactive au temps" $t+1$} = #no_deactivation_event_definition.$

    Écrivons donc :
    #numbered_equation(
        $ bb(E)[e|#no_spike_event] = bb(P)(#both_deactivation_event)bb(E)[e|#no_spike_event, #both_deactivation_event] + bb(P)(#alone_deactivation_event)bb(E)[e|#no_spike_event, #alone_deactivation_event] + bb(P)(#no_deactivation_event)bb(E)[e|#no_spike_event, #no_deactivation_event]. $, <equation_majoration_no_spike_event>
    )

    - Si #both_deactivation_event est vérifié, alors l'indicatrice de désactivation est égale à 1, soit $#deactivation_indicator = 1$.\
        Il reste donc dans $bb(E)[e|#no_spike_event, #both_deactivation_event]$ :
        $ bb(E)[e|#no_spike_event, #both_deactivation_event] = bb(E)abs(#activation() - #activation_limit()) = #distance_activation(). $
        Pour $bb(P)(#both_deactivation_event)$, nous avons :
        $ bb(P)(#both_deactivation_event) = bb(P)(#both_deactivation_event_definition) = #deactivation_probability bb(P)(#activation() = #activation_limit() = 1) <= #deactivation_probability. $\

    #let probability_one_activated = $bb(P)(#activation() = 1 "ou" #activation_limit() = 1)$
    - Si #alone_deactivation_event est vérifié, alors l'indicatrice de désactivation est aussi égale à 1 et une des variables d'activation est nulle.\
        Nous restons avec :
        $ bb(E)[e|#no_spike_event, #alone_deactivation_event] = cases(bb(E)[#activation()], bb(E)[#activation_limit()]) < 1 "de toute façon". $
        En effet, comme $#activation() in {0, 1}$ et qu'il existe presque-sûrement des temps $t$ où $#activation() = 0$ alors $bb(E)[#activation()] < 1$ et $bb(E)[#activation_limit()] < 1$. On écrit $bb(E)[e|#no_spike_event, #alone_deactivation_event] = c_2 < 1$.\
        La probabilité $bb(P)(#alone_deactivation_event)$ peut s'écrire :
        $ bb(P)(#alone_deactivation_event) &= bb(P)(#alone_deactivation_event_definition)\
        & = #deactivation_probability #probability_one_activated. $

    - Si #no_deactivation_event est vérifié, alors l'indicatrice de désactivation est nulle, soit $#deactivation_indicator = 0$.\
        Il reste donc dans $bb(E)[e|#no_spike_event, #no_deactivation_event]$ :
        $ bb(E)[e|#no_spike_event, #no_deactivation_event] = bb(E)abs(#activation()#deactivation_indicator - #activation_limit()#deactivation_indicator) = 0. $\

    Reprenons maintenant @equation_majoration_no_spike_event pour écrire :
    #numbered_equation(
        $ bb(E)[e|#no_spike_event] <= #deactivation_probability #distance_activation() + c_2 #probability_one_activated. $,
        <equation_majoration_no_spike_event_2>
    )

    #proposition()[
        $ #probability_one_activated = #distance_activation(). $
    ] <majoration_probability_one_activated>
    #proof[
        Commençons par réécrire #probability_one_activated :
        $ #probability_one_activated = bb(E)[bold(1)_(#activation() = 1 "ou" #activation_limit() = 1)]. $
        Or $bold(1)_(#activation() = 1 "ou" #activation_limit() = 1)$ vaut 1 si et seulement si $#activation() ≠ #activation_limit()$, et zéro sinon. Cela signifie que $bold(1)_(#activation() = 1 "ou" #activation_limit() = 1)$ se comporte exactement comme $abs(#activation() - #activation_limit())$ puisque #activation() et #activation_limit() ne peuvent que prendre les valeurs zéro ou un.\
        Ainsi, 
        $ bb(E)[bold(1)_(#activation() = 1 "ou" #activation_limit() = 1)] = bb(E)[abs(#activation() - #activation_limit())] = #distance_activation(). $
    ]

    Grâce à la @majoration_probability_one_activated, nous pouvons réécrire @equation_majoration_no_spike_event_2 :
    #numbered_equation(
        $ bb(E)[e|#no_spike_event] <= (#deactivation_probability + c_2) #distance_activation(). $,
        <equation_majoration_no_spike_event_final>
    )

    Ainsi, en utilisant @majoration_distance_activation_3 et @equation_majoration_no_spike_event_final, nous avons :
    #numbered_equation(
        $ #distance_activation(t: $t+1$) <= (1 + #spiking_probability + c(#deactivation_probability + c_2))#distance_activation() + #spiking_probability #distance_potential(). $,
        <majoration_distance_activation_final>
    )

    *Problème constante multiplicative > 1...*
    */

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

    En reprenant @majoration_distance_potential_1, et en utilisant @majoration_probability_alone_spike_event_final avec @majoration_probability_no_spike_event pour majorer $bb(P)(#alone_spike_event) "et" bb(P)(#no_spike_event)$, nous obtenons :
    #numbered_equation(
        $ #distance_potential(t: $t+1$) <= #spiking_probability #max_potential #distance_potential() + c bb(E)[f|#no_spike_event]. $,
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
    $ #distance_potential(t: $t+1$) &<= #spiking_probability#max_potential#distance_potential() + c(#distance_potential() + #spiking_probability (#distance_activation() + #distance_potential()) + 1 /(2 sqrt(N))), $
    #numbered_equation(
        $ #distance_potential(t: $t+1$) <= (#spiking_probability #max_potential + c(1 + #spiking_probability))#distance_potential() + c #spiking_probability #distance_activation() + c/(2 sqrt(N)). $,
        <majoration_distance_potential_finale>
    )

    *Supposer $#spiking_probability #max_potential + c(1 + #spiking_probability) > 1$ ?*

    Si nous acceptons l'hypothèse
    $ #spiking_probability #max_potential + c(1 + #spiking_probability) > 1, $
    alors nous pouvons écrire que
    #numbered_equation($ #distance_potential(t: $t+1$) <= c''#distance_globale() + c/(2 sqrt(N)), $, <majoration_distance_globale_2>)
    où $c'' = max(#spiking_probability #max_potential + c(1 + #spiking_probability), c #spiking_probability) < 1$.

    Si nous combinons la première pièce @majoration_distance_globale_1 avec la seconde pièce du puzzle @majoration_distance_globale_2, nous obtenons enfin,

    $ #distance_globale(t: $t+1$) &<= c''#distance_globale() + c'#distance_globale() + c/(2 sqrt(N)),\
    &<= C #distance_globale() + c/(2 sqrt(N)), $
    avec $C$ la constante suivante : $C = max(c'', c') < 1$.

    Rappellons-nous que les processus sont initialisés de la même façon, ce qui signifique que $#distance_globale(t: $0$) = 0$.\
    Ainsi, en $t=1$ : 
    $ #distance_globale(t: $1$) <= c/(2 sqrt(N)). $
    Poursuivant l'itération, nous avons :
    $ #distance_globale(t: $2$) &<= C #distance_globale(t: $1$) + c/(2 sqrt(N)) = (C +1) c/(2 sqrt(N)) "puis",\
    #distance_globale(t: $3$) &<= C #distance_globale(t: $2$) + c/(2 sqrt(N)) <= C (C +1) c/(2 sqrt(N)) + c/(2 sqrt(N)) = (C^2 + C + 1) c/(2 sqrt(N)).\ $

    Ce qui nous fait aboutir à :
    $ #distance_globale() <= (sum_(k=0)^(t-1)C^k) c/(2 sqrt(N)). $
    Or puisque $C < 1$ et que $t$ est un élément quelconque et fini de $bb(N)$, alors un polynôme en $C$ est nécessairement fini.\
    D'où $sum_(k=0)^(t-1)C^k < oo$, impliquant finalement,
    $ #distance_globale() ->_(N -> oo) 0. $

    Ce qui parachève la preuve du @theoreme_convergence_processus ! #place(right, $square.stroked$)
]