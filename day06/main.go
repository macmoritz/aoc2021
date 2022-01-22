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
		fishs[0] = fishs[1];
		fishs[1] = fishs[2];
		fishs[2] = fishs[3];
		fishs[3] = fishs[4];
		fishs[4] = fishs[5];
		fishs[5] = fishs[6];
		fishs[6] = fishs[7] + temp;
		fishs[7] = fishs[8];
		fishs[8] = temp;
	}
	return fishs
}

func main() {
	var filename string = "input.txt"

	if len(os.Args) == 2 {
		filename = os.Args[1]
	}

	data, err := os.ReadFile(filename)
	if err != nil {
		panic(err)
	}
	var init = strings.Trim(strings.ReplaceAll(string(data), ",", ""), "\n")

	var fishs1 = [9]uint64{0, 0, 0, 0, 0, 0, 0, 0, 0}
	var fishs2 = [9]uint64{0, 0, 0, 0, 0, 0, 0, 0, 0}
	var part1, part2 uint64 = 0, 0

	for _, fishs := range init {
		fishs1[int(fishs) - int('0')] += 1;
		fishs2[int(fishs) - int('0')] += 1;
	}

	fishs1 = simulate(fishs1, 80)
	fishs2 = simulate(fishs2, 256)
	// fishs2 = simulate(fishs2, 9999999999)

	for i := 0; i < 9; i++ {
		part1 += fishs1[i]
		part2 += fishs2[i]
	}

	fmt.Println("part 1:", part1)
	fmt.Println("part 2:", part2)
}
