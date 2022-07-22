package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

type Player struct {
	position uint32
	score    uint32
}

type Die struct {
	score  uint8
	rolled uint16
}

func (die *Die) roll() uint8 {
	var steps uint8 = (die.score+1)%100 + (die.score+2)%100 + (die.score+3)%100
	fmt.Printf("%d + %d + %d", (die.score+1)%100, (die.score+2)%100, (die.score+3)%100)
	die.rolled += 3
	die.score = (die.score + 3) % 100
	return steps
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

	var initial = strings.Split(string(input), "\n")
	die := Die{score: 0, rolled: 0}
	player1 := Player{position: 0, score: 0}
	player2 := Player{position: 0, score: 0}

	if val, err := strconv.ParseInt(strings.Trim(strings.Split(initial[0], ":")[1], " "), 10, 32); err != nil {
		fmt.Printf(err.Error())
		os.Exit(3)
	} else {
		player1.position = uint32(val)
	}

	if val, err := strconv.ParseInt(strings.Trim(strings.Split(initial[1], ":")[1], " "), 10, 32); err != nil {
		fmt.Printf(err.Error())
		os.Exit(3)
	} else {
		player2.position = uint32(val)
	}
	fmt.Printf("p1 starts at %d\np2 starts at %d\n", player1.position, player2.position)

	for true {
		fmt.Print("Player 1 rolls ")
		player1.position = (player1.position + uint32(die.roll())) % 10
		fmt.Printf(" and moves to space %d for a total score of %d\n", player1.position, player1.score)
		if player1.position == 0 {
			player1.score += 10
		} else {
			player1.score += player1.position
		}

		if player1.score >= 1000 {
			fmt.Printf("player1 wins; %d * %d = %d\n", player2.score, die.rolled, (player2.score * uint32(die.rolled)))
			break
		}

		fmt.Print("Player 2 rolls ")
		player2.position = (player2.position + uint32(die.roll())) % 10
		fmt.Printf(" and moves to space %d for a total score of %d\n", player2.position, player2.score)
		if player2.position == 0 {
			player2.score += 10
		} else {
			player2.score += player2.position
		}

		if player2.score >= 1000 {
			fmt.Printf("player2 wins; %d * %d = %d\n", player1.score, die.rolled, (player1.score * uint32(die.rolled)))
			break
		}
	}
}
