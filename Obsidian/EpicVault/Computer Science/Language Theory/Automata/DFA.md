# DFA
### Deterministic Finite Automata
$$A = (Q, \Sigma, \delta, q_0, F)$$
- Q is a set of states
- $\Sigma$ is a set of input symbols called *input alphabet*
- $\delta : Q \texttimes F \rightarrow Q$, *transition function*
- $q_0 \in Q$, initial state
- $F \subseteq Q$, set of final state(s).

### How it works
A DFA either does or does not accept a string, it accepts iff it is in a final state after going through some input.

### Transitions
$\delta(q_0, a) = q_1$

#### Can be represented by transition graphs
Vertices = states, edges = transitions.

#### Languages
The set of all strings accepted by some DFA is called a language. Same with [[NFA]] and [[Regular Expressions]].
#computer-science #language-theory 