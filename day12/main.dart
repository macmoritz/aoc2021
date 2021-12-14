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

bool isUppercase(String string) {
  final allCapitals = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  return allCapitals.contains(string[0]);
}

bool containsAsString(List list, element) {
  for (final item in list) {
    if (item.toString() == element.toString()) {
      return true;
    }
  }
  return false;
}

int countDuplicates(List<String> path) {
  int count = 0;
  for (int i = 0; i < path.length; i++) {
    if (!isUppercase(path[i])) {
      for (int j = i + 1; j < path.length; j++) {
        if (path[i] == path[j]) {
          count++;
        }
      }
    }
  }
  return count;
}

List<List<String>> createPaths(
    Map<String, List<String>> caveSystem, List<String> path, bool part2) {
  List<List<String>> paths = [];

  if (part2) {
    if (countDuplicates(path) > 1 || !caveSystem.containsKey(path.last)) {
      return [];
    } else if (path.last == 'end') {
      return [path];
    }
  } else {
    if (path.last == 'end') {
      return [path];
    } else if (!caveSystem.containsKey(path.last)) {
      return [];
    }
  }

  List<String> nextStops = [];
  if (part2) {
    nextStops = caveSystem[path.last]!
        .where((endpoint) => endpoint != 'start')
        .toList();
  } else {
    nextStops = caveSystem[path.last]!
        .where((endpoint) => isUppercase(endpoint) || !path.contains(endpoint))
        .toList();
  }

  nextStops.forEach((element) {
    paths.addAll(createPaths(caveSystem, [...path, element], part2));
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
  Map<String, List<String>>? caveSystem = new Map();
  String tempA, tempB;

  for (final line in lines) {
    tempA = line.split('-')[0];
    tempB = line.split('-')[1];

    if (caveSystem.containsKey(tempA)) {
      caveSystem[tempA]?.add(tempB);
    } else {
      caveSystem[tempA] = [tempB];
    }
    if (caveSystem.containsKey(tempB)) {
      caveSystem[tempB]?.add(tempA);
    } else {
      caveSystem[tempB] = [tempA];
    }
  }

  List<List<String>> paths1 = createPaths(caveSystem, ["start"], false);
  part1 = paths1.length;

  List<List<String>> paths2 = createPaths(caveSystem, ["start"], true);
  part2 = paths2.length;

  print('part 1: $part1');
  print('part 2: $part2');
}
