package main

import (
	"fmt"
	"os"
	"sort"
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

	points1 := map[string]int{
		")": 3, "]": 57, "}": 1197, ">": 25137,
	}
	points2 := map[string]int{
		"(": 1, "[": 2, "{": 3, "<": 4,
	}

	var scores, score = []int{}, 0
	var part1, part2 = 0, 0

	lines := strings.Trim(string(input), "\n")
	for _, syntax := range strings.Split(lines, "\n") {
		for strings.Contains(syntax, "()") || strings.Contains(syntax, "[]") || strings.Contains(syntax, "{}") || strings.Contains(syntax, "<>") {
			syntax = strings.Replace(syntax, "()", "", -1)
			syntax = strings.Replace(syntax, "[]", "", -1)
			syntax = strings.Replace(syntax, "{}", "", -1)
			syntax = strings.Replace(syntax, "<>", "", -1)
		}

		if strings.Contains(syntax, ")") || strings.Contains(syntax, "]") || strings.Contains(syntax, "}") || strings.Contains(syntax, ">") {
			for _, brace := range string(syntax) {
				if val, ok := points1[string(brace)]; ok {
					part1 += val
					break
				}
			}
		} else {
			for i := len(string(syntax)) - 1; i >= 0; i-- {
				brace := string(string(syntax)[i])
				if val, ok := points2[brace]; ok {
					score = (score * 5) + val
				}
			}
			scores = append(scores, score)
			score = 0
		}
	}
	sort.Ints(scores)
	part2 = scores[len(scores)/2]
	fmt.Println("part 1:", part1, "\npart2:", part2)
}
