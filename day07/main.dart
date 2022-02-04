import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:math';

Future<List<String>> getLines(filename) async {
  List<String> lines = [];
  await new File(filename).openRead().map(utf8.decode).transform(new LineSplitter()).forEach((line) {
    lines.add(line);
  });
  return lines;
}

void main(List<String> arguments) async {
  List<String> lines = [];
  String filename = 'input.txt';
  if (arguments.length == 1) {
    filename = arguments[0];
  }

  int part1 = 0;
  int part2 = 0;

  lines = await getLines(filename);
  List<int> crabs = lines[0].split(',').map(int.parse).toList();
  List<int> constantFuel = List.filled(crabs.reduce(max) - crabs.reduce(min) + 1, 0);
  List<int> incrementalFuel = List.filled(crabs.reduce(max) - crabs.reduce(min) + 1, 0);

  for (int i = crabs.reduce(min); i <= crabs.reduce(max); i++) {
    constantFuel[i] = 0;
    for (final crab in crabs) {
      constantFuel[i] += (i - crab).abs();
      for (int j = (i - crab).abs(); j > 0; j--) {
        incrementalFuel[i] += j;
      }
    }
  }
  part1 = constantFuel.reduce(min);
  part2 = incrementalFuel.reduce(min);

  print('part 1: $part1 ${constantFuel.indexOf(part1)}');
  print('part 2: $part2 ${incrementalFuel.indexOf(part2)}');
}
