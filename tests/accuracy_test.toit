// Copyright (C) 2021 Toitware ApS.  All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import expect show *
import math show *
import newton-raphson

main:
  // x^2 - 10
  function := (: it * it - 10.0)
  // The derivative is 2x
  derivative := (: 2 * it)

  s/num := ?
  GOAL ::= 10.sqrt
  // Use a precision of 1 to terminate early when half the max iterations has been hit.
  s = newton-raphson.solve
      --function=function
      --derivative=derivative
      --max-iterations=3
      --initial=2
      --precision=1
  expect (s - GOAL).abs < 0.000_1
  s = newton-raphson.solve
      --function=function
      --derivative=derivative
      --max-iterations=4
      --initial=2
      --precision=1
  expect (s - GOAL).abs < 0.000_000_1
  s = newton-raphson.solve
      --function=function
      --derivative=derivative
      --max-iterations=6
      --initial=2
      --precision=1
  expect (s - GOAL).abs < 0.000_000_000_000_1

  // Use the did not converge block.
  newton-raphson.solve
      --function=function
      --derivative=derivative
      --max-iterations=2
      --initial=2
      --if-not-converge=:
        expect (it - GOAL).abs < 0.2
        print it
        it
  newton-raphson.solve
      --function=function
      --derivative=derivative
      --max-iterations=3
      --initial=2
      --if-not-converge=:
        expect (it - GOAL).abs < 0.000_1
        print it
        it
  newton-raphson.solve
      --function=function
      --derivative=derivative
      --max-iterations=4
      --initial=2
      --if-not-converge=:
        expect (it - GOAL).abs < 0.000_000_1
        print it
        it
  s = newton-raphson.solve
      --function=function
      --derivative=derivative
      --max-iterations=5
      --initial=2
  expect-equals GOAL s
  print s
