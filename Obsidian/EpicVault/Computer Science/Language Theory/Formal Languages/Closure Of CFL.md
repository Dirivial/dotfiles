# Some proofs for closure of CFL

## Union
Two grammars on CNF $G_1$ and $G_2$. We want to construct $G_{\cup}$.

$N$ of $G_{\cup}$:
$N = N_1 \cup N_2 \cup {S_{\cup}}$

$T$ of $G_{\cup}$:
$T = T_1 \cup T_2$

$P$ of $G_{\cup}$:
$P = P_1 \cup P_2 \cup \{(S_{\cup} \rightarrow S_1 | S_2)\}$

$S$ of $G_{\cup}$:
$S_{\cup}$

## Concatenation
Same as union, but with a transition from the final state of $G_1$ the initial state of $G_2$


#### Related
[[Context-free Grammars]] [[Context-free Languages]]

 #language-theory #computer-science