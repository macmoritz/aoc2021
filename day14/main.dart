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

Map<String, int> process(polymer, rules, steps) {
  Map<String, int> newPolymer = {};
  for (int step = 0; step < steps; step++) {
    for (final poly in polymer.keys) {
      String? insert = rules[poly];
      if (insert != null) {
        newPolymer[poly.substring(0, 1) + insert] =
            (newPolymer[poly.substring(0, 1) + insert] ?? 0) + polymer[poly]!
                as int;
        newPolymer[insert + poly.substring(1, 2)] =
            (newPolymer[insert + poly.substring(1, 2)] ?? 0) + polymer[poly]!
                as int;
      } else {
        newPolymer[poly] = 1;
      }
    }
    polymer = newPolymer;
    newPolymer = {};
  }
  return polymer;
}

void main(List<String> arguments) async {
  String filename = 'input.txt';
  if (arguments.length == 1) {
    filename = arguments[0];
  }

  int part1 = 0, steps1 = 10;
  int part2 = 0, steps2 = 40;

  List<String> lines = await getLines(filename);
  Map<String, int> polymer1 = {}, polymer2 = {};
  Map<String, String> rules = {};

  String startvalue = lines[0];
  for (int i = 0; i < startvalue.length - 1; i++) {
    polymer1[startvalue[i] + startvalue[i + 1]] =
        (polymer1[startvalue[i] + startvalue[i + 1]] ?? 0) + 1;
  }
  polymer2 = {...polymer1};
  print(polymer1);

  for (final line in lines) {
    if (line.contains('->')) {
      rules[line.split(' -> ')[0]] = line.split(' -> ')[1];
    }
  }

  polymer1 = process(polymer1, rules, steps1);
  polymer2 = process(polymer2, rules, steps2);

  Map<String, int> results1 = {}, results2 = {};

  for (final poly in polymer1.keys) {
    results1[poly.substring(0, 1)] =
        (results1[poly.substring(0, 1)] ?? 0) + polymer1[poly]!;
    results1[poly.substring(1, 2)] =
        (results1[poly.substring(1, 2)] ?? 0) + polymer1[poly]!;
  }

  for (final poly in polymer2.keys) {
    results2[poly.substring(0, 1)] =
        (results2[poly.substring(0, 1)] ?? 0) + polymer2[poly]!;
    results2[poly.substring(1, 2)] =
        (results2[poly.substring(1, 2)] ?? 0) + polymer2[poly]!;
  }

  for (final result in results1.keys) {
    results1[result] = (results1[result]! / 2).ceil();
  }
  for (final result in results2.keys) {
    results2[result] = (results2[result]! / 2).ceil();
  }

  print(polymer1);
  print(results1);
  part1 = results1.values.reduce(max) - results1.values.reduce(min);
  part2 = results2.values.reduce(max) - results2.values.reduce(min);

  print('part 1: $part1');
  print('part 2: $part2');
}
