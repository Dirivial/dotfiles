# Reducibility

Reduction is about reducing a problem A to another problem B, so that the solution to B can solve A.

If A is reducible to B, then:
- If B is decidable (recursive), then so is A.
- If A is not decidable, then neither is B.

## Example
The [[Halting Problem]] could be solved if we had a solution to the [[State Entry Problem]].

*Very brief explanation of how to reduce:* The halting problem can be reduced to the state entry problem by checking if a machine ever enters a final state on some input.

#language-theory #computer-science 