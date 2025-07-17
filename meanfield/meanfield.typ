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


== Existence des processus limites
Comme les deux processus limites #neuron_limit() prennent leurs valeurs dans des espaces discrets et finis, ils sont tous les deux bien définis. L'existence des processus ne pose ainsi aucun problème, et nous pouvons écrire le théorème suivant :

#theorem("Existence des processus limites")[
    Pour tout $t in #time_window$, il existe un unique processus #neuron_limit() avec un #unknown_expectation() associé.
]<theorem_existence_processus_limite>

#todo("À valider + développer si besoin preuve existence")


== Convergence vers les processus limites

#let spiking_function_lip_raw = $phi.alt_*$
#theorem([Propagation du chaos avec une fonction de spiking modifiée])[
    Étant donné l'existence du processus limite donné dans le @theorem_existence_processus_limite et son #unknown_expectation() associé, et une nouvelle fonction #spiking_function_lip_raw, prise lipschitz et de constante $L$, et approchant #spiking_function_raw, nous avons
    $ #expectation_absolute($#membrane_potential() - #membrane_potential_limit()$) + #expectation_absolute($#activation() - #activation_limit()$) <= Kappa/ sqrt(N). $
    $Kappa$ est ici une constante définie grâce aux paramètres du modèle et de la constante de lipschitz $L$. 
]<theorem_propagation_chaos>

Le @theorem_propagation_chaos possède un corollaire direct (@theoreme_convergence_processus), formalisant la convergence des processus finis vers leur version limite.
#corrolary("Convergence des processus finis vers les processus limites")[
    $ lim_(N -> oo) #expectation_absolute($#membrane_potential() - #membrane_potential_limit()$) + #expectation_absolute($#activation() - #activation_limit()$) = 0, $
    ce qui revient à dire que, pour tout $i in #indexes_interval$, et pour un $t in #time_interval$, avec $T$ nombre entier positif :
    $ (#membrane_potential(), #activation()) ->_(N -> oo) (#membrane_potential_limit(), #activation_limit()). $
]<theoreme_convergence_processus>

#proof([du @theorem_propagation_chaos])[
    Commençons par introduire quelques notations. Appelons *distance entre les processus de potentiel de membrane*, la quantité
    $ #distance_potential() = bb(E)abs(#membrane_potential() - #membrane_potential_limit()), $ ainsi que *distance entre les processus d'activation*, le nombre
    $ #distance_activation() = bb(E)abs(#activation() - #activation_limit()). $
    Enfin nous pouvons écrire la *distance globale* entre le processus de neurone et sa limite comme 
    #numbered_equation($ #distance_globale() = #distance_potential() + #distance_activation(). $, <distance_globale>)

    === Majoration de #distance_activation(t: $t+1$)
    Commençons par majorer #distance_activation(t: $t+1$). De la définition, il vient :
    $ #distance_activation(t: $t+1$) &= bb(E)abs(#activation(t: $t+1$) - #activation_limit(t: $t+1$)),\
    &= bb(E)abs(#spiking_indicator() - #spiking_indicator_limit()\
    &+ #activation()#non_spiking_indicator (1 - #deactivation_indicator) - #activation_limit()#non_spiking_indicator_limit (1 - #deactivation_indicator)),\
    &= expectation(e) "pour simplifier l'écriture pour la suite." $
    
    === Séparation en évévements disjoints
    #let simultaneous_spikes_event = $bold(2)$
    #let alone_spike_event = $bold(1)$
    #let alone_spike_event_def = ${min(#spiking_function(v: membrane_potential()), #spiking_function(v: membrane_potential_limit())) < #auxiliary_uniform(t: $t+1$) < max(#spiking_function(v: membrane_potential()), #spiking_function(v: membrane_potential_limit()))}$
    #let no_spike_event = $bold(0)$
    Remarquons que les trois événements suivants sont disjoints :
    - L'événement $#simultaneous_spikes_event = {"processus finis et limites spikent simultanément en" t+1}$ peut s'écrire formellement :
        #numbered_equation($ #simultaneous_spikes_event = {#auxiliary_uniform(t: $t+1$) < min(#spiking_function(v: membrane_potential()), #spiking_function(v: membrane_potential_limit()))}. $, <definition_simultaneous_spikes_event>)

    - L'évévement $#alone_spike_event = {"processus fini ou (exclusif) limite spike en" t+1}$ qui s'écrit formellement :
    #numbered_equation($ #alone_spike_event_def. $, <definition_spike_exclusif>)

    - L'événement $#no_spike_event = {"aucun processus ne spike au temps" t+1}$, soit :
    $ {#auxiliary_uniform(t: $t+1$) > max(#spiking_function(v: membrane_potential()), #spiking_function(v: membrane_potential_limit()))}. $

    Nous pouvons donc écrire
    #numbered_equation(
        $ #distance_activation(t: $t+1$) =bb(P)(#simultaneous_spikes_event)bb(E)[e|#simultaneous_spikes_event] + #proba(alone_spike_event)bb(E)[e|#alone_spike_event] + #proba(no_spike_event)bb(E)[e|#no_spike_event]. $, <majoration_distance_activation>
    )
    Observons à présent les implications de chaque événement.

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

    En reprenant @majoration_distance_activation, nous aboutissons à :
    #numbered_equation(
        $ #distance_activation(t : $t+1$) <= #proba(alone_spike_event) + #proba(no_spike_event) (1 + #deactivation_probability)#distance_activation(). $, <majoration_distance_activation_2>
    )

    #let probability_spike_alone_event = proba(alone_spike_event_def)
    #let distance_spiking_functions = $abs(#spiking_function(v: membrane_potential()) - #spiking_function(v: membrane_potential_limit()))$
    Si nous utilisons la définition de $#proba(alone_spike_event)$ définie à l'@definition_spike_exclusif, combiné au fait que #auxiliary_uniform() est une variable uniforme sur $[0, 1]$ :
    $ #proba(alone_spike_event) &= #probability_spike_alone_event,\
    &= max(#spiking_function(v: membrane_potential()), #spiking_function(v: membrane_potential_limit())) - min(#spiking_function(v: membrane_potential()), #spiking_function(v: membrane_potential_limit())),\
    &= #distance_spiking_functions. $

    === La nécessité d'une fonction de spiking lipschitzienne
    C'est ici que nous comprenons pourquoi il est nécessaire de modifier la définition de la fonction #spiking_function_raw. Si #spiking_function_raw était L-lipschitz, nous pourrions majorer #distance_spiking_functions par $L abs(#membrane_potential() - #membrane_potential_limit())$.
    Le problème est de trouver une fonction qui soit lipschitz mais qui puisse tout de même approcher le comportement de l'indicatrice présente dans #spiking_function_raw. La figure @benchmark_replace_indicator montre quelques fonctions qui ont été étudiées pour approcher l'indicatrice. La fonction retenue sera finalement #spiking_function_lip_raw une modification de la fonction tangente hyperbolique :

    // Définition de la nouvelle fonction de spiking lipschitzienne
    #let spiking_steepness = $k$
    #let spiking_function_lipschitz_def = $1/2 (1 + tanh(#spiking_steepness (v - #max_potential)))$
    #let spiking_function_lipschitz = $#spiking_function_lip_raw (v)$
    #numbered_equation(
        $ #spiking_function_lipschitz = #spiking_function_lipschitz_def. $,
        <def_spiking_f_lipschitz>
    )
    Dans @def_spiking_f_lipschitz, #spiking_steepness est un paramètre de raideur qui contrôle la vitesse de transition entre les régimes de non-spiking et de spiking.\

    #figure(image("../figures/benchmark_replace_indicator.png"), caption: [Exemples de fonction lipschitz pouvant remplacer]) <benchmark_replace_indicator>

    // Variables pour la preuve
    #let lipschitz_constant = $L$

    #proposition([Lipschitzianité de la fonction de spiking lissée])[
        La fonction $#spiking_function_lipschitz = 1/2 (1 + tanh(#spiking_steepness (v - #max_potential)))$ est lipschitzienne avec une constante de Lipschitz $#lipschitz_constant = #spiking_steepness/2$.
    ]<prop_spiking_function_lipschitz>

    #proof()[
        Pour démontrer la lipschitzianité de #spiking_function_lip_raw, nous allons montrer que sa dérivée est bornée, puis appliquer le théorème des accroissements finis.

        === Calcul de la dérivée

        Calculons d'abord la dérivée de #spiking_function_lip_raw :
        #let deriv_spiking_function_lip_raw = $attach(#spiking_function_lip_raw, tr: ')$
        #let deriv_spiking_function_lipschitz = $#deriv_spiking_function_lip_raw (v)$
        $ 
        #deriv_spiking_function_lipschitz &= frac(d, d x) [1/2 (1 + tanh(#spiking_steepness (x - #max_potential)))],\
        &= #spiking_steepness/2 [1 - tanh(#spiking_steepness (v - #max_potential))^2].
        $

        === Majoration de la dérivée

        Comme $tanh(u) in (-1, 1)$ pour tout $u in #reals$, nous avons :
        $ tanh^2(u) in [0, 1). $

        Par conséquent :
        $ #deriv_spiking_function_lipschitz <= #spiking_steepness/2. $

        === Application du théorème des accroissements finis

        Maintenant que nous avons montré que $#deriv_spiking_function_lipschitz <= #spiking_steepness/2$ pour tout $x in #reals$, nous pouvons appliquer le théorème des accroissements finis.

        Pour tous $x, y in #reals$, il existe $xi in [min(x,y), max(x,y)]$ tel que :
        $ #spiking_function_lip_raw (x) - #spiking_function_lip_raw (y) = #deriv_spiking_function_lip_raw (xi)(x - y) $

        En prenant la valeur absolue : 
        $ |#spiking_function_lip_raw (x) - #spiking_function_lip_raw (y)| = |#deriv_spiking_function_lip_raw (xi)| dot |x - y| <= #spiking_steepness/2 dot |x - y|. $

        La fonction $#spiking_function_lipschitz$ est donc lipschitzienne avec une constante de Lipschitz $#lipschitz_constant = #spiking_steepness/2$.
    ]
    
    /*
    #remark([Optimalité de la constante de Lipschitz])[
        La constante $#lipschitz_constant = #spiking_steepness/2$ est optimale car elle est effectivement atteinte. En effet, considérons les points $x_1 = #max_potential - epsilon/#spiking_steepness$ et $x_2 = #max_potential + epsilon/#spiking_steepness$ pour $epsilon$ petit. Quand $epsilon -> 0$, le rapport $frac(|#spiking_function_lipschitz (x_2) - #spiking_function_lipschitz (x_1)|, |x_2 - x_1|)$ tend vers $#spiking_steepness/2$.
    */

    Ainsi, en appliquant @prop_spiking_function_lipschitz pour majorer #proba(alone_spike_event) :
    #numbered_equation(
        $ #proba(alone_spike_event) <= #spiking_steepness/2 #distance_activation(). $,
        <majoration_probability_alone_spike_event>
    )


    Si nous reprenons @majoration_distance_activation_2 avec @majoration_probability_alone_spike_event et en majorant #proba(no_spike_event) par $1$, nous obtenons :
    #numbered_equation($ #distance_activation(t : $t+1$) <=  (1 + #spiking_steepness/2 + #deactivation_probability)#distance_activation(). $, <majoration_distance_activation_finale>)

    Grâce à cette dernière ligne, nous avons désormais la première pièce du puzzle. Si nous réécrivons @distance_globale, nous pouvons dire que :
    #numbered_equation(
        $ #distance_globale(t: $t+1$) <= #distance_potential(t: $t+1$) + (1 + #spiking_steepness/2 + #deactivation_probability)#distance_activation(). $, <majoration_distance_globale_1>
    )
    Passons à présent à la majoration de #distance_potential(t: $t+1$).

    === Majoration de #distance_potential(t: $t+1$)
    De la définition, il vient :
    $ #distance_potential(t: $t+1$) = bb(E)abs(#membrane_potential(t: $t+1$) - #membrane_potential_limit(t: $t+1$)),\
    = bb(E)underbrace(abs(#non_spiking_indicator (#membrane_potential() + 1/N sum_(j=1)^N #network_contributions(i: $j$)) - #non_spiking_indicator_limit (#membrane_potential_limit() + bb(E)[#network_contributions_limit()])), "= f pour simplifier l'écriture par la suite"). $

    Nous pouvons ici aussi utiliser les trois événements disjoints #simultaneous_spikes_event, #alone_spike_event et #no_spike_event définis précédemment pour écrire :
    #numbered_equation(
        $ #distance_potential(t: $t+1$) = bb(P)(#simultaneous_spikes_event)bb(E)[f|#simultaneous_spikes_event] + #proba(alone_spike_event)bb(E)[f|#alone_spike_event] + #proba(no_spike_event)bb(E)[f|#no_spike_event]. $,
        <majoration_distance_potential_1>
    )
    Regardons également les effets de ces événements sur #expectation_absolute($#membrane_potential(t: $t+1$) - #membrane_potential_limit(t: $t+1$)$) :

    - Si l'événement #simultaneous_spikes_event est vérifié, alors les indicatrices d'absence de spike sont nulles, c'est-à-dire $#non_spiking_indicator = #non_spiking_indicator_limit = 0$), ce qui nous donne :
        $ bb(E)[f|#simultaneous_spikes_event] = 0. $

    - Si l'événement #alone_spike_event est vérifié, alors seule une des indicatrices d'absence de spike est nulle, soit $#non_spiking_indicator = 0$ ou $#non_spiking_indicator_limit = 0$.\
        Il reste donc dans $bb(E)[f|#alone_spike_event]$ :
        $ bb(E)[f|#alone_spike_event] = cases(bb(E)abs(#membrane_potential() + 1/N sum_(j=1)^N #network_contributions(i: $j$)) "si le processus limite spike", bb(E)abs(#membrane_potential_limit() + bb(E)[#network_contributions_limit()]) "si le processus fini spike"). $
        Dans tous les cas, nous pouvons majorer par $#max_potential + 1$ car #membrane_potential() est borné par #max_potential et que $sum_(j=1)^N #network_contributions(i: $j$))$ peut valoir au plus $N$. Donc
        $ bb(E)[f|#alone_spike_event] <= #max_potential + 1. $  

    - Si l'événement #no_spike_event est vérifié, alors les indicatrices d'absence de spike valent toutes deux un, c'est-à-dire $#non_spiking_indicator = #non_spiking_indicator_limit = 1$. Cela nous permet d'écrire :
        $ bb(E)[f|#no_spike_event] = bb(E)abs(#membrane_potential() + 1/N sum_(j=1)^N #network_contributions(i: $j$) - (#membrane_potential_limit() + bb(E)[#network_contributions_limit()])). $
        Cette quantité sera majorée plus loin, car son développement est un peu plus long.

    En reprenant @majoration_distance_potential_1 avec ces résultats ainsi que @majoration_probability_alone_spike_event et $#proba(no_spike_event) <= 1$, nous obtenons :
    #numbered_equation(
        $ #distance_potential(t: $t+1$) <= L (#max_potential + 1) #distance_activation() + bb(E)[f|#no_spike_event]. $,
        <majoration_distance_potential_2>
    )

    Maintenant, nous allons développer $bb(E)[f|#no_spike_event]$. Ajoutons et retirons $1/N sum_(j=1)^N #network_contributions_limit(i: $j$)$ :
    $ bb(E)[f|#no_spike_event] = bb(E)abs(#membrane_potential() + 1/N sum_(j=1)^N #network_contributions(i: $j$) - (#membrane_potential_limit() + bb(E)[#network_contributions_limit()])\
    + 1/N sum_(j=1)^N #network_contributions_limit(i: $j$) - 1/N sum_(j=1)^N #network_contributions_limit(i: $j$) ), $

    #let martingale(i: $i$) = $overline(M)_(t)^#i$
    #let martingale_def = $sum_(j=1)^N (#network_contributions_limit(i: $j$) - bb(E)[#network_contributions_limit(i: $j$)])$
    Posons 
    #numbered_equation(
        $ #martingale() = #martingale_def, $,
        <definition_martingale>
    )
    nous avons alors,
    $ bb(E)[f|#no_spike_event] = bb(E)abs(#membrane_potential() - #membrane_potential_limit() + 1/N sum_(j=1)^N #network_contributions(i: $j$) - 1/N sum_(j=1)^N #network_contributions_limit(i: $j$) + 1/N #martingale()), $

    #let distance_simplification_variables = $abs(#network_contributions(i: $j$) - #network_contributions_limit(i: $j$))$
    #let esperance_distance_simplification_variables = $bb(E)#distance_simplification_variables$
    ce qui aboutit à :
    #numbered_equation(
        $ bb(E)[f|#no_spike_event] <= bb(E)abs(#membrane_potential() -       #membrane_potential_limit()) + 1/N sum_(j=1)^N #esperance_distance_simplification_variables + 1/N bb(E)abs(#martingale()). $, <majoration_distance_potential_3>
    )

    Pour majorer cette quantité, nous aurons besoin de la @proposition_majoration_martingale :
    #proposition()[
        $ bb(E)abs(#martingale()) <= sqrt(N)/2. $
    ] <proposition_majoration_martingale>
    #proof()[

        #let square_martingale = $abs(#martingale())^2$
        #let square_root_martingale_squared = $sqrt(#square_martingale)$
        #let expectation_martingale = expectation_absolute(martingale())
        #let expectation_network_contrib(i: $i$) = expectation(network_contributions_limit(i: i))
        Nous pouvons écrire :
        $ abs(#martingale()) &= sqrt(abs(#martingale())^2),\
        => #expectation_martingale &= bb(E)[sqrt(abs(#martingale())^2)]. $
        En utilisant l'inégalité de Jensen pour majorer la fonction concave racine carrée :
        #numbered_equation(
            $ #expectation_martingale <= sqrt(#expectation(square_martingale)). $,
            <majoration_martingale_jensen_concave>
        )
        
        Reprenons la définition de #martingale() (@definition_martingale) :
        #let sum_network_contrib = $sum_(j=1)^N #network_contributions_limit(i: $j$)$
        $ #expectation(square_martingale) = #expectation($abs(#martingale_def)^2$). $

        #let difference_in_sum(i: $i$) = $Y^#i$
        #let difference_in_sum_def(i: $i$) = $#network_contributions_limit(i: i) - #expectation(network_contributions_limit(i: i))$
        Pour clarifier les calculs, notons également
        $ #difference_in_sum() = #difference_in_sum_def(). $

        En utilisant le carré de la somme, il vient :
        $ #expectation(square_martingale) = #expectation($abs(sum_(j=1)^N #difference_in_sum(i: $j$))^2$) = #expectation($sum_(j=1)^N sum_(k=1)^N (#difference_in_sum(i: $j$))(#difference_in_sum(i: $k$))$). $

        En séparant les termes carrés des termes rectangles, nous obtenons :
        $ #expectation(square_martingale) = #expectation($sum_(j=1)^N (#difference_in_sum(i: $j$))^2$) +
        #expectation($2 sum_(1<=k<j<=N) (#difference_in_sum(i: $j$))(#difference_in_sum(i: $k$))$). $
        Écrit autrement :
        $ #expectation(square_martingale) = sum_(j = 1)^N #variance($#difference_in_sum(i: $j$)$) +
        2 sum_(1<=k<j<=N) #covariance(difference_in_sum(i: $j$), difference_in_sum(i: $k$)). $

        Or, comme nous travaillons dans le cadre champ moyen, les neurones sont des copies indépendantes les uns des autres. Ainsi $#covariance(difference_in_sum(i: $j$), difference_in_sum(i: $k$)) = 0$. Nous obtenons donc :
        $ #expectation(square_martingale) = N #variance(difference_in_sum()) = N #variance(difference_in_sum_def()). $

        Comme $#network_contributions_limit() in {0, 1}$, alors $0 <= bb(E)[#network_contributions_limit()] <= 1$ et donc
        $ 0 <= #difference_in_sum_def() <= 1. $
        Cela nous permet d'écrire la majoration suivante :
        $ #variance(difference_in_sum_def()) <= 1/4, $
        puis d'écrire
        $ #expectation(square_martingale) <= N / 4. $
        Pour finir, nous pouvons dire que
        $ sqrt(#expectation(square_martingale)) <= sqrt(N / 4) $
        et enfin conclure la preuve en réutilisant @majoration_martingale_jensen_concave :
        $ #expectation_martingale <= sqrt(N) / 2. $
    ]
    On reprend @majoration_distance_potential_3, avec la @proposition_majoration_martingale, pour écrire :
    #numbered_equation(
        $ bb(E)[f|#no_spike_event] <= #distance_potential() + bb(E)abs(#network_contributions() - #network_contributions_limit()) + 1/(2 sqrt(N)). $,
        <majoration_distance_potential_4>
    )

    Pour conclure la majoration de $bb(E)[f|#no_spike_event]$, il reste uniquement à majorer le terme #esperance_distance_simplification_variables.

    #proposition()[
        $ #esperance_distance_simplification_variables <= (L + 1) #distance_activation(). $
    ] <proposition_majoration_esperance_distance_simplification_variables>
    #proof()[
        Commençons par réécrire #esperance_distance_simplification_variables en utilisant les trois événements #simultaneous_spikes_event, #alone_spike_event et #no_spike_event mais cette fois appliqués au neurone $j$.\
        Pour alléger l'écriture, notons également $g = abs(#activation(i: $j$)#spiking_indicator(i: $j$) - #activation_limit(i: $j$)#spiking_indicator_limit(i: $j$))$.
    
        Écrivons grâce à ces événements :
        #numbered_equation($ #proba(simultaneous_spikes_event)#expectation_conditional($g$, simultaneous_spikes_event) + #proba(alone_spike_event)#expectation_conditional($g$, alone_spike_event) + #proba(no_spike_event)#expectation_conditional($g$, no_spike_event), $,
        <decomposition_esperance_distance_simplification_variables>
        )
        puis observons les effets de chacun sur $g$.

        - Si l'événement #simultaneous_spikes_event est vérifié, alors les indicatrices de spike valent toutes les deux un ($#spiking_indicator(i: $j$) = #spiking_indicator_limit(i: $j$) = 1$), ce qui nous donne :
            $ #expectation_conditional($g$, simultaneous_spikes_event) = #expectation_absolute($#activation(i: $j$) - #activation_limit(i: $j$)$) = #distance_activation(i: $j$). $
        
        - Si l'événement #alone_spike_event est vérifié, alors une des indicatrices de spike vaut zéro et l'autre un. Il reste donc dans #expectation_conditional($g$, alone_spike_event) :
            $ #expectation_conditional($g$, alone_spike_event) = cases(#expectation_absolute(activation(i: $j$)), #expectation_absolute(activation_limit(i: $j$))) <= 1 "dans tous les cas". $

        - Si l'événement #no_spike_event est vérifié, alors les indicatrices de spike valent toutes les deux zéro, aboutissant à :
            $ #expectation_conditional($g$, no_spike_event) = 0. $

        Reprenons à présent @decomposition_esperance_distance_simplification_variables :
        #numbered_equation(
            $ #esperance_distance_simplification_variables = bb(P)(#simultaneous_spikes_event)#distance_activation(i : $j$) + #proba(alone_spike_event). $,
            <decomposition_esperance_distance_simplification_variables_2>
        )
        
        En utilisant @majoration_probability_alone_spike_event pour majorer #proba(alone_spike_event) et en majorant #proba(simultaneous_spikes_event) par $1$, nous transformons @decomposition_esperance_distance_simplification_variables_2 :
        $ #esperance_distance_simplification_variables <= (L + 1) #distance_activation(), $
        ce qui conclut la preuve.
    ]

    Enfin, en reprenant @majoration_distance_potential_4 avec la @proposition_majoration_esperance_distance_simplification_variables, nous obtenons :
    #numbered_equation(
        $ #expectation_conditional($f$, no_spike_event) <= #distance_potential() + (L+1)#distance_activation() + 1 / (2sqrt(N)). $,
        <majoration_distance_potential_knowing_no_spike_event_final>
    )

    Ultimement, pour écrire la majoration définitive de #distance_potential(t: $t+1$), nous pouvons repartir de @majoration_distance_potential_2 et utiliser @majoration_distance_potential_knowing_no_spike_event_final pour écrire :
    $ #distance_potential(t: $t+1$) &<= L(#max_potential + 1)#distance_activation() + #distance_potential() + (L+1)#distance_activation() + 1 / (2sqrt(N)),\
    #distance_potential(t: $t+1$) &<= #distance_potential() + (L(#max_potential + 2) + 1)#distance_activation() + 1 / (2sqrt(N)), $
    soit :
    #numbered_equation(
        $ #distance_potential(t: $t+1$) &<= (L(#max_potential + 1) + 1) #distance_globale() + 1/(2sqrt(N)). $,
        <majoration_distance_potential_finale>
    )

    Si nous combinons la première pièce du puzzle @majoration_distance_globale_1 avec la seconde @majoration_distance_potential_finale, nous obtenons enfin,
    $ #distance_globale(t: $t+1$) &<= L(#max_potential + 1) + 1)#distance_globale() + 1/(2 sqrt(N)) + (1 + #spiking_steepness/2 + #deactivation_probability)#distance_activation(),\
    &<= C #distance_globale() + 1/(2 sqrt(N)), $
    avec $C$ la constante suivante : $C = max(L(#max_potential + 1) + 1, 1 + L + #deactivation_probability)$.

    Rappellons-nous que les processus sont initialisés de la même façon, ce qui signifique que $#distance_globale(t: $0$) = 0$.\
    Ainsi, en $t=1$ : 
    $ #distance_globale(t: $1$) <= 1/(2 sqrt(N)). $
    Poursuivant l'itération, nous avons :
    $ #distance_globale(t: $2$) &<= C #distance_globale(t: $1$) + 1/(2 sqrt(N)) = (C +1) 1/(2 sqrt(N)) "puis",\
    #distance_globale(t: $3$) &<= C #distance_globale(t: $2$) + 1/(2 sqrt(N)) <= C (C +1) 1/(2 sqrt(N)) + 1/(2 sqrt(N)) = (C^2 + C + 1) 1/(2 sqrt(N)).\ $

    Ce qui nous fait aboutir à :
    $ #distance_globale() <= (sum_(k=0)^(t-1)C^k) 1/(2 sqrt(N)). $

    Or puisque $C$ est une combinaison finie d'opérations sur des paramètres finis de notre modèle, et que nous nous sommes placés sur une fenêtre temporelle finie, alors $sum_(k=0)^(t-1)C^k < oo$.\
    En notant $Kappa = sum_(k=0)^(t-1)C^k$, nous voilà arrivé au bout de la preuve du @theorem_propagation_chaos ! #place(right, $square.stroked$)
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


