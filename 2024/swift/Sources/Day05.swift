//
//  File.swift
//  AdventOfCode
//
//  Created by Chris Berger on 12/1/24.
//

import Foundation

struct Day05: AdventDay {
  var data: String
    
  func getParts() -> [String.SubSequence] {
    let parts = data.split(separator: "\n\n")
    return parts
  }
  
  func parseRules(rules: String.SubSequence) -> [String: [String]] {
    var ruleMap: [String: [String]] = [:]
    
    let rulesArray = rules.split(separator: "\n")
    for rule in rulesArray {
      let ruleArray = rule.split(separator: "|")
      let key = String(ruleArray[0])
      let value = String(ruleArray[1])
      
      if var a = ruleMap[key] {
        a.append(value)
        ruleMap[key] = a
      } else {
        ruleMap[key] = [value]
      }
    }
    
    return ruleMap
  }
  
  func checkUpdate(update: String.SubSequence, ruleMap: [String: [String]]) -> Int {
    var set = Set<String>()
    let pages = update.split(separator: ",")
    for page in pages {
      let pageS = String(page)
      
      for checkNum in ruleMap[pageS]! {
        if set.contains(checkNum) {
          return 0
        }
      }
      
      set.insert(pageS)
    }
    
    let s = String(pages[pages.count / 2])
    return Int(s)!
  }
 
  func part1() -> Any {
    let parts = getParts()
    let ruleMap = parseRules(rules: parts[0])
    
    let updates = parts[1].split(separator: "\n")
   
    var total = 0
    for update in updates  {
      total += checkUpdate(update: update, ruleMap: ruleMap)
    }
    
    return total
  }
 
  // bubble sort for the win
  func reorderAndGetMid(update: String.SubSequence, ruleMap: [String: [String]]) -> Int {
    var pages = update.split(separator: ",")
    
    var temp: Substring = ""
    var swapped = false
    
    for i in 0..<pages.count - 1 {
      swapped = false
      for j in 0..<pages.count - i - 1 {
        // check if they need to be swapped
        if ruleMap[String(pages[j+1])]!.contains(String(pages[j])) {
          temp = pages[j+1]
          pages[j+1] = pages[j]
          pages[j] = temp
          swapped = true
        }
      }
      if !swapped {
        break
      }
    }
   
    let s = String(pages[pages.count / 2])
    return Int(s)!
  }
  
  func checkIncorrectUpdates(update: String.SubSequence, ruleMap: [String: [String]]) -> Int {
    var set = Set<String>()
    let pages = update.split(separator: ",")
    for page in pages {
      let pageS = String(page)
      
      for checkNum in ruleMap[pageS]! {
        if set.contains(checkNum) {
          return reorderAndGetMid(update: update, ruleMap: ruleMap)
        }
      }
      
      set.insert(pageS)
    }
    return 0
  }

  func part2() -> Any {
    let parts = getParts()
    let ruleMap = parseRules(rules: parts[0])
    
    let updates = parts[1].split(separator: "\n")
    
    var total = 0
    for update in updates  {
      total += checkIncorrectUpdates(update: update, ruleMap: ruleMap)
    }
    
    return total
  }
}
