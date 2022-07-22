package main

import (
	"fmt"
	"os"
	"strings"
)

func main() {
	var filename string = "input.txt"

	if len(os.Args) == 2 {
		filename = os.Args[1]
	}

	input, err := os.ReadFile(filename)
	if err != nil {
		panic(err)
	}

	var rows string = strings.Trim(string(input), "\n")
	var cave [][]int
	for _, row := range strings.Split(rows, "\n") {
		var col []int
		for _, risk := range row {
			col = append(col, int(risk)-int('0'))
		}
		cave = append(cave, col)
	}
	fmt.Println(cave)
}
