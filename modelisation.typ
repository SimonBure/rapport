#import "rules.typ" : *
#import "global_variables.typ": *
// Rule to avoid references error in sub-chapters when compiling local file
// #show: no-ref

== Définition du système
Nous définissons l'état du système de neurones par le processus stochastique suivant
$ X_t = vec(X_t^1, dots.v, X_t^N) $ où $ X_t^i = #neuron(). $

Chaque neurone $i$ est donc représenté par un couple #neuron() où :
- La variable aléatoire $#membrane_potential()$ représente le _potentiel de membrane_ ou _voltage_ au temps $t$. #membrane_potential() évolue sur un "escalier" comprenant $#max_potential + 1$ marches, sur lequel il ne pourra que monter au cours de ses interactions avec les autres neurones. Formellement : $#membrane_potential() in #space_value_potential$.
- La variable aléatoire $#activation()$ représente l'état d'_activation_ de la synapse du neurone au temps $t$, avec $#activation() in #space_value_activation$. Elle permet de rendre compte de la plasticité synaptique à court-terme, mécanisme important dans le phénomène cognitif de la mémoire de travail.
Notons $cal(F_t)$ la filtration associée au processus global.\
Notre modélisation se fait en temps discret. Pour un $T in bb(N)$ tel que $T > 0$, nous définissons :
$ t in #time_interval. $


== Modélisation des sauts du système
En plus des deux variables aléatoires $#membrane_potential()$ et $#activation()$, nous avons besoin d'une variable aléatoire auxiliaire par neurone, que nous noterons #auxiliary_uniform(). Tous les #auxiliary_uniform() sont distribuées _uniformément_ sur $[0, 1]$, qui nous permettra de simuler les processus de spike et de désactivation des neurones. Nous avons donc $ forall t, forall i, space #auxiliary_uniform() ~^("i.i.d.") "Unif"(0, 1). $
Commençons par définir les potentiels d'action, ou "spikes" du système.

=== Spike
Un neurone d'indice $i$ est en capacité d'émettre un spike au temps $t+1$ si et seulement si son potentiel de membrane $#membrane_potential() = #max_potential$.\
Un neurone capable de "spiker", spike avec probabilité $#spiking_probability$ indépendamment de l'état du système et des autres variables aléatoires. Après l'émmission d'un potentiel d'action, le potentiel de membrane du neurone est *remis à zéro* et sa variable d'activation est *remis à un*.\
Pour formaliser ces informations, nous allons introduire la fonction $phi.alt$, qui, à un voltage $v$ donné, associera la *probabilité de spiker* : $ phi.alt : cases(v in #space_value_potential --> [0, 1], #spiking_function(v: $v$) = #spiking_probability bold(1)_(v = #max_potential)). $
Ainsi en utilisant $phi.alt$ et la variable auxiliaire uniforme #auxiliary_uniform() définie plus haut, le neurone $i$ effectuera un spike au temps $t+1$ si et seulement si $ #auxiliary_uniform(t: $t+1$) <= phi.alt(#membrane_potential()). $
Nous appelerons l'_indicatrice de spike_ le terme #spiking_indicator() et à l'inverse _indicatrice d'absence de spike_ le terme #non_spiking_indicator.\

#set math.vec(delim: none)
Lors de l'émission d'un potentiel d'action, le neurone en question va *influencer* le reste du réseau s'il se trouve *activé* au moment du spike. Plus concrètement, un spike se traduit par une *augmentation du potentiel* de tous les autres neurones par $1$. Entre chaque pas de temps, le neurone $i$ reçoit donc les contributions de tous les neurones activés ayant spike entre ces deux temps. Cette contribution totale au potentiel de $i$ s'écrit :
$ sum_vec(j=0, j!=i)^N #activation(i: $j$)#spiking_indicator(i: $j$). $
#set math.vec(delim: "(")

Nous pouvons donc résumer la dynamique du potentiel de membrane du neurone $i$ à travers le temps par l'équation suivante :
#potential_dynamics

=== Désactivation
La variable d'activation des neurones se voit modifiée par deux événements : le *spike* et la *désactivation*. Lorsque le neurone $i$ émet un spike au temps $t+1$, il devient *systématiquement activé*, c'est-à-dire que $#activation(t: $t+1$) = 1$.\
Par contre, lorsqu'il n'émet pas de spike, il peut se *désactiver* au temps $t+1$ avec une certaine probabilité #deactivation_probability ou bien conserver sa variable aléatoire d'activation. S'il se désactive, alors systématiquement, $#activation(t: $t+1$) = 0$.\
En définissant comme cela la dynamique de la variable d'activation, le neurone $i$ se désactivera au temps $t+1$ si et seulement si
$ #spiking_probability <= #auxiliary_uniform(t: $t+1$) <= #spiking_probability + #deactivation_probability. $
Cette définition évite ainsi que les événements de potentiel d'action et de désactivation surviennent en même temps. Nous voyons que nous devons par contre émettre l'hypothèse que 
$ #spiking_probability + #deactivation_probability < 1. $

Nous appellerons l'_indicatrice de désactivation_ le terme #deactivation_indicator.

La dynamique temporelle de la variable d'activation du neurone $i$ suit donc l'équation suivante :
$ #activation(t: $t+1$) = #spiking_indicator() + #non_spiking_indicator #activation() (1 - #deactivation_indicator). $
