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
  String polymer = lines[0];
  String insertions = '';
  Map<String, String> rules = {};
  Map<String, int> elements = {};

  for (final line in lines) {
    if (line.contains('->')) {
      rules[line.split(' -> ')[0]] = line.split(' -> ')[1];
    }
  }

  for (int step = 0; step < 10; step++) {
    for (int i = 0; i < polymer.length - 1; i++) {
      if (rules.containsKey(polymer.substring(i, i + 2))) {
        insertions += rules[polymer.substring(i, i + 2)]!;
      }
    }

    for (int ii = 1, c = 0; c < insertions.length; ii += 2, c++) {
      polymer =
          polymer.substring(0, ii) + insertions[c] + polymer.substring(ii);
    }
    insertions = '';
  }

  for (final letter in polymer.split('')) {
    if (!elements.containsKey(letter)) {
      elements[letter] = letter.allMatches(polymer).length;
    }
  }

  part1 = elements.values.reduce(max) - elements.values.reduce(min);

  print('part 1: $part1');
  print('part 2: $part2');
}
