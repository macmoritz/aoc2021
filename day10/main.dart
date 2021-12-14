import 'dart:async';
import 'dart:io';
import 'dart:convert';

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

Future<int> getOpenCount(List<String> line) async {
  int count = 0;
  for (final brace in line) {
    if (brace == '(' || brace == '[' || brace == '{' || brace == '<') {
      count += 1;
    }
  }
  return count;
}

void main(List<String> arguments) async {
  String filename = 'input.txt';
  if (arguments.length == 1) {
    filename = arguments[0];
  }

  List<String> lines = await getLines(filename);

  int part1 = 0;
  int part2 = 0, score;
  Map<String, String> pairs = {')': '(', ']': '[', '}': '{', '>': '<'};
  List<String> currentOpen = [];
  List<int> scores = [];
  bool lineIsCorrupt = false;

  for (final line in lines) {
    currentOpen = [];
    lineIsCorrupt = false;
    for (final brace in line.split('')) {
      if (brace == '(' || brace == '[' || brace == '{' || brace == '<') {
        currentOpen.add(brace);
      } else {
        if (pairs[brace] == currentOpen.last) {
          currentOpen.removeLast();
        } else {
          switch (brace) {
            case ')':
              part1 += 3;
              break;
            case ']':
              part1 += 57;
              break;
            case '}':
              part1 += 1197;
              break;
            case '>':
              part1 += 25137;
              break;
          }
          if (brace == ')' || brace == ']' || brace == '}' || brace == '>') {
            lineIsCorrupt = true;
            break;
          }
        }
      }
    }
    if (!lineIsCorrupt) {
      score = 0;
      for (final brace in currentOpen.reversed.toList()) {
        switch (brace) {
          case '(':
            score = (score * 5) + 1;
            break;
          case '[':
            score = (score * 5) + 2;
            break;
          case '{':
            score = (score * 5) + 3;
            break;
          case '<':
            score = (score * 5) + 4;
            break;
        }
      }
      scores.add(score);
    }
  }

  scores.sort();
  part2 = scores[(scores.length / 2).floor()];
  print('part 1: $part1');
  print('part 2: $part2');
}
