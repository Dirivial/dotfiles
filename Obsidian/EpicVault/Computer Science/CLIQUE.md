# CLIQUE problem

Using an undirected graph, a k-clique is a subset of the nodes in the graph such that every node in the subset has an edge to all the other nodes in the subset.

With a deterministic [[Turing Machine(s)]], it will take $2^N$ (N = nodes) steps, because we have to examine all the elements.

With non-determinism, we can guess a subset (called a certificate) and then do the following for verifying it: 
- Check if the nodes in the guessed subset, exist in the real graph.
- Check that there are edges between each of the nodes.
This will result in $\mathcal O(n^3)$ time. Therefore the problem is in [[Class NP]].

#computer-science 