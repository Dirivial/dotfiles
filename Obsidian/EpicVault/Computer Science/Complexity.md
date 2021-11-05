# Complexity
Complexity is the study about the finding the amount of resources needed for solving computational problems. It is *very* important that it focuses on the problem itself, and not things like hardware, software, data structures and implementation.

We compute the time it takes to run an algorithm (running time) to be a function of the length of the input string (which represents the input). Because of this, the number of steps may differ depending on some particular input. 

*Example*: the input is a graph. More explicit: A graph only containing nodes vs a graph containing a lot of edges and nodes, but both has the *same* length input string.

## Asymptotic analysis, $\mathcal O$

We focus on how the algorithm behaves for *large* inputs. This means that only the highest order term matters, for some $f(n)$ depicting the running time of an algorithm.

*f is asymptotically at most $n^3$* if f is, for example, $f(n) = 3n^3 + 50n^2$. Therefore $f(n) = \mathcal O (n^3)$.

### Defining $\mathcal O$
See [[Big O]].

## Time complexity classes
In the field of [[Language Theory]], we can separate languages into time complexity classes.

### Time complexity class
**TIME(t(n))** is the set of languages decidable (see [[Language Theory]]) by an $\mathcal O (t(n))$ [[Turing Machine(s)]].

**NTIME(t(n))** is the set of languages decidable (see [[Language Theory]]) by an $\mathcal O (t(n))$ non-deterministic multi-tape [[Turing Machine(s)]].

### Differences in time complexity
Small - Polynomial difference
Large - Exponential difference

## Time complexity class P
See [[Class P]].

## Time complexity class NP
See [[Class NP]].

### Interesting notes
[[CLIQUE]] [[SAT]] 

## P and NP
One of the greatest unsolved problems in computer science is if $\mathcal P$ equals $\mathcal{NP}$. To prove that $\mathcal P = \mathcal{NP}$, you would need to argue that every problem in $\mathcal{NP}$ can be solved by a deterministic [[Turing Machine(s)]]. To prove $\mathcal P \neq \mathcal{NP}$ you would need to prove that no deterministic TM can solve some problem in $\mathcal{NP}$.

#### Related
[[Reducibility]]

#computer-science