# Pumping Lemma for context-free languages

Assume L is a context-free language. Then there will be a pumping length $p$, such that any word $w \in L$ where $|w| \geq p$ and $w$ can then be split into five parts.
$$w = xuyvz$$
with the following properties:
$$|uyv| \leq p$$
and
$$|uv| \textgreater 1$$
so that
$$xu^iyv^iz \in L, i \in \mathbb{N}$$

 #language-theory #computer-science