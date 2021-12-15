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

List<List<int>> getNeighbours(height, width, List<int> coords) {
  List<List<int>> fieldNeighbours = [];
  int x = coords[0], y = coords[1];

  if (x > 0) {
    fieldNeighbours.add([x - 1, y]);
  }
  if (x + 1 < height) {
    fieldNeighbours.add([x + 1, y]);
  }
  if (y > 0) {
    fieldNeighbours.add([x, y - 1]);
  }
  if (y + 1 < width) {
    fieldNeighbours.add([x, y + 1]);
  }
  return fieldNeighbours;
}

void main(List<String> arguments) async {
  String filename = 'input.txt';
  if (arguments.length == 1) {
    filename = arguments[0];
  }

  int part1 = 0;
  int part2 = 0;

  List<String> lines = await getLines(filename);
  List<List<int>> cave = [];
  for (final line in lines) {
    cave.add(line.split('').map(int.parse).toList());
  }

  List<List<List<int>>> paths = [];

  int riskLevel = 0;
  List<List<int>> path = [];

  while () {

  }

  // for (final path in paths) {
  //   path.forEach((e) {
  //     riskLevel += cave[e[0]][e[1]];
  //   });
  //   pathRiskLevel.add(riskLevel);
  //   riskLevel = 0;
  // }

  // print(pathRiskLevel.reduce(min));

  print('part 1: $part1');
  print('part 2: $part2');
}
