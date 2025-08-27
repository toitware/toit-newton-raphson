// Copyright (C) 2021 Toitware ApS.
// Use of this source code is governed by a Zero-Clause BSD license that can
// be found in the EXAMPLES_LICENSE file.

import math show *
import newton-raphson

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
  solution := newton-raphson.solve
      --goal=10.0
      --initial=1.0
      --function=function
      --derivative=derivative

  // Prints 2.0997856714017091306 because this is the solution
  // of ln(x) + x^3 = 10.0.
  print solution
