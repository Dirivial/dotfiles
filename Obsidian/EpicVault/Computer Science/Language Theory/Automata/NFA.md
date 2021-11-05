# NFA
The same as a [[DFA]], but with non-determinism.

Therefore, the delta looks like:
$$\delta : Q \texttimes (\Sigma \cup \{\lambda\}) \rightarrow 2^Q$$

Non-determinism means that we can explore multiple branches, choosing the correct path if there is one.

 #language-theory #computer-science