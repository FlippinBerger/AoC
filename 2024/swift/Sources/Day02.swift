//
//  File.swift
//  AdventOfCode
//
//  Created by Chris Berger on 12/1/24.
//

import Foundation

struct Day02: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  var reports: [[Int]] {
    data.split(separator: "\n").map {
      $0.split(separator: " ").compactMap {Int($0)}
    }
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
  
  func isReportSafe(_ report: [Int]) -> (Bool, Int) {
    let isDecreasing = report[0] > report[1]
    var last = report[0]
    
    for (index, num) in report.enumerated() {
      if index == 0 {
        continue
      }
      
      if !isDecreasing && num <= last {
        return (false, index)
      }
      
      if isDecreasing && num >= last {
        return (false, index)
      }
      
      let diff = num - last
      
      if abs(diff) > 3 {
        return (false, index)
      }
      
      last = num
    }
    
    return (true, 0)
  }
  
  func part1() -> Any {
    var safeReports = 0
    for report in reports {
      let (safe, _) = isReportSafe(report)
      if safe {
        safeReports += 1
      }
    }
    
    return safeReports
  }
 
  // 380 is highest I've seen, still too low
  func part2() -> Any {
    var safeReports = 0
      
    for var report in reports {
      var (safe, index) = isReportSafe(report)
      if !safe {
        var checkReport1 = report
        
        checkReport1.remove(at: index - 1)
        let (otherSafe, _) = isReportSafe(checkReport1)
        if otherSafe {
          safeReports += 1
          continue
        }
        
        if index > 1 {
          var checkReport2 = report
          checkReport2.remove(at: index - 2)
          let (otherSafe, _) = isReportSafe(checkReport2)
          if otherSafe {
            safeReports += 1
            continue
          }
        }
        
        report.remove(at: index)
        (safe, _) = isReportSafe(report)
        if safe {
          safeReports += 1
        }
      } else {
        safeReports += 1
      }
    }
    
    return safeReports
  }
}
