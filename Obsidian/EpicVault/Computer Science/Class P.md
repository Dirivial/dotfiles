# Time complexity class P
$\mathcal P$ is the class of languages that are decidable in polynomial time by some [[Turing Machine(s)]].

## Formal definition
$$\mathcal P = \bigcup_{k\geq1} TIME(n^k)$$
Where the permitted [[Turing Machine(s)]] are limited to the deterministic ones.

## Why it is important
1. It does not matter if you use multi-tapes or any other deterministic TM, a normal TM can still decide the language in polynomial time.
2. Roughly contains the reasonably solvable problems on our computers.
3. Even though Moore's law does not hold any more, the speed of which our computers operate still outpaces any polynomial.

#### Related
[[Complexity]] [[Class NP]]

#computer-science