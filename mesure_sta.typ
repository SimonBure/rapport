#import "rules.typ": *
#import "global_variables.typ": *
// Rule to avoid references error in sub-chapters when compiling local file
#show: no-ref

// Display settings for theorems and proofs
#show: thmrules.with(qed-symbol: $square$)

// Variables for this section
#let regenering_state = $(0, 1)$
#let time_before_regen = $T_#regenering_state$

#let indicator_chain(state: $(v, 1)$) = $bold(1)_{X_k= #state}$
#let time_spent_in_state(state: $(v, 1)$) = $sum_(t=1)^(#time_before_regen) #indicator_chain(state: state)$
#let mean_time_spent_in_state(state: $(v, 1)$) = $bb(E)[#time_spent_in_state(state: state)]$

#let mean_time_before_regen = $bb(E)_(#regenering_state)[T_(#regenering_state)]$
#let value_mean_time_before_regen = $#max_potential_limit + 1/#spiking_probability$

#let mesure_stationnaire(state: $(v, a)$) = $pi^#max_potential_limit (#state)$

La mémoire de travail est un maintien actif d'une information via l'activité persistente des neurones. Si l'activité est perturbée ou si l'information n'est plus nécessaire, elle est oubliée, libérant les neurones. D'un côté, notre modèle inclut un mécanisme de désactivation (paramètre #deactivation_probability) qui pousse la chaîne #chain_limit() vers l'extinction. De l'autre, le mécanisme de facilitation synaptique (spike → activation) tend à maintenir l'activité. Des questions viennent ainsi naturellement : Quelle dynamique l'emporte ? Existe-il un équilibre ? Dans quelles conditions ?

Notre modèle limite de champ moyen décrit la dynamique temporelle des neurones, mais nous voyons que pour comprendre la mémoire de travail, il faut pouvoir décrire la dynamique à long-terme de ces neurones et voir les comportements typiques qui en émergent. Le comportement qui nous intéresse particulièrement est celui où le système peut soutenir une activité persistente. D'un point de vue mathématique, cela peut s'aborder comme un questionnement sur l'existence d'*états d'équilibres actifs* (autre que les états d'absorption) où le système limite pourrait rester indéfiniment (et donc émettre des potentiels d'action indéfiniment).

La notion d'analyse de l'activité à long-terme (à entendre dans un sens mathématique) de notre chaîne de Markov nous amène à devoir considérer la notion de *mesure stationnaire* pour notre chaîne de Markov.

Dans cette optique, cette section répondra à plusieurs objectifs :
+ Introduire et définir la mesure invariante, ou stationnaire pour notre chaîne de Markov $#chain_limit() = #neuron_limit()$.
+ Prouver son existence à l'aide de résultats classiques. 
+ La calculer pour tous les états du système.
+ Étudier l'existence de ses équilibres et en faire émerger une condition sur les paramètres du modèle.

=== Définition et existence
De façon générale pour notre modèle, la mesure stationnaire est une *mesure de probabilité* descriptive de l'état "moyen" de la chaîne de Markov #chain_limit() après un temps long. Dans notre contexte, elle représente la *proportion de temps* qu'un neurone passe dans chaque état $(v, a)$. Il est aussi possible de la voir comme la *proportion de neurones* dans chaque état $(v, a)$.

Pour prouver l'*existence* de cette mesure et garantir son *unicité*, appuyons-nous sur les résultats classiques en probabilités. Si nous pouvons montrer que notre chaîne de Markov limite #chain_limit() est irréductible et apériodique sur son espace d'états fini $#space_potentiel_mf times {0, 1}$, nous aurons montré qu'une unique mesure stationnaire existe.



Il existe plusieurs résultats très classiques pour définir la mesure stationnaire.
Cela nous permet de définir la *mesure stationnaire* de notre processus limite de la façon suivante. Prenons $v in #space_potentiel_limite()$ et $a in #space_value_activation$ :
$ #mesure_stationnaire() = #mean_time_spent_in_state(state: $(v, a)$) / #mean_time_before_regen . $
#todo("Justifier définition mesure stationnaire par un résulat théorique classique")

La variable aléatoire #time_spent_in_state() représente le *temps passsé* dans l'état $(v, 1)$ par la chaîne.\

Nous avons besoin des concepts d'état régénérant et de temps moyen passé dans l'état.

=== État régénérant
Pour la chaîne de Markov $#chain() = #neuron()$, l'état #regenering_state est un *état de régénération*, pour lequel la chaîne perd tout lien avec le passé.

Introduisons maintenant $#time_before_regen$, le temps, *aléatoire*, que met #chain() pour arriver à l'état #regenering_state en partant de celui-ci. Formellement :
$ #time_before_regen = inf{t > 0 : #chain() = #regenering_state "sachant que" #chain(t: $0$) = #regenering_state}. $

Pour calculer #mean_time_before_regen, il suffit de remarquer que la chaîne #chain(), pour retourner en #regenering_state en partant de #regenering_state va nécessairement d'abord effectuer #max_potential_limit sauts successifs, de taille #unknown_expectation_inf chacun. Ensuite, elle devra attendre un temps aléatoire avant d'émettre un potentiel d'action. Ce temps aléatoire suit une loi géométrique de paramètre #spiking_probability.\
Alors,
#numbered_equation(
    $ #mean_time_before_regen = #value_mean_time_before_regen. $,
    <valeur_temps_avant_regen>
)

// Pour plus de clarté, notons à partir de maintenant $#max_potential_limit = K$.
// #let max_potential_limit = $K$



Son calcul, et celui de #mean_time_spent_in_state() va dépendre des valeurs prises par $v$.

=== Cas où $v < #max_potential_limit #unknown_expectation_inf$
#let probability_no_deactivation_before_v = $(1 - #deactivation_probability)^v$
Dans le cas présent, #time_spent_in_state() vaut exactement un si le neurone ne subit aucune désactivation avant la couche $v$, ce qui arrive avec probabilité #probability_no_deactivation_before_v. S'il se désactive avant $v$, alors #time_spent_in_state() est nulle.\
Ainsi, pour $v < #max_potential_limit #unknown_expectation_inf$,
$ #mean_time_spent_in_state() = #probability_no_deactivation_before_v. $

#let probability_deactivation_before_v = $1 - #probability_no_deactivation_before_v$
De façon similaire, pour $a = 0$, #time_spent_in_state(state: $(v, 0)$) vaut un si le neurone subit une désactivation avant la couche $v$, ce qui arrive avec probabilité #probability_deactivation_before_v. Sinon, le temps passé dans l'état $(v, 0)$ est nul. D'où,
$ #mean_time_spent_in_state(state: $(v, 0)$) = #probability_deactivation_before_v. $

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
Mesure stationnaire (k*gamma, 0 ou 1) = proportion du temps qu'un neurone passe dans un état donné (k*gamma, 1) 
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
Premièrement, pour $#unknown -> 0$, l'@equation_equilibre admet une solution, triviale, correspondant à l'absorption du système en zéro. Cette absorption correspond à l'état d'oubli de l'élément mémoriel.

Cependant, nous sommes à la recherche d'équilibres non nuls, qui pourraient correspondre à (...).
#todo([Interpréter solution des équilibres])

Grâce à @allure_f_gamma, et à @equation_equilibre, nous pouvons voir que $f$ est une fonction *continue par morceau* et *croissante*.

Énonçons la proposition @existence_equilibres, nous donnant une condition suffisante pour assurer l'existence d'un équilibre non trivial à @equation_equilibre.

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
    concluant la preuve. Le tout est illustré sur la @f_gamma_un_equilibre.
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


#check-labels()
