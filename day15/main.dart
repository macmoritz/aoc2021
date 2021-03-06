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

List<List<List<int>>> createPaths(List<List<int>> cave, List<List<int>> path) {
  List<List<List<int>>> paths = [];

  List<int> lastElement = path.removeLast();
  // print(path);
  // if (path.any((e) => listEquals(e, lastElement))) {
  if (path.containsElement(lastElement)) {
    // path.add(lastElement);
    print('wait i was here ($lastElement) before: $path');
    return [];
  } else {
    path.add(lastElement);
    if (path.last[0] == cave.length - 1 && path.last[1] == cave[0].length - 1) {
      return [path];
    }
  }

  List<List<int>> neighbours = [];
  neighbours =
      getNeighbours(cave.length, cave[0].length, [path.last[0], path.last[1]])
          .where((neighbour) => !path.contains(neighbour))
          .toList();

  neighbours.forEach((element) {
    paths.addAll(createPaths(cave, [...path, element]));
  });

  return paths;
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

  List<List<List<int>>> paths = createPaths(cave, [
    [0, 0]
  ]);
  print(paths);

  int riskLevel = 0;

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

extension on List {
  bool containsElement(element) {
    for (final e in this) {
      if (e == element) {
        print('${e} is ${element}');
        return true;
      }
    }
    return false;
  }
}

bool listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  if (identical(a, b)) return true;
  for (int index = 0; index < a.length; index += 1) {
    if (a[index] != b[index]) return false;
  }
  return true;
}
