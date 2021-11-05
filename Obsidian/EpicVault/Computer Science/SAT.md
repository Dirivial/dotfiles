# Satisfiability problem (SAT)
Find an assignment of values so that a given boolean expression on [[Conjunctive Normal Form]] will be true.

Using a deterministic [[Turing Machine(s)]], we can try each possible value. This leads to an algorithm running in $\mathcal O(2^n)$ time.

Using a non-deterministic approach. We can guess a solution and then check if it evaluates to true. This leads to an algorithm running in $\mathcal O(n)$ time.

#computer-science 