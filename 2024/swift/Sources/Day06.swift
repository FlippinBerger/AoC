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
          print("i: \(i), j: \(j)")
          total = walk(&map, startI: i, startJ: j, startDir: .up)
          break
        }
      }
      
      if total != 0 {
        break
      }
    }
    
    return total
  }
  
  func cycleFound(_ map: inout [[Character]], sI: Int, sJ: Int, sDir: Dir) -> Bool {
    var seen: [String:Int] = [:]
    
    var i = sI
    var j = sJ
    var dir = sDir
    
//    var startPointCount = 0
//    var count = 0
    
    while true {
      switch dir {
      case .up:
        if i == 0 {
          return false
        }
      case .right:
        if j == map[i].count - 1 {
          return false
        }
      case .down:
        if i == map.count - 1 {
          return false
        }
      case .left:
        if j == 0 {
          return false
        }
      }
      
      let spot = "\(i),\(j),\(dir)"
      let count = seen[spot] ?? 0
      
      switch dir {
      case .up:
        if map[i-1][j] == "#" {
          j += 1
          dir = .right
        } else if map[i-1][j] == "0" {
          if count > 1 {
            return true
          }
          seen[spot] = count + 1
          j += 1
          dir = .right
        } else {
          i -= 1
        }
      case .right:
        if map[i][j+1] == "#" {
          i += 1
          dir = .down
        } else if map[i][j+1] == "0" {
          if count > 1 {
            return true
          }
          seen[spot] = count + 1
          i += 1
          dir = .down
        } else {
          j += 1
        }
      case .down:
        if map[i + 1][j] == "#" {
          j -= 1
          dir = .left
        } else if map[i + 1][j] == "0" {
          if count > 1 {
            return true
          }
          seen[spot] = count + 1
          j -= 1
          dir = .left
        } else {
          i += 1
        }
      case .left:
        if map[i][j-1] == "#" {
          i -= 1
          dir = .up
        } else if map[i][j-1] == "0" {
          if count > 1 {
            return true
          }
          seen[spot] = count + 1
          i -= 1
          dir = .up
        } else {
          j -= 1
        }
      }
    }
  }

  func blockPatrol(_ map: inout [[Character]], startI: Int, startJ: Int, startDir: Dir) -> Int {
    var blockerCount = 0
    var i = startI
    var j = startJ
    var dir = startDir
    
    var done = false
    var counter = 0
    
    while true {
      var checkDir: Dir
      var blockerI = i
      var blockerJ = j
      
      switch dir {
      case .up:
        checkDir = .right
        blockerI -= 1
        if i == 0 {
          done = true
        }
      case .right:
        checkDir = .down
        blockerJ += 1
        if j == map[i].count - 1 {
          done = true
        }
      case .down:
        checkDir = .left
        blockerI += 1
        if i == map.count - 1 {
          done = true
        }
      case .left:
        checkDir = .up
        blockerJ -= 1
        if j == 0 {
          done = true
        }
      }
      
      if done {
        break
      }
     
      let temp = map[blockerI][blockerJ]
      if temp != "#" {
        map[blockerI][blockerJ] = "0"
       
        print("Counter: \(counter)")
        if cycleFound(&map, sI: i, sJ: j, sDir: dir) {
          blockerCount += 1
        }
        counter += 1
        
        map[blockerI][blockerJ] = temp
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

    return blockerCount
  }
 
  // first idea, check each space in front of the guard as a potential blocker
  // if he makes it back to the space he was on before you placed the blocker
  // then you found a cycle
  // 2111 is too high
  // 1000 is too low
  func part2() -> Any {
    var map = getMapAsChars()
   
    // grabbed starting point from part 1
    let blockerCount = blockPatrol(&map, startI: 59, startJ: 62, startDir: .up)
    return blockerCount
  }
}
