# NPDA, Non-deterministic Push-down Automata

## Definition
NPDA is a septuple.
$$M = (Q, \Sigma, \Gamma, \delta, q_0, z, F)$$
- $Q$ is a finite set of states.
- $\Sigma$ is the input alphabet.
- $\Gamma$ is the stack alphabet.
- $\delta$ is the transition function. $$\delta : Q \texttimes (\Sigma \cup \{\lambda\}) \texttimes \Gamma \rightarrow finite\ subsets\ of\ Q\texttimes \Gamma ^*$$
- $q_0$ is the initial state, $q_0 \in Q$.
- $z$ is the first symbol of the stack. $z \in \Gamma$
- $F$ is the set of final states. $F \subseteq Q$

## Instantaneous descriptions
$(q_1, aw, bz) \vdash (q_2, w, az)$
is possible iff $(q_2, a) \in \delta (q_1, a, b)$

#### Related
[[Pushdown Automata]] [[Context-free Languages]]

 #language-theory #computer-science