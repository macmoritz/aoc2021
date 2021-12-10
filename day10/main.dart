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
  List<String> lines = [];
  String filename = 'input.txt';
  if (arguments.length == 1) {
    filename = arguments[0];
  }

  int part1 = 0;
  int part2 = 0;

  lines = await getLines(filename);
  Map<String, String> braces = {')': '(', ']': '[', '}': '{', '>': '<'};

  List<String> currentOpen = [];
  for (final line in lines) {
    currentOpen = [];
    for (final brace in line.split('')) {
      if (brace == '(' || brace == '[' || brace == '{' || brace == '<') {
        currentOpen.add(brace);
      } else if (brace == ')' || brace == ']' || brace == '}' || brace == '>') {
        if (currentOpen.last == braces[brace]) {
          switch (brace) {
            case ')':
              currentOpen.remove('(');
              break;
            case ']':
              currentOpen.remove('[');
              break;
            case '}':
              currentOpen.remove('{');
              break;
            case '>':
              currentOpen.remove('<');
              break;
          }
        }
      } else {
        print('found $brace');
        switch (brace) {
          case ')':
            part1 += 3;
            break;
          case ']':
            part1 += 57;
            break;
          case '}':
            part1 += 1197;
            break;
          case '>':
            part1 += 25137;
            break;
        }
      }
    }
  }

  print('part 1: $part1');
  print('part 2: $part2');
}
