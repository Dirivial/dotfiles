# Turing Machine(s)
- Created by [[@Alan Turing]]
- Equivalent in computing power to the computers we know today.
- Storage is a tape with cells that can be read and written to.
- Input/Output is what is read/written to the tape.

## Definition

$$M = (Q, \Sigma, \Gamma, \delta, q_0, \square, F)$$

- $Q$ is a finite set of states.
- $\Sigma$ is the input alphabet, $\Sigma \subseteq \Gamma \ \backslash \ \{\square\}$.
- $\Gamma$ is the tape alphabet.
- $\delta$ is the transition function. $\delta : Q \texttimes \Gamma \rightarrow 2^{Q \texttimes \Gamma \texttimes \{L,R\}}$
- $q_0$ is the initial state, $q_0 \in Q$.
- $\square$ is the tape blank. $\square \in \Gamma$
- $F$ is the set of final states. $F \subseteq Q$

### Deterministic version
Same but with $\delta$:
$$\delta : Q \texttimes \Gamma \rightarrow {Q \texttimes \Gamma \texttimes \{L,R\}}$$

It is deterministic in the sense that there is only one move possible for each configuration, same as [[DPDA]].

## Halting
Halting is when a TM enters a configuration in which $\delta$ is not defined.

A TM accepts a string if it halts in a final state.
If a TM halts in a non-final state, the string was not accepted.

## Instantaneous Description
Convenient way to describe a configuration some TM is in.
Looks like:
$$a_1a_2...a_kqa_k+1...a_n$$
where q is the state the TM is in, and the position of q is where the read/write head is on the tape.

As usual, a move between descriptions is denoted by $\vdash$. If there are multiple machines, $\vdash _M$

## Turing machines and languages
A TM can accept a string by halting in a final state, which happens if the string w is in the language generated by the TM. If w is not in the language generated by the TM, it may or may not halt in a non-final state.

## Turing machines and functions
A TM can act as a function, using what's written on the tape as input and when it halts, the output is on the tape.

## Some Turing machine variants
An interesting note is that all of these variants have the same *computational power* as a normal Turing machine. The amount of steps needed for computing a problem may however differ greatly depending on which variant is chosen.
### Stay Option
With a normal Turing machine, we have to either go right or left. With the stay option, we can opt to stay in the same position.

**Why does this not increase the computational power?**
Because we can take a normal Turing machine and instead of using the stay option, move either to the right or left in to a specific state and then move back without altering the tape.

### Semi-Infinite Tape
This type has an infinite tape only in one direction.

**Why does this not decrease the computational power?**
Assume a normal Turing machine that moves all symbols on the tape one step to the left/right whenever it wants to write something in the limited side, whether that is to the left or right.

### Offline
Normal Turing machine but with an additional tape only containing the input.

**Why does this not increase the computational power?**
Since the tape is infinite, we can just copy over the input to the normal tape and then it is a normal Turing machine.

### Multi-tape
A normal Turing machine but with multiple tapes that have their own read/write heads. The transition function becomes a bit different.
$$\delta : Q \texttimes \Gamma ^n \rightarrow Q \texttimes \Gamma ^n \texttimes \{L,R\}^n$$

Where $n$ is the number of tapes.

**Why does this not increase the computational power?**
Using a normal TM, we can split the tape into parts representing each of the tapes in the multi-tape TM.

#### Complexity note
A multi-tape TM running in t(n) time has and equivalent  $\mathcal O ((t(n))^2)$ Single tape TM.
-> At most polynomial time difference.

### Non-deterministic
A normal TM but with non-determinism.
$$\delta : Q \texttimes \Gamma \rightarrow 2^{Q \texttimes \Gamma \texttimes \{L,R\}}$$
**Why does this not increase the computational power?**
Because whenever a new branch is created, a normal TM could just split its tape into another part and use that to simulate non-determinism using instantaneous descriptions.

#### Complexity note
A non-deterministic TM running in t(n) time has and equivalent  $2^{\mathcal O (t(n))}$ Single tape TM.
-> At most exponential difference between them.

### Universal
A normal TM but it uses a normal input and and encoded TM as its input. It then simulates the encoded TM on the normal input. This is the type of TM that's needed for proof of undecidability ([[Language Theory#Decidability]]) of the [[Halting Problem]].

## Languages related to Turing machines
[[Recursive Languages]] and [[Recursively Enumerable Languages]].

#### Related
[[Big O]] [[Complexity]]

 #language-theory #computer-science