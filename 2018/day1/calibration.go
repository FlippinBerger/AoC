package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
)

func main() {
	file, err := os.Open("./input.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	freq := 0
	inputList := make([]int, 0)
	frequenciesFound := make(map[int]bool)
	foundDuplicate := false

	// we start at 0
	frequenciesFound[0] = true

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		num, err := strconv.Atoi(scanner.Text())
		if err != nil {
			continue
		}

		inputList = append(inputList, num)
		freq += num

		if _, ok := frequenciesFound[freq]; ok {
			foundDuplicate = true
			break
		} else {
			frequenciesFound[freq] = true
		}
	}

	fmt.Println(inputList)

	// if we didn't find the duplicate we need to endlessly loop through
	// the input list until we find it
	if !foundDuplicate {
		for {
			if foundDuplicate {
				break
			}
			for _, num := range inputList {
				freq += num

				if _, ok := frequenciesFound[freq]; ok {
					foundDuplicate = true
					break
				} else {
					frequenciesFound[freq] = true
				}
			}
		}
	}

	if foundDuplicate {
		fmt.Println("we found it")
	}

	fmt.Println(freq)
}
