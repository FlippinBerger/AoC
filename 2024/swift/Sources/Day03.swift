//
//  File.swift
//  AdventOfCode
//
//  Created by Chris Berger on 12/1/24.
//

import Foundation

struct Day03: AdventDay {
  var data: String
  
  var mulMatches: [Regex<Substring>.Match] {
    data.matches(of: /mul\([0-9]{1,3},[0-9]{1,3}\)/)
  }
  
  var conditionalMatches: [Regex<Substring>.Match] {
    data.matches(of: /do\(\)|don't\(\)/)
  }
  
  func getNumbersFromString(_ match: String) -> (Int, Int) {
    var s = match.description
    s.trimPrefix("mul(")
    s = String(s.dropLast())
    
    let numbers = s.split(separator: ",").compactMap {Int($0)}
    return (numbers[0], numbers[1])
  }
  
  func getIndex(_ match: Regex<Substring>.Match) -> Int {
    return match.startIndex.utf16Offset(in: data)
  }
  
  func part1() -> Any {
    var sum = 0
    for match in mulMatches {
      let (one, two) = getNumbersFromString(match.description)
      sum += one * two
    }
    return sum
  }
  
  func part2() -> Any {
    var sum = 0
    var shouldCalculate = true
    
    var condIndex = 0
    var multIndex = 0
    
    var condMatch = conditionalMatches[condIndex]
    var condDataIndex = getIndex(condMatch)
    
    var multMatch = mulMatches[multIndex]
    var multDataIndex = getIndex(multMatch)

    while condIndex < conditionalMatches.count && multIndex < mulMatches.count {
      if condDataIndex < multDataIndex {
        if condMatch.description.contains("don't") {
          shouldCalculate = false
        } else if condMatch.description.contains("do") {
          shouldCalculate = true
        }
        condIndex += 1
        if condIndex < conditionalMatches.count {
          condMatch = conditionalMatches[condIndex]
          condDataIndex = getIndex(condMatch)
        }
        continue
      }
      
      if shouldCalculate {
        let (one, two) = getNumbersFromString(multMatch.description)
        sum += one * two
      }
      
      multIndex += 1
      if multIndex < mulMatches.count {
        multMatch = mulMatches[multIndex]
        multDataIndex = getIndex(multMatch)
      }
    }
    
    while multIndex < mulMatches.count {
      if shouldCalculate {
        let multMatch = mulMatches[multIndex]
        let (one, two) = getNumbersFromString(multMatch.description)
        sum += one * two
      } else {
        break
      }
      
      multIndex += 1
    }

    return sum
  }
}
