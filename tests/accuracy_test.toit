// Copyright (C) 2021 Toitware ApS.  All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import expect show *
import math show *
import newton_raphson

main:
  // x^2 - 10
  function := (: it * it - 10.0)
  // The derivative is 2x
  derivative := (: 2 * it)

  s/num := ?
  GOAL ::= 10.sqrt
  // Use a precision of 1 to terminate early when half the max iterations has been hit.
  s = newton_raphson.solve --function=function --derivative=derivative --max_iterations=3 --initial=2 --precision=1
  expect (s - GOAL).abs < 0.000_1
  s = newton_raphson.solve --function=function --derivative=derivative --max_iterations=4 --initial=2 --precision=1
  expect (s - GOAL).abs < 0.000_000_1
  s = newton_raphson.solve --function=function --derivative=derivative --max_iterations=6 --initial=2 --precision=1
  expect (s - GOAL).abs < 0.000_000_000_000_1

  // Use the did not converge block.
  newton_raphson.solve --function=function --derivative=derivative --max_iterations=2 --initial=2 --no_convergence=:
    expect (it - GOAL).abs < 0.2
    print it
  newton_raphson.solve --function=function --derivative=derivative --max_iterations=3 --initial=2 --no_convergence=:
    expect (it - GOAL).abs < 0.000_1
    print it
  newton_raphson.solve --function=function --derivative=derivative --max_iterations=4 --initial=2 --no_convergence=:
    expect (it - GOAL).abs < 0.000_000_1
    print it
  s = newton_raphson.solve --function=function --derivative=derivative --max_iterations=5 --initial=2
  expect_equals GOAL s
  print s
