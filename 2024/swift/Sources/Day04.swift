//
//  File.swift
//  AdventOfCode
//
//  Created by Chris Berger on 12/1/24.
//

import Foundation

struct Day04: AdventDay {
  var data: String
  
  func getDataArray() -> [String.SubSequence] {
    return data.split(separator: "\n")
  }
  
  func getCharacter(arr: [String.SubSequence], i: Int, j: Int) -> Character {
    let index = arr[i].index(arr[i].startIndex, offsetBy: j)
    return arr[i][index]
  }
  
  func countXmasForX(arr: [String.SubSequence], i: Int, j: Int) -> Int {
    var count = 0
    
    // L to R
    if j < arr[i].count - 3 {
      let startIndex = arr[i].index(arr[i].startIndex, offsetBy: j)
      let endIndex = arr[i].index(arr[i].startIndex, offsetBy: j+3)
      let word = arr[i][startIndex...endIndex]
      if word == "XMAS" {
        count += 1
      }
    }
    
    // R to L
    if j > 2 {
      let startIndex = arr[i].index(arr[i].startIndex, offsetBy: j-3)
      let endIndex = arr[i].index(arr[i].startIndex, offsetBy: j)
      let word = arr[i][startIndex...endIndex]
      if word == "SAMX" {
        count += 1
      }
    }
    
    // Up left
    if j > 2 && i > 2 {
      if getCharacter(arr: arr, i: i - 1, j: j - 1) == "M" &&
          getCharacter(arr: arr, i: i - 2, j: j - 2) == "A" &&
          getCharacter(arr: arr, i: i - 3, j: j - 3) == "S" {
        count += 1
      }
    }
    
    // Up right
    if j < arr[i].count - 3 && i > 2 {
      if getCharacter(arr: arr, i: i - 1, j: j + 1) == "M" &&
          getCharacter(arr: arr, i: i - 2, j: j + 2) == "A" &&
          getCharacter(arr: arr, i: i - 3, j: j + 3) == "S" {
        count += 1
      }
    }
    
    // Down left
    if j > 2 && i < arr.count - 3 {
      if getCharacter(arr: arr, i: i + 1, j: j - 1) == "M" &&
          getCharacter(arr: arr, i: i + 2, j: j - 2) == "A" &&
          getCharacter(arr: arr, i: i + 3, j: j - 3) == "S" {
        count += 1
      }
    }
    
    // Down Right
    if j < arr[i].count - 3 && i < arr.count - 3 {
      if getCharacter(arr: arr, i: i + 1, j: j + 1) == "M" &&
          getCharacter(arr: arr, i: i + 2, j: j + 2) == "A" &&
          getCharacter(arr: arr, i: i + 3, j: j + 3) == "S" {
        count += 1
      }
    }
    
    // Up
    if i > 2 {
      if getCharacter(arr: arr, i: i - 1, j: j) == "M" &&
          getCharacter(arr: arr, i: i - 2, j: j) == "A" &&
          getCharacter(arr: arr, i: i - 3, j: j) == "S" {
        count += 1
      }
    }
    
    // Down
    if i < arr.count - 3 {
      if getCharacter(arr: arr, i: i + 1, j: j) == "M" &&
          getCharacter(arr: arr, i: i + 2, j: j) == "A" &&
          getCharacter(arr: arr, i: i + 3, j: j) == "S" {
        count += 1
      }
    }

    return count
  }
  
  func findXmasCount(_ arr: [String.SubSequence]) -> Int {
    var xmasCount = 0
    
    for i in 0..<arr.count {
      for j in 0..<arr[i].count {
        let char = getCharacter(arr: arr, i: i, j: j)
        if char == "X" {
          xmasCount += countXmasForX(arr: arr, i: i, j: j)
        }
      }
    }
    return xmasCount
  }
  
  func checkWord(_ w: String) -> Bool {
    return w == "SM" || w == "MS"
  }
  
  func checkLeft(arr: [String.SubSequence], i: Int, j: Int) -> Bool {
    let top = getCharacter(arr: arr, i: i - 1, j: j - 1)
    let bottom = getCharacter(arr: arr, i: i + 1, j: j + 1)
    
    let s = String(top) + String(bottom)
    return checkWord(s)
  }
  
  func checkRight(arr: [String.SubSequence], i: Int, j: Int) -> Bool {
    let top = getCharacter(arr: arr, i: i - 1, j: j + 1)
    let bottom = getCharacter(arr: arr, i: i + 1, j: j - 1)
    
    let s = String(top) + String(bottom)
    return checkWord(s)

  }

  func isCross(arr: [String.SubSequence], i: Int, j: Int) -> Bool {
    return checkLeft(arr: arr, i: i, j: j) && checkRight(arr: arr, i: i, j: j)
  }
  
  func findCrossCount(_ arr: [String.SubSequence]) -> Int {
    var crossCount = 0
    
    for i in 0..<arr.count {
      for j in 0..<arr[i].count {
        if i == 0 || j == 0 || i == arr.count - 1 || j == arr[i].count - 1 {
          continue
        }
        let char = getCharacter(arr: arr, i: i, j: j)
        if char == "A" {
          if isCross(arr: arr, i: i, j: j) {
            crossCount += 1
          }
        }
      }
    }
    return crossCount
  }
 
  func part1() -> Any {
    let arr = getDataArray()
    
    return findXmasCount(arr)
  }
  
  func part2() -> Any {
    let arr = getDataArray()
    
    return findCrossCount(arr)
  }
}
