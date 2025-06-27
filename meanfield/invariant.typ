#import "../global_variables.typ" : *
#import "../rules.typ" : *

#let regenering_state = $(0, 1)$
#let time_before_regen = $T_#regenering_state$

#let indicator_chain(state: $(v, 1)$) = $bold(1)_{X_k= #state}$
#let time_spent_in_state(state: $(v, 1)$) = $sum_(k=1)^(#time_before_regen) #indicator_chain(state: state)$
#let mean_time_spent_in_state(state: $(v, 1)$) = $bb(E)[#time_spent_in_state(state: state)]$

#let mean_time_before_regen = $bb(E)_(#regenering_state)[T_(#regenering_state)]$
#let value_mean_time_before_regen = $K + 1/#spiking_probability$

L'objectif de cette section est calculer la mesure invariante, ou stationnaire, associée à la chaîne de Markov limite $#chain_limit() = #neuron_limit()$ étudiée dans la partie précédente.


Pour la chaîne de Markov $#chain() = #neuron()$, l'état #regenering_state est un *état de régénération*, pour lequel la chaîne perd tout lien avec le passé.


Introduisons maintenant $#time_before_regen$, le temps, aléatoire, que met #chain() pour arriver à l'état #regenering_state en partant de celui-ci. Formellement :
$ #time_before_regen = inf{t > 0 : #chain() = #regenering_state "sachant que" #chain(t: $0$) = #regenering_state}. $

Pour calculer #mean_time_before_regen, il suffit de remarquer que la chaîne #chain(), pour retourner en #regenering_state en partant de #regenering_state va nécessairement d'abord effectuer $K$ sauts successifs, de taille $gamma$ chacun. Ensuite, elle devra attendre un temps aléatoire avant d'émettre un potentiel d'action. Ce temps aléatoire suit une loi géométrique de paramètre #spiking_probability.\
Alors,
#numbered_equation($ #mean_time_before_regen = #value_mean_time_before_regen. $ , <valeur_temps_avant_regen>)

Cela nous permet de définir la *mesure stationnaire* de notre processus limite de la façon suivante. Prenons $v in #space_value_potential$ et $a in #space_value_activation$ :
#numbered_equation(
  $ pi(v, a) = 1 / #mean_time_before_regen #mean_time_spent_in_state(state: $(v, a)$). $, <definition_mesure_stationnaire>
)
*TO-DO : Définir d'où vient la définition de la mesure stationnaire*

La variable aléatoire #time_spent_in_state() représente le *temps passsé* dans l'état $(v, 1)$ par la chaîne.\

Son calcul, et celui de #mean_time_spent_in_state() va dépendre des valeurs prises par $v$.

== Cas où $v < K gamma$
#let probability_no_deactivation_before_v = $(1 - #deactivation_probability)^v$
Dans le cas présent, #time_spent_in_state() vaut exactement un si le neurone ne subit aucune désactivation avant la couche $v$, ce qui arrive avec probabilité #probability_no_deactivation_before_v. S'il se désactive avant $v$, alors #time_spent_in_state() est nulle.\
Ainsi, pour $v < K gamma$,
#numbered_equation($ #mean_time_spent_in_state() = #probability_no_deactivation_before_v. $, <valeur_temps_moyen_passe_etat_v_1>)

#let probability_deactivation_before_v = $1 - #probability_no_deactivation_before_v$
De façon similaire, pour $a = 0$, #time_spent_in_state(state: $(v, 0)$) vaut un si le neurone subit une désactivation avant la couche $v$, ce qui arrive avec probabilité #probability_deactivation_before_v. Sinon, le temps passé dans l'état $(v, 0)$ est nul. D'où,
#numbered_equation($ #mean_time_spent_in_state(state: $(v, 0)$) = #probability_deactivation_before_v. $, <valeur_temps_moyen_passe_etat_v_0>)

Finalelement, nous avons
$ forall v < K gamma,space  pi(v, 1) = #probability_no_deactivation_before_v / #value_mean_time_before_regen, $
ainsi que
$ pi(v, 0) = #probability_deactivation_before_v / (#value_mean_time_before_regen). $

== Cas où $v = K gamma$
#let time_before_spike = $T_#spiking_probability$
#let time_before_deactivation = $T_#deactivation_probability$
Ici, le neurone peut, avec probabilité positive, passer un temps plus long qu'un pas de temps dans l'état $(K gamma, 1)$. Le neurone quittera l'état $(K gamma, 1)$ lors de l'émission d'un spike, ou après une désactivation.\
Si nous notons #time_before_spike le temps aléatoire avant l'émission d'un spike et #time_before_deactivation, le temps aléatoire avant la désactivation du neurone, nous pouvons alors écrire que :
$ #mean_time_spent_in_state(state: $(K gamma, 1)$) &= bb(E)[min(#time_before_spike, #time_before_deactivation)]. $

Comme #time_before_spike suit une loi géométrique de paramètre #spiking_probability et #time_before_deactivation suit une loi géométrique de paramètre #deactivation_probability, nous avons :
#numbered_equation($ #mean_time_spent_in_state(state: $(K gamma, 1)$) = 1 / (#spiking_probability + #deactivation_probability). $, <valeur_temps_moyen_passe_etat_K_1>)

Avec @valeur_temps_avant_regen et @valeur_temps_moyen_passe_etat_K_1, nous aboutissons donc à la mesure stationnaire suivante pour l'état $(K gamma, 1)$ :
$ pi(K gamma, 1) = 1 / ((#value_mean_time_before_regen)(#spiking_probability + #deactivation_probability)). $

Pour l'état $(K gamma, 0)$, étant donné que $pi$ est une mesure de probabilité, nous pouvons écrire :
#numbered_equation($ pi(K gamma, 0) = 1 - (sum_(a=0)^1 sum_(v=0)^((K-1) gamma) pi(v, a) + pi(K gamma, 1)). $, <mesure_proba_etat_K_0>)

