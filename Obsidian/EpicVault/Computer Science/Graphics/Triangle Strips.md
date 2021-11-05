# Triangle strips
A strip of triangles. Beginning with some arbitrary triangle then reusing its vertices to get the next one.

$$array = \{v_0, v_1, v_2, ... , v_{n-1}\}$$
Access: $$T_i = \{v_i, v_{i+1}, v_{i+2}\}$$

## Pros
- Low storage cost
- Efficient
## Cons
- Duplication between of vertices *between* each strip
- Complicated to compute