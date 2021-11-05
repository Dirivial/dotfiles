# Geometric Transformations

## Affine space
Think vector space but with added points.
The points are locations in space, without size.

### Point-vector addition
P: Point
Q: Point
v: vector
$$P = Q + v$$
A new point is formed by adding a vector to a point.

### Point-point subtraction
P: Point
Q: Point
v: vector
$$v = P - Q$$
A vector is formed by subtracting to points.

### Zero vector
A vector without magnitude, undefined direction.

### Lines and rays in affine space
$$P(\alpha) = P_0 + \alpha d$$
We generate points on a line from $P_0$ by varying $\alpha$.
### Restricted operations
We *can't* do point-point addition nor point-scalar multiplication.

### Representing a point using two points
We can represent a point using a combination of two points, meaning the interesting point is on a line between them. 
If:
$$ P = Q + \alpha v$$
$$v = R - Q$$
Then:
$$ P = Q + \alpha (R - Q) = \alpha R + (1 - \alpha)Q$$

### Planes
Representing planes in affine sum:
$$T(\alpha, \beta) = P_0 + \alpha u + \beta v$$
Normal vector:
$$ n = u \texttimes v$$

### Frames
A point in space + using the basis vector can form a *frame*.
#### In 3D affine space
$$(P_0, v_1, v_2, v_3)$$
Any vector in the frame can be expressed as:
$$v = \alpha_1 v_1 + \alpha_2 v_2 + \alpha_3 v_3$$
Every point:
$$Q = P_0 + \beta_1 v_1 + \beta_2 v_2 + \beta_3 v_3$$

## How to measure length?
Use Euclidean space.
- Vector length: $|v| = \sqrt{v \cdot v} = ||v||_2$
- Angles: $u \cdot v = |u||v|cos\theta$


