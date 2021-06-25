# Newton-Raphson

Implementation of the root-finding algorithm, named after Isaac Newton and
Joseph Raphson.

This is a way to solve formulas of the form y = f(x), where you know only y and
want to find x.  Instead of inverting the function f, which is not always
possible you instead supply f', the derivative of f with respect to x.

There are a lot of pitfalls in the Newton-Raphson method, especially with
functions that have multiple inflection points.  See
[https://en.wikipedia.org/wiki/Newton%27s_method#Failure_of_the_method_to_converge_to_the_root]
for details.

# Example

```
import math show *
import newton_raphson

main:
  // We want to solve x^3 + 0.3x^2 + x - 10 = 0
  // The function we are solving can be represented by the following block:
  function := (: it*it*it + 0.3*it*it + it - 10.0)
  // The derivative is 3x^2 + 0.6x + 1
  derivative := (: 3.0*it*it + 0.6*it + 1.0)

  solution := newton_raphson.solve --function=function --derivative=derivative

  // Prints 1.9121139350636005005 because this is the solution of x^3 + 0.3x^2 + x - 10 = 0
  print solution
```
