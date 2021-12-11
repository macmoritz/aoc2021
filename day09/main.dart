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

bool containsAsString(List list, element) {
  for (final item in list) {
    if (item.toString() == element.toString()) {
      return true;
    }
  }
  return false;
}

List<List<int>> getNeighbours(int x, int y, visited, basinMap) {
  List<List<int>> neighbours = [];
  if (x > 0) {
    if (basinMap[x - 1][y] && !containsAsString(visited, [x - 1, y])) {
      neighbours.add([x - 1, y]);
    }
  }
  if (x + 1 < basinMap.length) {
    if (basinMap[x + 1][y] && !containsAsString(visited, [x + 1, y])) {
      neighbours.add([x + 1, y]);
    }
  }
  if (y > 0) {
    if (basinMap[x][y - 1] && !containsAsString(visited, [x, y - 1])) {
      neighbours.add([x, y - 1]);
    }
  }
  if (y + 1 < basinMap[0].length) {
    if (basinMap[x][y + 1] && !containsAsString(visited, [x, y + 1])) {
      neighbours.add([x, y + 1]);
    }
  }

  return neighbours;
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

  int basinSize = 0;
  List<List<int>> visited = [];
  List<List<int>> neighbours = [];
  List<int> point = [];
  for (final lowPoint in lowPoints) {
    basinSize = 0;
    visited = [];
    neighbours = [lowPoint];
    while (neighbours.length > 0) {
      point = neighbours.removeAt(0);
      x = point[0];
      y = point[1];
      var next = getNeighbours(x, y, visited, basinMap);
      neighbours.addAll(next);
      visited.addAll(next);
      basinSize += next.length;
    }
    basinSizes.add(basinSize);
  }
  basinSizes.sort((a, b) => b.compareTo(a));
  part2 = basinSizes[0] * basinSizes[1] * basinSizes[2];

  print('part 1: $part1');
  print('part 2: $part2');
}
