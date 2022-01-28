package main

import (
	"fmt"
	"os"
	"strings"
)

func simulate(fishs [9]uint64, days int) [9]uint64 {
	var temp uint64;
	for day := 0; day < days; day++ {
		temp = fishs[0];
		fishs[0], fishs[1], fishs[2], fishs[3], fishs[4], fishs[5], fishs[6], fishs[7], fishs[8] = fishs[1], fishs[2], fishs[3], fishs[4], fishs[5], fishs[6], fishs[7] + temp, fishs[8], temp;
	}
	return fishs
}

func main() {
	var filename string = "input.txt"

	if len(os.Args) == 2 {
		filename = os.Args[1]
	}

	input, err := os.ReadFile(filename)
	if err != nil { panic(err) }

	var initial = strings.Trim(strings.ReplaceAll(string(input), ",", ""), "\n")

	var fishs1, fishs2 = [9]uint64{0, 0, 0, 0, 0, 0, 0, 0, 0}, [9]uint64{0, 0, 0, 0, 0, 0, 0, 0, 0}
	var part1, part2 uint64 = 0, 0

	for _, fishs := range initial {
		fishs1[int(fishs) - int('0')] += 1;
		fishs2[int(fishs) - int('0')] += 1;
	}

	fishs1, fishs2 = simulate(fishs1, 80), simulate(fishs2, 256)

	for i := 0; i < 9; i++ {
		part1 += fishs1[i]
		part2 += fishs2[i]
	}

	fmt.Println("part 1:", part1, "\npart2:", part2)
}
