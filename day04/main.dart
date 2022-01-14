import 'dart:async';
import 'dart:io';
import 'dart:convert';

Future<List<String>> getLines(filename) async {
  List<String> lines = [];
  await new File(filename)
      .openRead()
      .map(utf8.decode)
      .transform(new LineSplitter())
      .forEach((line) => line != "" ? lines.add(line) : 0);
  return lines;
}

bool checkCard(card, balls) {
  for (int j = 0; j < 5; j++) {
    if (balls.contains(card[j][0]) &&
        balls.contains(card[j][1]) &&
        balls.contains(card[j][2]) &&
        balls.contains(card[j][3]) &&
        balls.contains(card[j][4])) {
      return true;
    }
    if (balls.contains(card[0][j]) &&
        balls.contains(card[1][j]) &&
        balls.contains(card[2][j]) &&
        balls.contains(card[3][j]) &&
        balls.contains(card[4][j])) {
      return true;
    }
  }
  return false;
}

Future<int> calcScore(card, balls) async {
  int score = 0;
  for (final row in card) {
    for (final col in row) {
      if (!balls.contains(col)) {
        score += col! as int;
      }
    }
  }
  return score;
}

void main(List<String> arguments) async {
  List<String> lines = [];
  String filename = 'input.txt';
  if (arguments.length == 1) {
    filename = arguments[0];
  }

  int part1 = 0;
  int part2 = 0;
  List<List<List<int>>> cards = [];
  List<int> usedBalls = [], scores = [];

  lines = await getLines(filename);
  List<int> balls = lines[0].split(',').map(int.parse).toList();
  lines.removeAt(0);

  List<List<int>> card = [];
  List<String> tmpLine = [];
  int linecounter = 0;
  for (var line in lines) {
    tmpLine = line.split(' ');
    tmpLine.removeWhere((v) => v == '');
    card.add(tmpLine.map(int.parse).toList());
    if (linecounter == 4) {
      cards.add(card);
      card = [];
      linecounter = 0;
    } else {
      linecounter++;
    }
  }

  for (final ball in balls) {
    usedBalls.add(ball);
    for (final card in cards) {
      if (checkCard(card, usedBalls)) {
        int score = (await calcScore(card, usedBalls)) * ball;
        scores.add(score);
      }
    }
    cards.removeWhere((card) => checkCard(card, usedBalls));
  }

  part1 = scores[0];
  part2 = scores[scores.length - 1];
  print('part 1: $part1');
  print('part 2: $part2');
}
