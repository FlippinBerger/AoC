package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type Race struct {
    time int
    distance int
}

func main() {
    file, err := os.Open("input.txt")
    if err != nil {
        fmt.Println("couldnt open input")
    }

    races := make([]Race, 4)

    scanner := bufio.NewScanner(file)
    scanner.Scan()
    timeLine := strings.Split(scanner.Text(), ":")[1]

    scanner.Scan()
    recordLine := strings.Split(scanner.Text(), ":")[1]

    fmt.Println("time", timeLine)
    fmt.Println("record", recordLine)

    timeWithK := ""
    recordWithK := ""

    for i, num := range strings.Fields(timeLine) {
        timeWithK += num
        n, _ := strconv.Atoi(num)
        races[i].time = n
    }

    for i, num := range strings.Fields(recordLine) {
        recordWithK += num
        n, _ := strconv.Atoi(num)
        races[i].distance = n
    }

    tk, _ := strconv.Atoi(timeWithK)
    rk, _ := strconv.Atoi(recordWithK)

    ways := 1

    for _, race := range races {
        ways *= countWaysToBeat(race)
    }

    // 1,312,850 is the right answer for part 1
    fmt.Println("ways to win", ways)

    // 36,749,103 for part 2 
    bigRace := Race{time: tk, distance: rk}
    fmt.Println("long race ways", countWaysToBeat(bigRace))
}

func countWaysToBeat(race Race) int {
    ways := 0

    for i := 0; i < race.time + 1; i++ {
        remainingTime := race.time - i
        distanceTraveled := remainingTime * i

        if distanceTraveled > race.distance {
            ways++
        }
    }

    fmt.Println("ways to win", ways)
    return ways
}
