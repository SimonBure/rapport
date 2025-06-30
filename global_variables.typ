#let integers = $bb(N)$
#let integers_without_zero = $attach(#integers, tr: *)$
#let reals = $bb(R)$

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
#let space_value_potential = ${0, 1, dots, #max_potential}$
#let space_value_activation = ${0, 1}$

#let activation(t: $t$, i: $i$) = $A_#t^#i$
#let activation_limit(t: $t$, i: $i$) = $overline(A)_#t^#i$

#let auxiliary_uniform(t: $t$, i: $i$) = $U_#t^#i$

#let neuron(t: $t$, i: $i$) = $(#membrane_potential(t: t, i: i), #activation(t: t, i: i))$
#let neuron_limit(t: $t$, i: $i$) = $(#membrane_potential_limit(t: t, i: i), #activation_limit(t: t, i: i))$

// Indicators
#let spiking_function(v: membrane_potential()) = $phi.alt(#v)$
#let spiking_function_limit = $phi.alt(#membrane_potential_limit())$
#let spiking_function_definition = $phi.alt(v) = #spiking_probability bold(1)_(v >= #max_potential)$
#let spiking_indicator(i: $i$) = $bold(1)_(#auxiliary_uniform(t: $t+1$, i: i) <= #spiking_function(v: membrane_potential(i: i)))$
#let spiking_indicator_limit(i: $i$) = $bold(1)_(#auxiliary_uniform(t: $t+1$, i: i) <= #spiking_function(v: membrane_potential_limit(i: i)))$
#let non_spiking_indicator = $bold(1)_(#auxiliary_uniform(t: $t+1$) > #spiking_function(v: membrane_potential()))$
#let non_spiking_indicator_limit = $bold(1)_(#auxiliary_uniform(t: $t+1$) > #spiking_function(v: membrane_potential_limit()))$
#let deactivation_indicator = $bold(1)_(#spiking_probability < #auxiliary_uniform(t: $t+1$) < #spiking_probability + #deactivation_probability)$

// Definitions
#let definition_membrane_potential_limit(t: $t$, i: $i$) = $#non_spiking_indicator_limit (#membrane_potential_limit(t: t, i: i) + bb(E)[#activation_limit(i: $j$) #spiking_indicator_limit(i: $j$)])$


#let potential_dynamics = [#set math.vec(delim: none)
  $ #membrane_potential(t: $t+1$) = #non_spiking_indicator (#membrane_potential() + sum_vec(j=0, j!=i)^N #activation(i: $j$)#spiking_indicator(i: $j$)). $
]