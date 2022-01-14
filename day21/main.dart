import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:math';

Future<List<String>> getLines(filename) async {
  List<String> lines = [];
  await new File(filename)
      .openRead()
      .map(utf8.decode)
      .transform(new LineSplitter())
      .forEach((line) {
    lines.add(line);
  });
  return lines;
}

void main(List<String> arguments) async {
  String filename = 'input.txt';
  if (arguments.length == 1) {
    filename = arguments[0];
  }

  int part1 = 0;
  int part2 = 0;

  List<String> lines = await getLines(filename);
  int player1Pos = int.parse(lines[0].split(':')[1]);
  int player2Pos = int.parse(lines[1].split(':')[1]);
  int player1Score = 0, player2Score = 0, dieRolled = 0, die = 0, steps;

  // part1
  while (true) {
    steps = (die + 1) % 100 + (die + 2) % 100 + (die + 3) % 100;
    player1Pos = (player1Pos + steps) % 10;
    player1Score += player1Pos == 0 ? 10 : player1Pos;
    die = (die + 3) % 100;
    dieRolled += 3;

    if (player1Score >= 1000) {
      part1 = player2Score * dieRolled;
      break;
    }

    steps = (die + 1) % 100 + (die + 2) % 100 + (die + 3) % 100;
    player2Pos = (player2Pos + steps) % 10;
    player2Score += player2Pos == 0 ? 10 : player2Pos;
    die = (die + 3) % 100;
    dieRolled += 3;

    if (player2Score >= 1000) {
      part1 = player1Score * dieRolled;
      break;
    }
  }

  print('part 1: $part1');
  print('part 2: $part2');
}
