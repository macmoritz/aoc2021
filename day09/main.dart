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

  List<List<bool>> basinMap =
      List.filled(heights.length, List.filled(heights[0].length, false));

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
      if (point < 9) {
        basinMap[x][y] = true;
      }
      // print('x: $x $basinMap');
      // print('\n');
      y++;
    }
    x++;
  }
  print(basinMap);

  for (final lowPoint in lowPoints) {
    var explore = Explore(lowPoint[0], lowPoint[1], basinMap);
    while (explore.toExplore.length > 0) {
      explore.exploreNext();
    }
    basinSizes.add(explore.basinSize);
  }
  basinSizes.sort((a, b) => a > b ? a : b);
  part2 = basinSizes[0] * basinSizes[1] * basinSizes[2];

  print('part 1: $part1');
  print('part 2: $part2');
}
