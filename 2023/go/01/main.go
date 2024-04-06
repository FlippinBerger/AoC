package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"unicode"
)

func main() {
    file, err := os.Open("input.txt")
    if err != nil {
        fmt.Println("unable to open file")
    }

    scanner := bufio.NewScanner(file)

    totalSum := 0
    var first *rune
    var last *rune
    for scanner.Scan() {
        line := scanner.Text()
        for i, r := range line {
            if unicode.IsDigit(r) {
                if first == nil {
                    first = &r
                } else {
                    last = &r
                }
                continue
            }

            numRune, found := checkNumberString(r, line, i)
            if found {
                if first == nil {
                    first = &numRune
                } else {
                    last = &numRune
                }
            }
        }

        if last == nil {
            last = first
        }

        numberS := fmt.Sprintf("%c%c", *first, *last)
        i, err := strconv.Atoi(numberS)
        if err != nil {
            fmt.Printf("couldn't parse %s to int with err: %s\n", numberS, err)
        }

        // fmt.Printf("i is %d\n", i)
        // return

        totalSum += i

        first = nil
        last = nil
    }

    // 56042 is part 1 answer
    // 55358 is part 2 answer
    fmt.Println("total sum: ", totalSum)
}

func checkNumberString(r rune, s string, i int) (rune, bool) {
    // fmt.Printf("%c %s %d %s\n", r, s, i, s[i:])
    // fmt.Println("checking num string")
    length := len(s)
    switch r {
    case 'o':
        if i+3 <= length && s[i:i+3] == "one" {
            return '1', true
        } 
    case 't':
        if i+3 <= length && s[i:i+3] == "two" {
            return '2', true
        }
        if i+5 <= length && s[i:i+5] == "three" {
            return '3', true
        }
    case 'f':
        if i+4 <= length && s[i:i+4] == "four" {
            return '4', true
        }
        if i+4 <= length && s[i:i+4] == "five" {
            return '5', true
        }
    case 's':
        if i+3 <= length && s[i:i+3] == "six" {
            return '6', true
        }
        if i+5 <= length && s[i:i+5] == "seven" {
            return '7', true
        }
    case 'e':
        if i+5 <= length && s[i:i+5] == "eight" {
            return '8', true
        }
    case 'n':
        if i+4 <= length && s[i:i+4] == "nine" {
            return '9', true
        }
    }
    return 'x', false
}
