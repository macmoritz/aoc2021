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

void main(List<String> arguments) async {
  String filename = 'input.txt';
  if (arguments.length == 1) {
    filename = arguments[0];
  }

  int part1 = 0;
  int part2 = 0;

  List<String> lines = await getLines(filename);
  List<List<int>> coords = [];
  List<String> folds = [];

  for (final line in lines) {
    if (line.isNotEmpty) {
      if (line.length >= 13) {
        folds.add(line.split(' ')[2]);
      } else {
        coords.add(line.split(',').map(int.parse).toList());
      }
    }
  }

  int maxWidth = 0, maxHeight = 0;
  for (final coord in coords) {
    if (coord[0] > maxWidth) {
      maxWidth = coord[0];
    }
    if (coord[1] > maxHeight) {
      maxHeight = coord[1];
    }
  }
  List<List<String>> manual = List.generate(
      maxHeight + 1, (i) => List.generate(maxWidth + 1, (j) => '.'));

  int count = 0;
  for (final coord in coords) {
    manual[coord[1]][coord[0]] = count.toString();
    count++;
  }

  manual.forEach((line) {
    print(line);
  });

  String fold = folds[0];
  if (fold[0] == 'x') {
    int foldindex = int.parse(fold.split('=')[1]);
    for (final line in manual) {
      for (int index = foldindex; index < line.length; index++) {
        if (line[index] != '.') {
          print('$index, ${index - foldindex}');
          line[index - foldindex] = line[index];
        }
      }
      line.length = foldindex;
    }
  }

  print('\n\n');
  manual.forEach((line) {
    line.forEach((element) {
      if (element == '#') {
        part1++;
      }
    });
    print('$line');
  });

  print('part 1: $part1');
  print('part 2: $part2');
}
