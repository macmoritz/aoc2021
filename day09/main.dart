import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'explore.dart';

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

Future<bool> isLowest(x, y, heights) async {
  List<int> neighbours = [];

  if (x > 0) {
    neighbours.add(heights[x - 1][y]);
  }
  if (x + 1 < heights.length) {
    neighbours.add(heights[x + 1][y]);
  }
  if (y > 0) {
    neighbours.add(heights[x][y - 1]);
  }
  if (y + 1 < heights[0].length) {
    neighbours.add(heights[x][y + 1]);
  }

  for (final neighbour in neighbours) {
    if (heights[x][y] >= neighbour) {
      return false;
    }
  }
  return true;
}

void main(List<String> arguments) async {
  List<String> lines = [];
  String filename = 'input.txt';
  if (arguments.length == 1) {
    filename = arguments[0];
  }

  int part1 = 0;
  int part2 = 0;
  List<List<int>> heights = [];
  int x, y;

  lines = await getLines(filename);
  for (var line in lines) {
    heights.add(line.split('').map(int.parse).toList());
  }

  List<List<bool>> basinMap = List.generate(
      heights.length, (i) => List.generate(heights[0].length, (j) => false));

  List<List<int>> lowPoints = [];
  List<int> basinSizes = [];

  x = 0;
  for (final line in heights) {
    y = 0;
    for (final point in line) {
      if (await isLowest(x, y, heights)) {
        lowPoints.add([x, y]);
        part1 += 1 + point;
      }
      if (point != 9) {
        basinMap[x][y] = true;
      }
      y++;
    }
    x++;
  }
  print(basinMap[0]);
  print(basinMap[1]);
  print(basinMap[2]);
  print(basinMap[3]);
  print(basinMap[4]);

  print('found ${lowPoints.length} lowpoints');
  for (final lowPoint in lowPoints) {
    print('lowpoint: $lowPoint');
    var explore = Explore(lowPoint[0], lowPoint[1], basinMap);
    explore.explore();
    basinSizes.add(explore.basinSize);
  }
  basinSizes.sort((a, b) => a > b ? a : b);
  print(basinSizes);
  part2 = basinSizes[0] * basinSizes[1] * basinSizes[2];

  print('part 1: $part1');
  print('part 2: $part2');
}
