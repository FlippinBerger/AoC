package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	file, err := os.Open("input.txt")
	if err != nil {
		fmt.Println("Unable to read input.txt")
	}

	idSum := 0
    powSum := 0

	scanner := bufio.NewScanner(file)

	for scanner.Scan() {
		line := scanner.Text()
		lineSplit := strings.Split(line, ":")

		gameInfo := lineSplit[0]
		gameId := strings.Split(gameInfo, " ")[1]
		gId, err := strconv.Atoi(gameId)
		if err != nil {
			fmt.Println("game id can't be parsed to an int")
		}

		pulls := lineSplit[1]
		ballCounts := strings.Split(pulls, ";")

		linePossible := true
        fewestRed := 0
        fewestGreen := 0
        fewestBlue := 0
		for _, counts := range ballCounts {
            possible := countPossible(strings.TrimSpace(counts), &fewestRed, &fewestGreen, &fewestBlue)
			if !possible {
				linePossible = false
			}
		}

        powSum += fewestRed * fewestGreen * fewestBlue

		if linePossible {
			idSum += gId
		}
	}

    // 2505 for part 1
	fmt.Println("ID sum", idSum)

    fmt.Println("pow sum", powSum)
}

func countPossible(counts string, fewestRed, fewestGreen, fewestBlue *int) bool {
	countInfo := strings.Split(counts, ",")

    flag := true

	for _, ballCount := range countInfo {
        ballCount = strings.TrimSpace(ballCount)

		count := strings.Split(ballCount, " ")

		num, err := strconv.Atoi(strings.TrimSpace(count[0]))
		if err != nil {
			fmt.Println("unable to parse ball count")
		}

		switch count[1] {
		case "red":
            if num > *fewestRed {
                *fewestRed = num
            }
			if num > 12 {
				flag = false
			}
		case "green":
            if num > *fewestGreen {
                *fewestGreen = num
            }
			if num > 13 {
				flag = false
			}
		case "blue":
            if num > *fewestBlue {
                *fewestBlue = num
            }
			if num > 14 {
				flag = false
			}
		}
	}

	return flag
}
