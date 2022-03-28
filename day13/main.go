package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

type dot struct {
	x int
	y int
}

func main() {
	var filename string = "input.txt"
	if len(os.Args) == 2 {
		filename = os.Args[1]
	}
	input, err := os.ReadFile(filename)
	if err != nil {
		panic(err)
	}

	var dots = []dot{}
	lines := strings.Trim(string(input), "\n")
	for _, coords := range strings.Split(lines, "\n") {
		if strings.Contains(coords, ",") {
			c := strings.Split(coords, ",")
			fmt.Println(c[0], c[1])
			d := dot{val, _ = strconv.ParseInt(c[0], 10, 16); val, strconv.ParseInt(c[1], 10, 16)}
			append(dots, d)

		} else if strings.Contains(coords, "x") {
			fmt.Println(strings.Split(coords, "=")[1])
		}
	}
	fmt.Println(dots)
}
