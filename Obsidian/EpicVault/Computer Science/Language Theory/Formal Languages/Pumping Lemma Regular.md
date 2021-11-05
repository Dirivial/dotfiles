# Pumping Lemma for regular languages

A proof by contradiction. Can only prove if a language is *not* in the set of regular languages.

1. If the language is regular, there exists some pumping length $p$
2. Find a string $w$, where $|w| \geq p$
3. The string $w$ can then be divided into three parts. $w = xyz$
4. Where $xy \leq q$ and $|y| \geq 1$
5. Every word $w_i = xy^iz$ should be in the language for every $i \geq 0$


 #language-theory #computer-science