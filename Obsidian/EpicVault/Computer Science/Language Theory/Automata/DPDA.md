## DPDA

## Restricted NPDA
[[NPDA]], but with the restriction that at all times, there can only be one possible move. This removes the non-determinism.

*NOTE:* DPDA can still have lambda transitions, say $\delta (q, \lambda, b)$, but then all $\delta (q, c, b)$ must be empty for all $c \in \Sigma$. Lambda transitions does *not* allow non-determinism because the stack plays a role in determining the next move.

*NOTE 2:* DPDA's allow undefined moves.

 #language-theory #computer-science