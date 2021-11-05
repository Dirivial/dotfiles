# Context-free Grammars
A context-free grammar is a quadruple:

$$G = (N, T, P, S)$$
Where:
- $N$ is a finite set of non-terminal symbols
- $T$ is a finite set of terminal symbols, note $N \cap T = \emptyset$
- $P$ is a finite set of production rules. $A \rightarrow \alpha$, $A \in N, \alpha \in (N \cup T)^*$
- $S$ is the starting non-terminal.

## Production / Derivation
Obviously, a context-free grammar G will produce a [[Context-free Languages]] L. The set of all strings produced by G, is L. Therefore we can write L(G) 

We can also say, if we have two string from N and T, let's call them w and x. w then derives x if there are some productions that allow us to go from w to x.

### Derivation trees
A graphical representation of the derivations used to derive some string, aka. the yield of the derivation tree.

### Ambiguity
Ambiguity is when a grammar has two or more different paths (derivations) to create the same string. Very common with natural languages (the ones we speak).

### Sentential form
When a derivation is not complete, and we still have non-terminals, that is called sentential form. Example: aaAbbb.

#### Related
[[Context-free Languages]], [[Chomsky Normal Form]]

#NoamChomsky  #language-theory #computer-science