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

Future<bool> isSimultaneously(List<List<int>> octopuses) async {
  int value = octopuses[0][0];
  for (final row in octopuses) {
    for (final octopus in row) {
      if (octopus != value) {
        return false;
      }
    }
  }
  return true;
}

void main(List<String> arguments) async {
  String filename = 'input.txt';
  if (arguments.length == 1) {
    filename = arguments[0];
  }

  int part1 = 0;
  int part2 = 0;

  List<String> lines = await getLines(filename);
  List<List<int>> octopuses = [];
  List<List<int>> setToZero = [];
  List<int> expanded = [];
  for (final line in lines) {
    octopuses.add(line.split('').map(int.parse).toList());
  }
  print('Before any steps:');
  print(octopuses[0]);
  print(octopuses[1]);
  print(octopuses[2]);
  print(octopuses[3]);
  print(octopuses[4]);
  print('\n');

  //part 1
  // for (int step = 0; step < 100; step++) {

  //part2
  while (!await isSimultaneously(octopuses)) {
    part2 += 1;
    setToZero = [];
    for (int x = 0; x < octopuses.length; x++) {
      for (int y = 0; y < octopuses[x].length; y++) {
        octopuses[x][y]++;
      }
    }

    expanded = octopuses.expand((octopus) => octopus).toList();

    while (expanded.any((octopus) => octopus > 9)) {
      octopuses.asMap().forEach((x, row) {
        row.asMap().forEach((y, octopus) {
          if (octopus > 9) {
            part1 += 1;
            for (int x1 = -1; x1 <= 1; x1++) {
              if (x + x1 >= 0 && x + x1 + 1 <= octopuses.length) {
                for (int y1 = -1; y1 <= 1; y1++) {
                  if (y + y1 >= 0 && y + y1 + 1 <= octopuses[0].length) {
                    if (x1 == 0 && y1 == 0) {
                      octopuses[x][y] = -1;
                      setToZero.add([x, y]);
                    }
                    if (octopuses[x + x1][y + y1] >= 0) {
                      octopuses[x + x1][y + y1]++;
                    }
                  }
                }
              }
            }
          }
        });
      });
      setToZero.forEach((element) {
        octopuses[element[0]][element[1]] = 0;
      });
      expanded = octopuses.expand((octopus) => octopus).toList();
    }

    print('After step ${part2}');
    print(octopuses[0]);
    print(octopuses[1]);
    print(octopuses[2]);
    print(octopuses[3]);
    print(octopuses[4]);
    print('\n');
  }

  print('part 1: $part1');
  print('part 2: $part2');
}
