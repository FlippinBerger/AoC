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
        fmt.Println("unable to open input file")
    }

    totalPoints := 0
    totalCards := 0

    // initialize the cards
    cardArr := make([]int, 197)
    for i := range cardArr {
        cardArr[i] = 1
    }

    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        line := scanner.Text()

        cardInfo := strings.Split(line, ":")
        cardS := strings.Fields(cardInfo[0])[1]
        cardNum, err := strconv.Atoi(cardS)
        if err != nil {
            fmt.Println("unable to parse card number")
        }

        cardNumbers := strings.Split(strings.TrimSpace(cardInfo[1]), "|")

        winningNumbers := make(map[string]struct{})


        for _, winner := range strings.Fields(cardNumbers[0]) {
            winningNumbers[winner] = struct{}{}
        }

        ptsOnCard := 0
        winnersOnCard := 0

        for _, chancer := range strings.Fields(cardNumbers[1]) {
            if _, ok := winningNumbers[chancer]; ok {
                winnersOnCard++
                if ptsOnCard == 0 {
                    ptsOnCard++
                } else {
                    ptsOnCard = ptsOnCard << 1
                }
            }
        }

        for i := cardNum; i < cardNum + winnersOnCard; i++ {
            cardArr[i] += cardArr[cardNum - 1]
        }

        totalPoints += ptsOnCard
        totalCards += cardArr[cardNum - 1]
    }

    // 22,193 is part 1
    fmt.Println("total points", totalPoints)

    // 5,625,994 is part 2
    fmt.Println("total cards", totalCards)
}
