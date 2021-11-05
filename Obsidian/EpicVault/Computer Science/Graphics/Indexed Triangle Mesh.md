# Indexed Triangle Mesh
Store all vertices in one list and then use a second list to describe how each triangle is created using indices.

$$ V = \{v_0, v_1, v_2,...,v_n\}$$
$$ I = \{0,1,2,1,3,2...\}$$
$$ T_i = \{V[I[3i]],V[I[3i+1]],V[I[3i+2]]\}$$
The vertex array can, and is often, rearranged to increase performance (by reducing the amount of jumping around).

## Pros
- Low storage cost
- Efficient
- Easy to use/implement
- Used by many graphics pipelines