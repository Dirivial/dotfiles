# Countability
A set is countable if it can be put in a one-to-one correspondence with the natural numbers.

Examples:
- The natural numbers.
- Even numbers.
- Any subset of the natural numbers.
- The rational numbers.
- The set of [[Turing Machine(s)]].
- The set of halting [[Turing Machine(s)]]

## Explanations
### Rational numbers
We can list all rational numbers by doing the following:
$\frac{1}{1}, \frac{2}{1}, \frac{1}{2}, \frac{1}{3}, \frac{2}{2}, \frac{3}{1}$

|     | 1             | 2             | 3             | 4             |
| --- | ------------- | ------------- | ------------- | ------------- |
| 1   | $\frac{1}{1}$ | $\frac{1}{2}$ | $\frac{1}{3}$ | $\frac{1}{4}$ |
| 2   | $\frac{2}{1}$ | $\frac{2}{2}$ | $\frac{2}{3}$ | $\frac{2}{4}$ |
| 3   | $\frac{3}{1}$ | $\frac{3}{2}$ | $\frac{3}{3}$ | $\frac{3}{4}$ |
| 4   | $\frac{4}{1}$ | $\frac{4}{2}$ | $\frac{4}{3}$ | $\frac{4}{4}$ |

### Turing machines
We can encode a Turing machine as a string. The string will be finite and each of the machines can be put into an order by going through each possible encoding.

Meaning we start with 0 then 1, 00, 01, 10, 11 etc. which will give us all the possible Turing machines in an order.

## Size of the set
Very large in comparison to the sets in [[Chomsky Hierarchy]], it is larger than the set of enumerable sets([[Enumerability]]).

 #language-theory #computer-science