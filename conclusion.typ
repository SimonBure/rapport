#import "global_variables.typ": *

La mémoire de travail occupe une position centrale dans l'architecture cognitive humaine, servant de pont entre perception, raisonnement et action. Son importance transcende le domaine des neurosciences : elle inspire les mécanismes d'attention des systèmes d'intelligence artificielle modernes, définit les contours de notre conscience et se révèle indispensable pour toute tâche nécessitant de l'intelligence.

Au cours de ce mémoire nous avons :
+ Développé un modèle stochastique en temps discret de neurones en interaction.
+ Établi et prouvé les propriétés mathématiques nécessaires pour obtenir une activité neuronale persistante, qui constitue la signature neurobiologique fondamentale pour la mémoire court-terme.
+ Posé un modèle limite en champ moyen, avec preuve de convergence. C'est sur ce modèle limite qu'est ensuite étudié la mémoire de travail.
+ Analysé la mesure stationnaire associée à ce modèle limite, avec preuve d'existence et analyse des équilibres symbolisant les régimes persistents où le système serait capable de retenir des informations.

Pour enfin clore ce mémoire, nous imaginons plusieurs axes d'extensions à ce travail.
+ Le *passage au temps continu* (cadre de travail de @andreQuasiStationaryApproachMetastability2025) afin de développer notre définition de la mémoire de travail via modèle champ moyen et mesure stationnaire dans un cadre temporel plus réaliste biologiquement.
+ L'introduction de *compartiments excitateurs et inhibiteurs* (impact d'un spike sur le voltage des autres neurones différents selon la population d'appartenance) pour peut-être voir émerger des dynamiques intéressantes avec des boucles sophistiquées.
+ Complexifier les *mécanismes de facilitation* au-delà de la dichotomie actif/inactif. L'émission d'un potentiel pourrait temporairement abaisser ou augmenter le seuil de spiking #max_potential pour imiter les mécanismes biologiques bien établis de _short-term potentiation_.
+ Enrichir le modèle afin de capturer les mécanismes de *dynamical coding* proposés par @stroudOptimalInformationLoading2023, où l'activité neuronale passe par des phases distinctes (bursts initiaux, activité persistante) impliquant des populations neuronales spécialisées (comme dans l'article de @murrayWorkingMemoryDecisionMaking2017).
+ L'extension *multi-items* en élargissant l'espace d'états vers $X_t^i = (V_t^i, A_t^i, "Item"_t^i)$. Cette approche d'aborder le problème de compétition entre éléments mémoriels (capacité limitée de la mémoire de travail ; l'oubli sélectif). Cette direction pourrait peut-être éclairer la question évolutive suivante : pourquoi l'évolution a-t-elle conservé une version si contrainte de la mémoire de travail ?
