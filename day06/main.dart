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
  int days = 80;
  String filename = 'input.txt';
  if (arguments.length == 1) {
    filename = arguments[0];
    days = 18;
  }

  int part1 = 0;
  int part2 = 0;

  lines = await getLines(filename);
  List<int> input = lines[0].split(',').map(int.parse).toList();
  List<int> fishs1 = [...input];
  List<int> fishs2 = [0, 0, 0, 0, 0, 0, 0, 0, 0];

  for (int day = 0; day < days; day++) {
    for (int i = 0; i < fishs1.length; i++) {
      if (fishs1[i] == 0) {
        fishs1[i] = 6;
        fishs1.add(9);
      } else {
        fishs1[i]--;
      }
    }
  }

  for (final fish in input) {
    fishs2[fish] += 1;
  }

  int temp;
  for (int day = 0; day < 256; day++) {
    temp = fishs2[0];
    fishs2[0] = fishs2[1];
    fishs2[1] = fishs2[2];
    fishs2[2] = fishs2[3];
    fishs2[3] = fishs2[4];
    fishs2[4] = fishs2[5];
    fishs2[5] = fishs2[6];
    fishs2[6] = fishs2[7] + temp;
    fishs2[7] = fishs2[8];
    fishs2[8] = temp;
  }

  part1 = fishs1.length;
  for (final fishs in fishs2) {
    part2 += fishs;
  }
  print('part 1: $part1');
  print('part 2: $part2');
}
