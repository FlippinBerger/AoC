package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"unicode"
)

func main() {
	// read in the entire file first
	file, err := os.Open("input.txt")
	if err != nil {
		fmt.Println("unable to open input file")
	}

	var engine []string

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		engine = append(engine, scanner.Text())
	}

	schematicSum := 0
    gearRatios := 0

	count := 0

	for i := range engine {
		numString := ""
		start := 0
		started := false
		for j, c := range engine[i] {
			if unicode.IsDigit(c) {
				numString += string(c)
				if !started {
					start = j
					started = true
				}
			} else if numString != "" {
				found := lookForSymbol(engine, numString, i, start)
				if found {
					n, err := strconv.Atoi(numString)
					if err != nil {
						fmt.Println("couldnt parse the numstring")
					}

					schematicSum += n
				}
				started = false
				numString = ""
				count++

				// if count > 11 {
				// 	return
				// }
			}
            if c == '*' {
                num, found := checkGear(engine, i, j)
                if found {
                    gearRatios += num     
                }
            }
		}

		if numString != "" {
			found := lookForSymbol(engine, numString, i, start)
			if found {
				n, err := strconv.Atoi(numString)
				if err != nil {
					fmt.Println("couldnt parse the numstring")
				}

				schematicSum += n
			}
		}
	}

	// 535,607 is too high
    // 529,618 for part 1
	fmt.Println("schematic sum", schematicSum)

    // 64,820,538 is too low
    // 77,439,565 is also too low
    // 77,509,019 for part 2
    fmt.Println("gear ratio sum", gearRatios)
}

func lookForSymbol(engine []string, num string, row, col_start int) bool {
	for i := row - 1; i < row+2; i++ {
		if i < 0 || i > len(engine)-1 {
			continue
		}
		for j := col_start - 1; j < col_start - 1 + len(num) + 2; j++ {
			if j < 0 || j > len(engine[0])-1 {
				continue
			}
			r := rune(engine[i][j])

			if !unicode.IsDigit(r) && r != '.' {
				return true
			}
		}
	}

	return false
}

func checkGear(engine []string, row, col int) (int, bool) {
    var adjacentParts []int
    for i := row - 1; i < row + 2; i++ {
		if i < 0 || i > len(engine)-1 {
			continue
		}
		for j := col - 1; j < col - 1 + 3; j++ { 
			if j < 0 || j > len(engine[0])-1 {
				continue
			}

            r := rune(engine[i][j])

            if unicode.IsDigit(r) {
                partNum, end := getNum(engine, i, j)
                adjacentParts = append(adjacentParts, partNum)
                j = end - 1
            }
        }
    }

    fmt.Println("at the end of adjacent parts", adjacentParts)

    if len(adjacentParts) == 2 {
        return adjacentParts[0] * adjacentParts[1], true
    }

    return -1, false
}

func getNum(engine []string, row, col int) (int, int) {
    start := 0
    end := 0
    for i := col - 1; i >= 0; i-- {
        if !unicode.IsDigit(rune(engine[row][i])) {
            start = i + 1
            break
        }
    }

    for i := col; i < len(engine[row]); i++ {
        if !unicode.IsDigit(rune(engine[row][i])) {
            end = i
            break
        } else if i == len(engine[row]) - 1 {
            end = len(engine[row])
        }
    }
    
    fmt.Printf("start and end are %d and %d\n", start, end)


    numS := engine[row][start:end]

    fmt.Println("numS at the end of getNum is", numS)

    num, err := strconv.Atoi(numS)
    if err != nil {
        fmt.Println("unable to convert num in getNum function:", num)
    }

    return num, end
}
