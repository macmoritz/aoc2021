package main

import (
	"fmt"
	"math"
	"os"
	"sort"
	"strings"
)

func getFromMapOrDefault(poly map[string]int, key string, def int) int {
	if value, ok := poly[key]; ok {
		return value
	}
	return def
}

func tryInitMapValue(poly map[string]int, key string, value int) map[string]int {
	if _, ok := poly[key]; !ok {
		poly[key] = value
	}
	return poly
}

func pairInsertion(polymer map[string]int, rules map[string]string, steps int) map[string]int {
	newPolymer := make(map[string]int)
	for i := 0; i < steps; i++ {
		for poly, value := range polymer {
			if insert, ok := rules[poly]; ok {
				newPolymer[poly[:1]+insert] += value
				newPolymer[insert+poly[1:]] += value
			} else {
				newPolymer[poly] = 1
			}
		}
		polymer = newPolymer
		newPolymer = make(map[string]int)
	}
	return polymer
}

func getQuantity(polymer map[string]int) int {
	results := make(map[string]int)
	for poly, count := range polymer {
		tryInitMapValue(results, poly[:1], 0)
		tryInitMapValue(results, poly[1:], 0)
		results[poly[:1]] += count
		results[poly[1:]] += count
	}
	var values []int
	for _, value := range results {
		// values = append(values, value)
		values = append(values, int(math.Ceil(float64(value)/2)))
	}
	sort.Ints(values)
	return values[len(values)-1] - values[0]
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

	polymer := make(map[string]int)
	rules := make(map[string]string)
	lines := strings.Trim(string(input), "\n")
	lines = strings.Replace(lines, "\n\n", "\n", -1)
	for _, line := range strings.Split(lines, "\n") {
		if !strings.Contains(line, " -> ") {
			for i := 0; i < len(line)-1; i++ {
				var poly string = line[i : i+2]
				polymer[poly] = getFromMapOrDefault(polymer, poly, 0) + 1
			}
		} else {
			pair := strings.Split(line, " -> ")[0]
			element := strings.Split(line, " -> ")[1]
			rules[pair] = element
		}
	}
	polymer = pairInsertion(polymer, rules, 10)
	fmt.Println("Part 1: ", getQuantity(polymer))
	polymer = pairInsertion(polymer, rules, 30)
	fmt.Println("Part 2: ", getQuantity(polymer))
}
