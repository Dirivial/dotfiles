# Halting Problem
The Halting problem is an undecidable problem ([[Language Theory]]).

## Informal proof
Assume a [[Turing Machine(s)]], H, that can solve the Halting problem, meaning it will always halt giving a yes or no answer. Assume then that we have another TM, H', that enters an infinite loop when given an input that H halts on. If we then give H' as the input TM and as the given input string (by encoding it) we get some strange behavior. If H' halts on itself, then H' goes into an infinite loop. If H' does not halt on itself, it halts. Which is a contradiction leading to H not being able to exist.

#computer-science