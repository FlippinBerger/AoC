package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
)

// an improvement in speed here is to have a pool of workers to actually
// take the input string and calculate it. Then we can have all the scanned
// strings ready to go while doing work on them

func main() {
	file, err := os.Open("./input.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	numBoxesWithTwo := 0
	numBoxesWithThree := 0

	scanner := bufio.NewScanner(file)

	id := ""
	ids := make([]string, 0)

	for scanner.Scan() {
		id = scanner.Text()
		ids = append(ids, id)

		runes := make(map[rune]int)

		for _, char := range id {
			if _, ok := runes[char]; ok {
				runes[char]++
			} else {
				runes[char] = 1
			}
		}

		// now we built up our map of runes, we need to go through and see how
		// many of them have exactly 2 or 3 of the rune
		addedToTwoBox := false
		addedToThreeBox := false
		for _, num := range runes {
			switch num {
			case 2:
				if !addedToTwoBox {
					numBoxesWithTwo++
					addedToTwoBox = true
				}
			case 3:
				if !addedToThreeBox {
					numBoxesWithThree++
					addedToThreeBox = true
				}
			}
		}
	}

	fmt.Println(numBoxesWithTwo * numBoxesWithThree)

	for i, id := range ids {
		if i == len(ids)-1 {
			break
		}

		for j := i + 1; j < len(ids); j++ {
			if pos, ok := areSimilar(id, ids[j]); ok {
				fmt.Println(removeCharFromPos(id, pos))
				return
			}
		}
	}
}

func areSimilar(id1, id2 string) (int, bool) {
	pos := 0
	foundDifference := false
	for i := 0; i < len(id1); i++ {
		if id1[i] != id2[i] {
			if foundDifference {
				return 0, false
			}
			pos = i
			foundDifference = true
		}
	}
	return pos, foundDifference
}

func removeCharFromPos(id string, pos int) string {
	return id[:pos] + id[pos+1:]
}
