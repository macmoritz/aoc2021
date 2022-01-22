import 'dart:async';
import 'dart:io';
import 'dart:convert';

Future<List<String>> getLines(filename) async {
  List<String> lines = [];
  await new File(filename).openRead().map(utf8.decode).transform(new LineSplitter()).forEach((line) {
    lines.add(line);
  });
  return lines;
}

Future<List<int>> simulate(List<int> fishs, int days) async {
  int temp;
  for (int day = 0; day < days; day++) {
    temp = fishs[0];
    fishs[0] = fishs[1];
    fishs[1] = fishs[2];
    fishs[2] = fishs[3];
    fishs[3] = fishs[4];
    fishs[4] = fishs[5];
    fishs[5] = fishs[6];
    fishs[6] = fishs[7] + temp;
    fishs[7] = fishs[8];
    fishs[8] = temp;
  }
  return fishs;
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
  List<int> input = lines[0].split(',').map(int.parse).toList();
  List<int> fishs1 = [0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<int> fishs2 = [0, 0, 0, 0, 0, 0, 0, 0, 0];

  for (final fish in input) {
    fishs1[fish] += 1;
    fishs2[fish] += 1;
  }

  fishs1 = await simulate(fishs1, 80);
  fishs2 = await simulate(fishs2, 256);

  for (final fishs in fishs1) {
    part1 += fishs;
  }
  for (final fishs in fishs2) {
    part2 += fishs;
  }
  print('part 1: $part1');
  print('part 2: $part2');
}
