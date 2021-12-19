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

Future<List<int>> getVersionSum(String package, int cursor) async {
  int versionSum = int.parse(package.substring(cursor, cursor + 3), radix: 2);
  int id = int.parse(package.substring(cursor + 3, cursor + 6), radix: 2);
  cursor += 6;
  if (id == 4) {
    while (true) {
      cursor += 5;
      if (package[cursor - 5] == '0') break;
    }
  } else if (package[cursor] == '0') {
    cursor += 1;
    int end = cursor +
        15 +
        int.parse(package.substring(cursor, cursor + 15), radix: 2);
    cursor += 15;
    while (cursor < end) {
      var newPackage = await getVersionSum(package, cursor);
      versionSum += newPackage[0];
      cursor = newPackage[1];
    }
  } else if (package[cursor] == '1') {
    int packagecount =
        int.parse(package.substring(cursor + 1, cursor + 12), radix: 2);
    cursor += 12;
    for (int i = 0; i < packagecount; i++) {
      var newPackage = await getVersionSum(package, cursor);
      versionSum += newPackage[0];
      cursor = newPackage[1];
    }
  }

  return [versionSum, cursor];
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
  var data = await getVersionSum(line, 0);
  part1 = data[0];
  print('part 1: $part1');
  print('part 2: $part2');
}
