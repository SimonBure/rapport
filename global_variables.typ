#let integers = $bb(N)$
#let integers_without_zero = $attach(#integers, tr: *)$
#let reals = $bb(R)$
#let expectation(u) = $bb(E)[#u]$
#let expectation_absolute(variable) = $bb(E)abs(#variable)$
#let expectation_conditional(variable, condition) = expectation($#variable|#condition$)
#let variance(variable) = $"Var"[#variable]$
#let covariance(v1, v2) = $"Cov"[#v1, #v2]$
#let proba(variable) = $bb(P)(#variable)$
#let proba_conditional(variable, condition) = $bb(P)(#variable|#condition)$
#let indicator(event) = $bold(1)_({#event})$
#let dirac(state) = $delta_#state$
#let filtration(t: $t$) = $cal(F)_#t$

#let max_potential = $theta$
#let spiking_probability = $beta$
#let deactivation_probability = $lambda$

#let indexes_interval = ${0, 1, dots, N}$
#let time_interval = ${0, 1, dots, T}$
#let time_window = $[|0, T|]$

#let chain(t: $t$) = $X_#t$
#let chain_limit(t: $t$) = $overline(X)_#t$
#let chain_space = $cal(X)$

#let membrane_potential(t: $t$, i: $i$) = $V_#t^#i$
#let membrane_potential_limit(t: $t$, i: $i$) = $overline(V)_#t^#i$

// Espaces
#let space_potentiel = $cal(V)$
#let space_potentiel_mf = $attach(#space_potentiel, tr: N)$
#let space_potentiel_limite(T: $T$) = $overline(cal(V))_#T$
#let space_value_potential = ${0, 1, dots, #max_potential}$
#let space_value_activation = ${0, 1}$

#let activation(t: $t$, i: $i$) = $A_#t^#i$
#let activation_limit(t: $t$, i: $i$) = $overline(A)_#t^#i$

#let auxiliary_uniform(t: $t$, i: $i$) = $U_#t^#i$

#let neuron(t: $t$, i: $i$) = $(#membrane_potential(t: t, i: i), #activation(t: t, i: i))$
#let neuron_limit(t: $t$, i: $i$) = $(#membrane_potential_limit(t: t, i: i), #activation_limit(t: t, i: i))$

// Indicators
#let spiking_function_raw = $phi.alt$
#let spiking_function(v: membrane_potential()) = $#spiking_function_raw (#v)$
#let spiking_function_limit = $#spiking_function_raw (#membrane_potential_limit())$
#let spiking_function_definition = $#spiking_function_raw (v) = #spiking_probability bold(1)_(v >= #max_potential)$
#let spiking_indicator(t: $t$, i: $i$) = {
  $#indicator($#auxiliary_uniform(t: $#t+1$, i: i) <= #spiking_function(v: membrane_potential(t: t, i: i))$)$
}
#let spiking_indicator_limit(i: $i$) = {
  $#indicator($#auxiliary_uniform(t: $t+1$, i: i) <= #spiking_function(v: membrane_potential_limit(i: i))$)$
}
#let non_spiking_indicator = $#indicator($#auxiliary_uniform(t: $t+1$) > #spiking_function(v: membrane_potential())$)$
#let non_spiking_indicator_limit = $#indicator($#auxiliary_uniform(t: $t+1$) > #spiking_function(v: membrane_potential_limit())$)$
#let deactivation_indicator = $#indicator($#spiking_probability < #auxiliary_uniform(t: $t+1$) < #spiking_probability + #deactivation_probability$)$

// Definitions
#let definition_membrane_potential_limit(t: $t$, i: $i$) = {
  $#non_spiking_indicator_limit (#membrane_potential_limit(t: t, i: i) + bb(E)[#activation_limit(i: $j$) #spiking_indicator_limit(i: $j$)])$
}


#let potential_dynamics = [#set math.vec(delim: none)
  $
    #membrane_potential(t: $t+1$) = #non_spiking_indicator (#membrane_potential() + sum_vec(j=0, j!=i)^N #activation(i: $j$)#spiking_indicator(i: $j$)).
  $
]

// Mesures empiriques
#let mesure_comptage(t: $t$) = $N_#t$
#let compte_neurone(state: $x$, t: $t$, v: $v$, a: $a$) = $#state^N_(#v, #a)$
#let mesure_couche(state: $x$, v: $v$) = compte_neurone(state: state, v: v, a: $dot$)
#let mesure_activation(state: $x$, a: $a$) = compte_neurone(state: state, v: $dot$, a: a)
#let mesure_empirique(t: $t$) = $mu_#t^N$ 

// Champ moyen
#let distance_activation(t: $t$, i: $i$) = $delta_#t^(#i, N)$
#let distance_potential(t: $t$) = $d_#t^(i, N)$
#let distance_globale(t: $t$) = $D_#t^(i, N)$

#let network_contributions(t: $t$, i: $i$) = $#spiking_indicator(t: t, i: i)#activation(t: t, i: i)$
#let network_contributions_limit(t: $t$, i: $i$) = $#spiking_indicator_limit(i: i)#activation_limit(t: t, i: i)$
#let non_spiking_indicator_limit = $#indicator($#auxiliary_uniform(t: $t+1$) > #spiking_function(v: membrane_potential_limit())$)$

#let unknown_expectation(t: $t$) = $gamma_#t$
#let unknown_expectation_inf = $#unknown_expectation(t: $$)^*$
#let max_potential_limit = $K$
#let max_potential_limit_val = $ceil(#max_potential/#unknown_expectation_inf)$

#let time_inf = $t^*$

#let space_chain_limit = overline(chain_space)


// Variables pour la partie sur la mesure stationnaire
#let regenering_state = $(0, 1)$
#let time_before_regen = $T_#regenering_state$

#let indicator_chain(state: $(v, 1)$) = $bold(1)_{X_t= #state}$
#let time_spent_in_state(state: $(v, 1)$) = $sum_(t=1)^(#time_before_regen) #indicator_chain(state: state)$
#let mean_time_spent_in_state(state: $(v, 1)$) = $bb(E)[#time_spent_in_state(state: state)]$

#let mean_time_before_regen = $bb(E)_(#regenering_state)[T_(#regenering_state)]$
#let value_mean_time_before_regen = $#max_potential_limit + 1/#spiking_probability$

#let mesure_stationnaire(state: $(v, a)$) = $pi^#max_potential_limit (x = #state)$
