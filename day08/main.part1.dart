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

Future<int> digitToNum(digit) async {
  int len = digit.length;
  if (len == 2) {
    return 1;
  } else if (len == 4) {
    return 4;
  } else if (len == 3) {
    return 7;
  } else if (len == 7) {
    return 8;
  }
  return -1;
}

void main(List<String> arguments) async {
  List<String> lines = [];
  String filename = 'input.txt';
  if (arguments.length == 1) {
    filename = arguments[0];
  }

  int part1 = 0;
  int part2 = 0;
  int number = -1;

  lines = await getLines(filename);
  for (final line in lines) {
    for (final digit in line.split(' | ')[1].split(' ')) {
      number = await digitToNum(digit);
      if (number == 1 || number == 4 || number == 7 || number == 8) {
        part1 += 1;
      }
    }
  }

  print('part 1: $part1');
  print('part 2: $part2');
}


/*
 aaaa     1111
b    c   6    2
b    c   6    2
 dddd     7777
e    f   5    3
e    f   5    3
 gggg     4444

unique length: 1 (2), 4 (4), 7 (3), 8 (7)

to swap: c <-> f, b <-> d, e <-> g
*/
