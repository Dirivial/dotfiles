# Chomsky Normal Form
Any [[Context-free Grammars]] can be put on Chomsky Normal Form. 

This form is characterized by having all productions on the form:
$$A \rightarrow BC$$ $$or$$
$$A \rightarrow a$$

## Converting to CNF
Given a context-free grammar G. To write it on CNF we need to to the following:
1. Remove lambda transitions.
2. Remove unit transitions.
3. Add a unique non-terminal and transition for each of the terminals.
4. For all productions producing multiple terminals, replace the terminals with the new non-terminals.
5. Now split all transitions that produce more than two non-terminals to produce one of them and adding a new non-terminal that produces the rest (repeat if the new one produces more than two)

#NoamChomsky #computer-science #language-theory 