//
//  File.swift
//  AdventOfCode
//
//  Created by Chris Berger on 12/1/24.
//

import Foundation

enum Dir {
  case up
  case right
  case down
  case left
}

struct Day06: AdventDay {
  var data: String
  
  func getMapAsChars() -> [[Character]] {
    let substrings = data.split(separator: "\n")
    
    var map: [[Character]] = []
    
    for substring in substrings {
      var row: [Character] = []
      for c in substring {
        row.append(c)
      }
      map.append(row)
    }
    
    return map
  }
  
  func patrol(_ map: inout [[Character]], i: Int, j: Int) -> Int {
    return walk(&map, startI: i, startJ: j, startDir: Dir.up)
  }
  
  func walk(_ map: inout [[Character]], startI: Int, startJ: Int, startDir: Dir) -> Int {
    var spaces = 0
    
    var i = startI
    var j = startJ
    var dir = startDir
    
    var done = false
    
    while true {
      switch dir {
      case .up:
        if i == 0 {
          done = true
        }
      case .right:
        if j == map[i].count - 1 {
          done = true
        }
      case .down:
        if i == map.count - 1 {
          done = true
        }
      case .left:
        if j == 0 {
          done = true
        }
      }
      
      if map[i][j] != "X" {
        map[i][j] = "X"
        spaces += 1
      }
      
      if done {
        break
      }

      switch dir {
      case .up:
        if map[i-1][j] == "#" {
          j += 1
          dir = .right
        } else {
          i -= 1
        }
      case .right:
        if map[i][j+1] == "#" {
          i += 1
          dir = .down
        } else {
          j += 1
        }
      case .down:
        if map[i + 1][j] == "#" {
          j -= 1
          dir = .left
        } else {
          i += 1
        }
      case .left:
        if map[i][j-1] == "#" {
          i -= 1
          dir = .up
        } else {
          j -= 1
        }
      }
    }
    
    return spaces
  }
  
  func part1() -> Any {
    var map = getMapAsChars()
    
    var total = 0
    
    for (i, row) in map.enumerated() {
      for (j, col) in row.enumerated() {
        if col == "^" {
          total = patrol(&map, i: i, j: j)
          break
        }
      }
      
      if total != 0 {
        break
      }
    }
    
    return total
  }
  
  func part2() -> Any {
    return 0
  }
}
