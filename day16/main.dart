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

Future<List> getVersionSum(
    String package, int cursor, int firstId, List<int> values) async {
  int versionSum = int.parse(package.substring(cursor, cursor + 3), radix: 2);
  int id = int.parse(package.substring(cursor + 3, cursor + 6), radix: 2);
  if (firstId == -1) {
    firstId = id;
  }
  cursor += 6;
  if (id == 4) {
    while (true) {
      cursor += 5;
      if (package[cursor - 5] == '0') break;
      values.add(int.parse(package.substring(cursor - 5, cursor), radix: 2));
    }
  } else if (package[cursor] == '0') {
    cursor += 1;
    int end = cursor +
        15 +
        int.parse(package.substring(cursor, cursor + 15), radix: 2);
    cursor += 15;
    while (cursor < end) {
      var newPackage = await getVersionSum(package, cursor, firstId, values);
      versionSum += newPackage[0] as int;
      values.add(
          int.parse(package.substring(cursor + 6, newPackage[1]), radix: 2));
      cursor = newPackage[1];
    }
  } else if (package[cursor] == '1') {
    int packagecount =
        int.parse(package.substring(cursor + 1, cursor + 12), radix: 2);
    cursor += 12;
    for (int i = 0; i < packagecount; i++) {
      var newPackage = await getVersionSum(package, cursor, firstId, values);
      versionSum += newPackage[0] as int;
      values.add(
          int.parse(package.substring(cursor + 6, newPackage[1]), radix: 2));
      cursor = newPackage[1];
    }
  }

  return [
    versionSum,
    cursor,
    firstId,
    [await solveExpression(id, values)]
  ];
}

Future<int> solveExpression(int firstId, List<int> values) async {
  switch (firstId) {
    case 0:
      return values.reduce((value, element) => value + element);
    case 1:
      return values.reduce((value, element) => value * element);
    case 2:
      return values.reduce(min);
    case 3:
      return values.reduce(max);
    case 5:
      return values[0] > values[1] ? 1 : 0;
    case 6:
      return values[0] < values[1] ? 1 : 0;
    case 7:
      return values[0] == values[1] ? 1 : 0;
  }
  return 0;
}

void main(List<String> arguments) async {
  String filename = 'input.txt';
  if (arguments.length == 1) {
    filename = arguments[0];
  }

  int part1 = 0;
  int part2 = 0;

  List<String> lines = await getLines(filename);
  // String line = int.parse(lines[0], radix: 16).toRadixString(2);
  String line = '';
  for (final hex in lines[0].split('')) {
    String bin4 = int.parse(hex, radix: 16).toRadixString(2);
    while (bin4.length < 4) {
      bin4 = '0' + bin4;
    }
    line += bin4;
    bin4 = '';
  }
  // print(line);
  var data = await getVersionSum(line, 0, -1, []);
  part1 = data[0];
  part2 = await solveExpression(data[2], data[3]);
  print('part 1: $part1');
  print('first id: ${data[2]}, values ${data[3]}');
  print('part 2: $part2');
}
