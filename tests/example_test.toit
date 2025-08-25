// Copyright (C) 2021 Toitware ApS.  All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import expect show *
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

  s := newton-raphson.solve --function=function --derivative=derivative --precision=1

  expect-equals 10.0
    s*s*s + 0.3*s*s + s

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
  s := newton-raphson.solve --goal=10.0 --initial=1.0 --function=function --derivative=derivative

  expect (10.0 - (function.call s)).abs < 0.000_000_001
