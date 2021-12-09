import 'dart:async';
import 'dart:io';
import 'dart:convert';

int missingCount(List list, String list2) {
  int missing = 0;
  for (final element in list2.split('')) {
    if (!list.contains(element)) {
      missing++;
    }
  }
  return missing;
}

Future<bool> contains(digit, connections) async {
  for (final c in connections[4].split('')) {
    if (!digit.contains(c)) {
      return false;
    }
  }
  return true;
}

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

Future<int> digitToNum(String digit, List connections) async {
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

  if (len == 6) {
    if (missingCount(digit.split(''), connections[4]) == 0) {
      return 9;
    } else if (missingCount(digit.split(''), connections[7]) == 0) {
      return 0;
    } else {
      return 6;
    }
  }

  if (len == 5) {
    if (missingCount(digit.split(''), connections[7]) == 0) {
      return 3;
    } else if (missingCount(digit.split(''), connections[6]) == 1) {
      return 5;
    } else {
      return 2;
    }
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
  List<String> connections = ['', '', '', '', '', '', '', '', '', '', ''];
  String display = '';
  List<String> temp = [];

  lines = await getLines(filename);
  for (final line in lines) {
    for (final digit in line.split(' | ')[1].split(' ')) {
      number = await digitToNum(digit, connections);
      if (number == 1 || number == 4 || number == 7 || number == 8) {
        part1 += 1;
      }
    }
  }

  for (final line in lines) {
    for (final digit in line.split(' | ')[0].split(' ')) {
      number = await digitToNum(digit, connections);
      if (number == 1 || number == 4 || number == 7 || number == 8) {
        temp = digit.split('');
        temp.sort();
        connections[number] = temp.join('');
      }
    }
    for (final digit in line.split(' | ')[0].split(' ')) {
      number = await digitToNum(digit, connections);
      if (number == 0 || number == 6 || number == 9) {
        temp = digit.split('');
        temp.sort();
        connections[number] = temp.join('');
      }
    }
    for (final digit in line.split(' | ')[0].split(' ')) {
      number = await digitToNum(digit, connections);
      if (number == 2 || number == 3 || number == 5) {
        temp = digit.split('');
        temp.sort();
        connections[number] = temp.join('');
      }
    }

    for (final digit in line.split(' | ')[1].split(' ')) {
      temp = digit.split('');
      temp.sort();
      for (int number = 0; number <= 10; number++) {
        if (connections[number] == temp.join('')) {
          display += '$number';
          break;
        }
      }
    }
    part2 += int.parse(display);
    display = '';
  }

  print('part 1: $part1');
  print('part 2: $part2');
}


/*
 aaaa     1111
b    c   2    3
b    c   2    3
 dddd     4444
e    f   5    6
e    f   5    6
 gggg     7777

unique length: 1 (2), 4 (4), 7 (3), 8 (7)
length of 6: 0, 6, 9
length of 5: 2, 3, 5
*/
