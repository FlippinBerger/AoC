//
//  File.swift
//  AdventOfCode
//
//  Created by Chris Berger on 12/1/24.
//

import Algorithms

struct Day01: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  var stuff: [[Int]] {
    let nums = data.split(separator: "\n").map {
      $0.split(separator: " ").compactMap {Int($0)}
    }
    
    return nums
  }
  
  var lists: ([Int], [Int]) {
    var one: [Int] = []
    var two: [Int] = []
    let numPairs = data.split(separator: "\n").map {
      $0.split(separator: " ").compactMap {Int($0)}
    }
    
    for pair in numPairs {
      one.append(pair[0])
      two.append(pair[1])
    }
    
    one.sort()
    two.sort()
    
    return (one, two)
  }
  
  var mapCalculation: Int {
    var total = 0
    var m: [Int: Int] = [:]
    
    for num in lists.0 {
      m[num] = 0
      for other in lists.1 {
        if other == num {
          m[num]! += 1
        }
      }
      total += (num * m[num]!)
    }
    
    return total
  }
  
  func part1() -> Any {
    var totalDistance = 0
    for (index, num) in lists.0.enumerated() {
      totalDistance += abs(num - lists.1[index])
    }
    
    return totalDistance
  }
  
  func part2() -> Any {
    return mapCalculation
  }
}
