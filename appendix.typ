= Modèle en temps continu et équation différentielle stochastique associée
$ d X_t^i &= integral_bb(R)_+ bold(1)_(z<=beta) Delta_a (X^i_t) pi^i (d t, d z) + integral_bb(R)_+ bold(1)_(beta <= z <= beta + lambda)F_(t_-)^i vec(0, -1)pi^i (d t, d z)  \
&+ sum_(j!=i) integral_bb(R)_+ bold(1)_(z<=beta) F_(t_-)^j bold(1)_(U^j_(t_-)= theta) Delta_"ex"(X^i_t_-) pi^j (d t, d z). $
Avec les sauts associés à un spike du neurone lui-même, dit *autonome* :
$ Delta_a (x) = bold(1)_(u = theta)[vec(-u, 1)bold(1)_(f=0) + vec(-u, 0)f],space"pour tout " x = vec(u, f), $
et les sauts déclenchés par un autre neurone *extérieur* : $ Delta_"ex" (x) = vec(u+1 and theta, f),space"pour tout " x = vec(u, f). $
$pi^i$ mesures de Poisson.

$ abs(Y_(t+1)^j - overline(Y)_(t+1)) &= abs(A_t^j  bold(1)_(U_(t+1)^j <= phi.alt(V_r^j)) - overline(A)_t^j  bold(1)_(U_(t+1)^j <= phi.alt(overline(V)_r^j)))\
&= abs(bold(1)_(U_(t+1)^j <= phi.alt(V_r^j)) - bold(1)_(U_(t+1)^j <= phi.alt(overline(V)_r^j)))\
&= bold(1)_(phi.alt(V_r^j) and phi.alt(overline(V)_r^j) <= U_(t+1)^j <= phi.alt(V_r^j) or phi.alt(overline(V)_r^j)).
$