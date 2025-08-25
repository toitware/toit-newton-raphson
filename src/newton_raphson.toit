// Copyright (C) 2021 Toitware ApS.  All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import math show *

/**
Performs Newton-Raphson solving of a formula.  If you want to find x, but you
  only have y=f(x) then this uses an iterative process to find x from y.

You must supply two blocks: $function for the function f, and $derivative for
  the function f' (the first derivative of f).  The iterative algorithm will
  start at the $initial value, which defaults to 0.0, and attempt to find a
  solution where the $function evaluates to the $goal, default 0.0.

$max-iterations denotes the maximum number of iterations of Newton's method
  that will be used before giving up.  Default is 20.  After half of this
  number, default 10 iterations, the algorithm gives up searching for an
  exact answer and accepts a value that is close enough.

$precision denotes what 'close enough' means.  The default value, 1e9, means
  that a difference between successive estimates that is within a factor of
  0.999_999_999 and 1.000_000_001 of the previous estimate will be accepted.

The $no-convergence block determines what happens if the method does not
  converge.  It is called with the best estimate so far, which is probably
  not a good estimate, and may be infinite or NaN.

There are a lot of pitfalls in the Newton-Raphson method, especially with
  functions that have multiple inflection points.  See
  https://en.wikipedia.org/wiki/Newton%27s_method#Failure_of_the_method_to_converge_to_the_root
  for details.

# Examples
```
import math show *
import newton_raphson

main:
  example1
  example2

example1:
  // We want to solve x^3 + 0.3x^2 + x - 10 = 0
  // The function we are solving can be represented by the following block:
  function := (: it*it*it + 0.3*it*it + it - 10.0)
  // The derivative is 3x^2 + 0.6x + 1
  derivative := (: 3.0*it*it + 0.6*it + 1.0)

  solution := newton-raphson.solve --function=function --derivative=derivative

  // Prints 1.9121139350636005005 because this is the solution of x^3 + 0.3x^2 + x - 10 = 0
  print solution

example2:
  // We want to solve ln(x) + x^3 = 10.
  // The function we are solving can be represented by the following block:
  function := (: (log it) + it * it * it)
  // The derivative of the natural log is -1/x, and the derivative of x^3 is 3x^2.
  derivative := (: -1.0 / it + 3.0 * it * it)

  // We provide an initial guess of 1.0 because the derivative is not well
  // defined at 0.
  // We define the goal as 10.0 because we have 10 on the right hand side
  // instead of 0.0, which is the default.
  solution := newton-raphson.solve --goal=10.0 --initial=1.0 --function=function --derivative=derivative

  // Prints 2.0997856714017091306 because this is the solution of ln(x) + x^3 = 10.0
  print solution
```
*/
solve --initial/num=0.0 --goal/num=0.0 --max-iterations=20 --precision=1e9 [--function] [--derivative] [--no_convergence] -> float:
  x/float := initial.to-float
  previous := float.NAN
  max-iterations.repeat: | repeats |
    top := (function.call x) - goal
    if top == 0: return x
    new-x := x - top / (derivative.call x)
    if new-x == x: return x
    // A billionth is a suitable precision to aim for with IEEE doubles.
    if new-x == previous or repeats > max-iterations / 2 and (new-x / (new-x - x)).abs > precision:
      // Oscillating around an answer.  Pick the best of the last two.
      old-diff := (function.call x) - goal
      new-diff := (function.call new-x) - goal
      return old-diff.abs < new-diff.abs ? x : new-x
    previous = x
    x = new-x
  no_convergence.call x
  return x

/**
Variant of $(solve --initial --goal --max-iterations --precision [--function] [--derivative] [--no_convergence]).
This version throws an exception if there is no convergence.
*/
solve --initial/num=0.0 --goal/num=0.0 --max-iterations=20 --precision=1e9 [--function] [--derivative] -> float:
  return solve --initial=initial --goal=goal --max-iterations=max-iterations --precision=precision --function=function --derivative=derivative --no_convergence=: throw "DID_NOT_CONVERGE"
