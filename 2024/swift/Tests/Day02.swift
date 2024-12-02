//
//  File.swift
//  AdventOfCode
//
//  Created by Chris Berger on 12/2/24.
//

import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day02Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    8 9 8 7 6
    """
  
  @Test func testPart1() async throws {
    let challenge = Day02(data: testData)
    #expect(String(describing: challenge.part1()) == "0")
  }
  
  @Test func testPart2() async throws {
    let challenge = Day02(data: testData)
    #expect(String(describing: challenge.part2()) == "1")
  }
}
