#import "rules.typ": *
// Rule to avoid references error in sub-chapters  when compiling local file
// #show: no-ref

La mémoire de travail constitue l'un des piliers fondamentaux de la cognition humaine. Cette capacité à maintenir et manipuler temporairement l'information permet la prise de décision complexe @murrayWorkingMemoryDecisionMaking2017, sous-tend l'apprentissage et la formation de la mémoire à long terme, et s'avère indispensable à toute tâche nécessitant de l'intelligence.

== Caractéristiques de la mémoire de travail
Cette fonction cognitive présente des plusieurs caractéristiques remarquables : une fenêtre temporelle limitée (de quelques secondes à quelques minutes) @andreQuasiStationaryApproachMetastability2025, une vulnérabilité aux distractions @andreQuasiStationaryApproachMetastability2025, et une capacité limitée. Alors que Miller avait initialement proposé que la mémoire de travail humaine pouvait stocker "sept plus ou moins deux" éléments @millerMagicalNumberSeven1994, des études plus récentes suggèrent que cette capacité serait encore plus contrainte, se limitant à trois items différents en simultané @lecompteSevenMinusTwo1999.

== État de l'art de la modélisation
Ces observations comportementales ont motivé des décennies de recherche sur les mécanismes neuronaux sous-jacents. Trois paradigmes principaux ont émergé pour expliquer le maintien temporaire d'information.\
Le mécanisme de *persistent spiking*, historiquement identifié par @fusterNeuronActivityRelated1971 dans le cortex préfrontal de primates, repose sur une activité neuronale soutenue en continue durant la période de rétention de l'information.\
Le modèle *activity-silent* @mongilloSynapticTheoryWorking2008 propose alternativement un stockage "silencieux" via des modifications synaptiques temporaires, exploitant la potentiation à court-terme pour encoder l'information sans activité continue.\
Plus récemment, le paradigme du *dynamical coding* @stroudOptimalInformationLoading2023 révèle une image plus complexe où l'information transite par différents régimes d'activité : phases de décharge en bouffées (*bursts*) succédant à des périodes d'activité persistante, avec des populations neuronales distinctes impliquées dans chaque phase. Le dynamical coding serait une façon optimale de stocker de l'information, retrouvée empiriquement lorsque des réseaux de neurones ont été entraînés pour optimiser le stockage d'informations.

Ces découvertes empiriques ont donné naissance à diverses approches de modélisation. Les *modèles déterministes* exploitent la théorie des attracteurs dynamiques, depuis les réseaux de Hopfield  @ramsauerHopfieldNetworksAll2021 optimisés pour le stockage d'items mémoriels, jusqu'aux modèles biophysiques détaillés de Wang et collaborateurs @wangSynapticReverberationUnderlying2001.\
Parallèlement, les *approches stochastiques* approchent le problème différemment, des travaux pionniers d'Amit et Brunel @amitModelGlobalSpontaneous1997 sur les réseaux bruités aux modèles contemporains combinant apprentissage et mémoire @yangSAMUnifiedSelfAdaptive2022 ainsi que le papier de Pouzat et Andre, qui sera la référence pour le travail qui sera effectué dans ce mémoire @andreQuasiStationaryApproachMetastability2025.\
Ces efforts ont été synthétisés dans plusieurs revues influentes @durstewitzNeurocomputationalModelsWorking2000 @barakWorkingModelsWorking2014 @murrayWorkingMemoryDecisionMaking2017 @oreillyComputationalNeuroscienceModels2023.

== Limitations actuelles et apports de ce mémoire
Malgré cette richesse conceptuelle, les approches de modélisation biophysiques actuelles souffrent de limitations. La plupart demeurent essentiellement qualitatives, visant à reproduire des comportements empiriques sans fournir de cadre quantitatif rigoureux. Ces modèles "proof-of-concept" manquent de conditions d'existence explicites pour les régimes de mémoire et ne permettent pas de prédictions testables sur les paramètres biologiques critiques.

Ce mémoire vise à combler cette lacune en proposant une modélisation mathématiquement rigoureuse et minimale des dynamiques neuronales sous-tendant la mémoire de court-terme, en se concentrant sur l'*activité neuronale persistante* et son interaction avec la *facilitation synaptique*.\
Pour comprendre comment ce système peut soutenir la mémoire de court-terme, nous allons devoir expliquer au cours de ce mémoire :
+ Comment les neurones peuvent maintenir une activité de spikes sur du long-terme ?
+ Quelles sont les conditions permettant à cette activité d'émerger ?
Au niveau modélisation, notre travail s'appuie largement sur celui développé dans @andreQuasiStationaryApproachMetastability2025.

Nous dépassons les modèles biophysiques traditionnels en proposant un modèle simple mais quantitativement robuste (@section_modele), basé sur la théorie markovienne (@section_markov) et avec des preuves de toutes les propriétés permettant l'émergence de la mémoire court-terme. Puis nous faisons un pas plus loin en amenant un modèle limite, basé sur un développement de la limite en champ moyen (@section_mf) et enfin en utilisant la mesure stationaire (@section_mesure_sta) pour proposer une nouvelle définition de la mémoire de travail ainsi qu'une condition facilement testable sur les paramètres biologiques pour qu'existe ce régime où les neurones peuvent soutenir une activité persistante.

Ce travail fournit plusieurs apports par rapport à @andreQuasiStationaryApproachMetastability2025. Premièrement, notre formulation d'un modèle en temps discret (par rapport à leur modèle en temps continu) se place au plus proche des données électroencéphalographiques, dont les relevés sont ponctuelles. Cela permet d'avoir un modèle testable plus facilement. De plus, l'approche temps discret modifie la structure du processus et nécessite un développement théorique nouveau.\
Deuxièmement, là où Pouzat et Andre se focalisaient sur l'étude de processus fini en étudiant sa métastabilité au travers de la distribution quasi-stationnaire, nous proposons une autre définition de la mémoire de travail. Celle-ci reposant plutôt sur un modèle limite type champ moyen et la mesure stationnaire associée. Nous établissons rigoureusement ce passage à la limite de champ moyen.\
Troisièmement, nous proposons une caractérisation de la mémoire via la mesure stationnaire du modèle limite, approche plus tractable que les distributions quasi-stationnaires du système fini et offrant des conditions explicites sur les paramètres biologiques pour l'émergence de régimes où l'information peut être retenue par le réseau.

En plus de ce travail de modélisation, des codes pour simuler le modèle ont été écrit et rendu disponibles sur le dépôt #link("https://github.com/SimonBure/discrete-spiking-neurons", "suivant").

