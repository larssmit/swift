//===--- Concatenate.swift - Tests for lazy/eager concatenate -------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2015 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//
// RUN: %target-run-simple-swift
// REQUIRES: executable_test

import StdlibUnittest

var ConcatenateTests = TestSuite("ConcatenateTests")

// Help the type checker (<rdar://problem/17897413> Slow type deduction)
typealias X = ContiguousArray<Range<Int>>

let samples: ContiguousArray<(Range<Int>, X)> = [
  (0..<8, [ 1..<1, 0..<5, 7..<7, 5..<7, 7..<8 ] as X),
  (0..<8, [ 0..<5, 7..<7, 5..<7, 7..<8 ] as X),
  (0..<8, [ 1..<1, 0..<5, 7..<7, 5..<7, 7..<8, 11..<11 ] as X),
  (0..<8, [ 0..<5, 7..<7, 5..<7, 7..<8, 11..<11 ] as X),
  (0..<0, [ 11..<11 ] as X),
  (0..<0, [ 3..<3, 11..<11 ] as X),
  (0..<0, [] as X),
]

let expected = ContiguousArray(0..<8)

for (expected, source) in samples {
  ConcatenateTests.test("forward-\(source)") {
    checkBidirectionalCollection(expected, source.flatten())
  }

  ConcatenateTests.test("reverse-\(source)") {
    // FIXME: separate 'expected' and 'reversed' variables are a workaround
    // for: <rdar://problem/20789500>
    let expected = ContiguousArray(expected.lazy.reverse())
    let reversed = source.flatten().reverse()
    checkBidirectionalCollection(expected, reversed)
  }

  ConcatenateTests.test("sequence-\(source)") {
    checkSequence(
      ContiguousArray(expected),
      AnySequence(source).flatten())
  }
}

runAllTests()

