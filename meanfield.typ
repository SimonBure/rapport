#import "rules.typ": *
#import "global_variables.typ": *

// Display settings for theorems and proofs
#show: thmrules.with(qed-symbol: $square$)

// Variables for this section
#let distance_activation(t: $t$) = $delta_#t^(i, N)$
#let distance_potential(t: $t$) = $d_#t^(i, N)$
#let distance_global(t: $t$) = $D_#t^(i, N)$
#let simplification_variable(t: $t$, i: $i$) = $Y_#t^#i$
#let simplification_variable_limit(t: $t$, i: $i$) = $overline(Y)_#t^#i$
#let potential_limit_dynamics = $#membrane_potential_limit(t: $t+1$) = #non_spiking_indicator_limit (#membrane_potential_limit() + bb(E)[#simplification_variable()])$
#let activation_limit_dynamics = $#activation_limit(t: $t+1$) = #activation_limit() + (1 - #activation_limit())#spiking_indicator_limit() - #activation_limit()#deactivation_indicator$

L'hypothèse de champ moyen que nous allons faire dans cette partie consiste à considérer un grand nombre de neurones $N$ et à les considérer comme étant tous *identiques*, c'est-à-dire indiscernables et avec les même valeurs pour conditions initiales :
$ forall (v, a) in {0, 1, dots, #max_potential} times {0, 1},\
X_0^N = vec((v, a), (v, a), dots.v, (v, a)). $

#set math.vec(delim: none)
Comme les neurones sont indiscernables, nous pouvons les compter simplement et au lieu d'écrire $sum_vec(j = 0, j != i)^N$, écrire directement $sum_(j = 1)^N$.

Avec le modèle utilisé dans les parties précédentes, lorsque nous ferons tendre $N$ vers l'infini, la somme $sum_(j = 1)^N #activation()#spiking_indicator()$ explosera. Pour conserver l'intégrité du modèle, nous allons ajouter un facteur $1/N$ pour normaliser cette somme. Enfin, pour alléger l'écriture, nous noterons à partir de maintenant
$ #simplification_variable() = #activation()#spiking_indicator(). $

Ainsi l'équation de la dynamique du potentiel de membrane,
#potential_dynamics
#let potential_dynamics = $#membrane_potential(t: $t+1$) = #non_spiking_indicator (#membrane_potential() + 1/N sum_(j=1)^N #simplification_variable(i: $j$))$
s'écrit désormais
$ #potential_dynamics. $


== Processus limites
Nous allons noter #membrane_potential_limit() et #activation_limit() les *processus limites* de potentiel de membrane et d'activation pour le neurone $i$. Pour suivre cette notation, posons également que $#simplification_variable_limit() = #activation_limit()#spiking_indicator_limit()$.

Nous allons supposer l'existence d'une "loi des grands nombres" permettant d'affirmer que
$ 1/N sum_(i=0)^N #simplification_variable_limit() ->_(N -> oo) bb(E)[#simplification_variable_limit()]. $

À la lueur de ces hypothèses et de ces définitions, écrivons désormais les équations régissant les dynamiques de ces deux processus limites en spécifiant que les processus classiques et limites *partagent la même variable auxiliaire uniforme* #auxiliary_uniform().\
Pour le processus limite du potentiel de membrane nous avons
$ #potential_limit_dynamics, $
et pour le processus limite de la variable d'activation
$ #activation_limit_dynamics. $


== Existence des processus limites


== Convergence vers les processus limites
Nous allons démontrer que les processus classiques convergent vers les processus limites. Les processus de voltage et d'activation doivent tous deux converger vers leurs processus limites respectifs.\
Ainsi, si nous définissons la *distance entre les processus de potentiel de membrane* 
$ #distance_potential() = bb(E)abs(#membrane_potential() - #membrane_potential_limit()), $ ainsi que *distance entre les processus d'activation* 
$ #distance_activation() = bb(E)abs(#activation() - #activation_limit()), $ nous pouvons écrire la *distance globale* entre le processus de neurone et sa limite comme 
$ #distance_global() = #distance_potential() + #distance_activation(). $

// #set math.equation(numbering: "(1)")
#theorem("Convergence vers les processus limites")[
    Pour tout $i in {1, dots, N}$, nous avons :
    $ lim_(N->oo) #distance_global() = 0. $
    // c'est-à-dire que :
    // $ lim_(N->oo) d^i_(t+1) = 0 $ <conv_potentiel> et
    // $ lim_(N->oo) delta^i_(t+1) = 0. $ <conv_activation>
] <convergence_theorem>

#proof[
    L'idée de cette preuve est de montrer que la suite des distances #distance_global(t: $0$), #distance_global(t: $1$), $dots,$ #distance_global(), #distance_global(t: $t+1$) subit une contraction, soit
    $ forall c < 1, space #distance_global(t: $t+1$) <= c#distance_global(). $
    Nous pourrons ensuite utiliser l'hypothèse que tous les neurones commencent avec les même conditions initiales pour dire que $#distance_global(t: $0$) = 0$ et puis finalement utiliser un argument de récurrence pour conclure la preuve.
    
    L'objectif est donc de trouver une majoration de #distance_global(t: $t+1$) par #distance_global()\
    Cela passe évidemment par trouver des majorations similaires pour #distance_potential(t: $t+1$) et #distance_activation(t: $t+1$).

    Commençons par majorer #distance_activation(t: $t+1$). De la définition, il vient :
    $ #distance_activation(t: $t+1$) &= bb(E)abs(#activation(t: $t+1$) - #activation_limit(t: $t+1$)) <= bb(E)abs(A_t^i - overline(A)_t^i) +\
    &bb(E)underbrace(abs((1 - #activation())#spiking_indicator() - (1 - #activation_limit())#spiking_indicator_limit() - (#activation()#deactivation_indicator - #activation_limit()#deactivation_indicator)), "= e pour simplifier l'écriture pour les lignes suivantes"). $
    
    #let simultaneous_spikes_event = $bold(2)$
    #let alone_spike_event = $bold(1)$
    #let no_spike_event = $bold(0)$
    Remarquons que les trois événements suivants sont disjoints :
    + L'événement $#simultaneous_spikes_event = {"le processus classique et limite spikent simultanément au temps" t+1} = {0 < #auxiliary_uniform(t: $t+1$) < #spiking_probability} inter {#membrane_potential() = #membrane_potential_limit() = #max_potential}.$

    + L'évévement $#alone_spike_event = {"un des deux processus spikes au temps" t+1} = {0 < #auxiliary_uniform(t: $t+1$) < #spiking_probability} inter {#membrane_potential() < #max_potential "ou" #membrane_potential_limit() < #max_potential}.$

    + L'événement $#no_spike_event = {"aucun processus ne spike au temps" t+1} = {#auxiliary_uniform(t: $t+1$) > #spiking_probability} union {#membrane_potential() < #max_potential "et" #membrane_potential_limit() < #max_potential}.$
    
    Nous pouvons donc écrire
    #numbered_equation(
        $ #distance_activation(t: $t+1$) <= #distance_activation() + bb(P)(#simultaneous_spikes_event)bb(E)[e|#simultaneous_spikes_event] + bb(P)(#alone_spike_event)bb(E)[e|#alone_spike_event] + bb(P)(#no_spike_event)bb(E)[e|#no_spike_event]. $, <equation_majoration_distance_activation>
    )

    + Si #simultaneous_spikes_event est vérifié, alors les indicatrices de la désactivation sont nulles ($#deactivation_indicator = 0$) et les indicatrices des spikes valent un (#spiking_indicator() = #spiking_indicator_limit() = 1).\
        Ainsi il reste dans $bb(E)[e|#simultaneous_spikes_event]$ :
        $ bb(E)[e|#simultaneous_spikes_event] = bb(E)abs((1 - #activation()) - (1 - #activation_limit())) = #distance_activation(). $
        Pour $bb(P)(#simultaneous_spikes_event)$, nous avons :
        $ bb(P)(#simultaneous_spikes_event) = bb(P)({0 < #auxiliary_uniform(t: $t+1$) < #spiking_probability} inter {#membrane_potential() = #membrane_potential_limit() = #max_potential}) = #spiking_probability bb(P)(#membrane_potential() = #membrane_potential_limit() = #max_potential) <= #spiking_probability. $

    #let probability_spike_alone_event = $bb(P)(#membrane_potential() < #max_potential "ou" #membrane_potential_limit() < #max_potential))$

    + Si #alone_spike_event est vérifié, alors $0 < #auxiliary_uniform(t: $t+1$) < #spiking_probability$, ce qui implique ici aussi que $#deactivation_indicator = 0$, et une seule des fonctions de saut est non nulle ($#spiking_function() = 0 "ou" #spiking_function(v: membrane_potential_limit()) = 0$).\
        Il reste ainsi dans $bb(E)[e|#alone_spike_event]$,
        $ bb(E)[e|#alone_spike_event] = bb(E)abs((1 - #activation())) "ou" bb(E)abs((1 - #activation_limit())) <= 1 "de toute façon". $
        La probabilité $bb(P)(#alone_spike_event)$ peut s'écrire :
        $ bb(P)(#alone_spike_event) = bb(P)({0 < #auxiliary_uniform(t: $t+1$) < #spiking_probability} inter {#membrane_potential() < #max_potential "ou" #membrane_potential_limit() < #max_potential}) = #spiking_probability #probability_spike_alone_event. $
        La probabilité #probability_spike_alone_event sera majorée plus loin.

    + Si #no_spike_event est vérifié, alors seulent restent les indicatrices de la désactivation dans $bb(E)[e|#no_spike_event]$ (#spiking_indicator() = #spiking_indicator_limit() = 0).\
        Ainsi,
        $ bb(E)[e|#no_spike_event] = bb(E)abs(#activation()#deactivation_indicator - #activation_limit()#deactivation_indicator), $
        qui sera développée et majorée plus loin.\
        Concernant $bb(P)(#no_spike_event)$, nous pouvons écrire :
        $ bb(P)(#no_spike_event) &= bb(P)({#auxiliary_uniform(t: $t+1$) > #spiking_probability} union {#membrane_potential() < #max_potential "et" #membrane_potential_limit() < #max_potential}),\
        &= bb(P)(#auxiliary_uniform(t: $t+1$) > #spiking_probability) + bb(P)(#membrane_potential() < #max_potential "et" #membrane_potential_limit() < #max_potential) - bb(P)({#auxiliary_uniform(t: $t+1$) > #spiking_probability} inter {#membrane_potential() < #max_potential "et" #membrane_potential_limit() < #max_potential}),\
        &= 1 - #spiking_probability + #spiking_probability bb(P)(#membrane_potential() < #max_potential "et" #membrane_potential_limit() < #max_potential). $
        Par construction, nous avons nécessairement $bb(P)(#membrane_potential() < #max_potential "et" #membrane_potential_limit() < #max_potential) < 1$ car le neurone $i$ se trouve nécessairement, pour certains temps $t$, dans la couche #max_potential.\
        Ainsi, $ bb(P)(#no_spike_event) = c < 1. $

    En reprenant @equation_majoration_distance_activation, nous aboutissons à :
    #numbered_equation($ #distance_activation(t: $t+1$) <= #distance_activation() + #spiking_probability#distance_activation() + #spiking_probability #probability_spike_alone_event + c bb(E)[e|#no_spike_event]. $, <equation_majoration_distance_activation_2>)

    L'expression précédente peut se simplifier encore, en remarquant la proposition qui suit, provenant de la structure discrète de notre processus.

    #proposition()[
        $ #probability_spike_alone_event <= #distance_potential(). $
    ] <majoration_discrete>
    #proof[
        Commençons par réécrire #probability_spike_alone_event :
        $ #probability_spike_alone_event = bb(E)[bold(1)_(#membrane_potential() < #max_potential "ou" #membrane_potential_limit() < #max_potential)]. $
        Remarquons ensuite que l'événement ${#membrane_potential() < #max_potential "ou" #membrane_potential_limit() < #max_potential}$ implique que les potentiels de membrane des processus classique et limite sont différents, c'est-à-dire que $#membrane_potential() ≠ #membrane_potential_limit()$.\
        Par construction, #membrane_potential() et #membrane_potential_limit() ne peuvent prendre que des valeurs discrètes comprises entre zéro et #max_potential. Il en découle que la distance entre les deux potentiels de membrane est nécessairement supérieure ou égale à 1, soit $abs(#membrane_potential() - #membrane_potential_limit()) >= 1$.\
        Ainsi, nous avons :
        $ abs(#membrane_potential() - #membrane_potential_limit()) >= bold(1)_(#membrane_potential() < #max_potential "ou" #membrane_potential_limit() < #max_potential),\
        "et donc" bb(E)[bold(1)_(#membrane_potential() < #max_potential "ou" #membrane_potential_limit() < #max_potential)] <= bb(E)abs(#membrane_potential() - #membrane_potential_limit()) = #distance_potential(). $
    ]

    En utilisant la @majoration_discrete et @equation_majoration_distance_activation_2, nous arrivons à :
    #numbered_equation(
        $ #distance_activation(t: $t+1$) <= (1 + #spiking_probability)#distance_activation() + #spiking_probability#distance_potential() + c bb(E)[e|#no_spike_event]. $, <equation_majoration_distance_activation_3>
    )
    
    #let both_deactivation_event = $bb(2)$
    #let alone_deactivation_event = $bb(1)$
    #let no_deactivation_event = $bb(0)$
    Maintenant, nous allons majorer $bb(E)[e|#no_spike_event]$. Remarquons une nouvelle fois que trois nouveaux événements sont disjoints :

    #let both_deactivation_event_definition = ${#spiking_probability <= #auxiliary_uniform(t: $t+1$) <= #spiking_probability + #deactivation_probability} inter {#activation() = #activation_limit() = 1}$
    + L'événement $#both_deactivation_event = {"les deux synapses se désactivent au temps" $t+1$} = #both_deactivation_event_definition.$

    #let alone_deactivation_event_definition = ${#spiking_probability <= #auxiliary_uniform(t: $t+1$) <= #spiking_probability + #deactivation_probability} inter {#activation() = 1 "ou" #activation_limit() = 1}$
    + L'événement $#alone_deactivation_event = {"une seule synapse se désactive au temps" $t+1$} = #alone_deactivation_event_definition.$

    #let no_deactivation_event_definition = ${#auxiliary_uniform(t: $t+1$) < beta "ou" #auxiliary_uniform(t: $t+1$) > #spiking_probability + #deactivation_probability} union {#activation() = #activation_limit() = 0}$
    + L'événement $#no_deactivation_event = {"aucune synapse ne se désactive au temps" $t+1$} = #no_deactivation_event_definition.$

    Écrivons donc :
    #numbered_equation(
        $ bb(E)[e|#no_spike_event] = bb(P)(#both_deactivation_event)bb(E)[e|#no_spike_event, #both_deactivation_event] + bb(P)(#alone_deactivation_event)bb(E)[e|#no_spike_event, #alone_deactivation_event] + bb(P)(#no_deactivation_event)bb(E)[e|#no_spike_event, #no_deactivation_event]. $, <equation_majoration_no_spike_event>
    )

    + Si #both_deactivation_event est vérifié, alors l'indicatrice de désactivation est égale à 1, soit $#deactivation_indicator = 1$.\
        Il reste donc dans $bb(E)[e|#no_spike_event, #both_deactivation_event]$ :
        $ bb(E)[e|#no_spike_event, #both_deactivation_event] = bb(E)abs(#activation() - #activation_limit()) = #distance_activation(). $
        Pour $bb(P)(#both_deactivation_event)$, nous avons :
        $ bb(P)(#both_deactivation_event) = bb(P)(#both_deactivation_event_definition) = #deactivation_probability bb(P)(#activation() = #activation_limit() = 1) <= #deactivation_probability. $\

    #let probability_one_activated = $bb(P)(#activation() = 1 "ou" #activation_limit() = 1)$
    + Si #alone_deactivation_event est vérifié, alors l'indicatrice de désactivation est aussi égale à 1 et une des variables d'activation est nulle.\
        Nous restons avec :
        $ bb(E)[e|#no_spike_event, #alone_deactivation_event] = cases(bb(E)[#activation()], bb(E)[#activation_limit()]) < 1 "de toute façon". $
        En effet, comme $#activation() in {0, 1}$ et qu'il existe presque-sûrement des temps $t$ où #activation() alors $bb(E)[#activation()] < 1$ et $bb(E)[#activation_limit()] < 1$. On écrit $bb(E)[e|#no_spike_event, #alone_deactivation_event] = c_2 < 1$.\
        La probabilité $bb(P)(#alone_deactivation_event)$ peut s'écrire :
        $ bb(P)(#alone_deactivation_event) &= bb(P)(#alone_deactivation_event_definition)\
        & = #deactivation_probability #probability_one_activated. $
        La probabilité #probability_one_activated sera majorée plus loin.\

    + Si #no_deactivation_event est vérifié, alors l'indicatrice de désactivation est nulle, soit $#deactivation_indicator = 0$.\
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

    Ainsi, en utilisant @equation_majoration_distance_activation_3 et @equation_majoration_no_spike_event_final, nous avons :
    #numbered_equation(
        $ #distance_activation(t: $t+1$) <= (1 + #spiking_probability)#distance_activation() + #spiking_probability#distance_potential() + c(#deactivation_probability + c_2) #distance_activation(). $,
        <equation_majoration_distance_activation_final>
    )
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