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
  int bitcount = 12;
  if (arguments.length == 1) {
    filename = arguments[0];
  }

  List<int> oneCount = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  int count;
  String gamma = '', epsilon = '';
  List<String> co2 = [], oxygen = [];
  int part1 = 0;
  int part2 = 0;

  lines = await getLines(filename);
  count = lines.length;
  for (final line in lines) {
    bitcount = line.length;
    for (int i = 0; i < bitcount; i++) {
      if (line.substring(i, i + 1) == '1') {
        oneCount[i] += 1;
      }
    }
  }
  for (int i = 0; i < bitcount; i++) {
    if (oneCount[i] > count / 2) {
      gamma += '1';
      epsilon += '0';
    } else {
      gamma += '0';
      epsilon += '1';
    }
  }

  oxygen = [...lines]; // fancy spread operator for copying
  co2 = [...lines];
  int oneCountOxygen = 0;
  int zeroCountCo2 = 0;

  for (int i = 0; oxygen.length > 1; i++) {
    oneCountOxygen = 0;
    for (final data in oxygen) {
      if (data.substring(i, i + 1) == '1') {
        oneCountOxygen += 1;
      }
    }
    if (oneCountOxygen >= oxygen.length - oneCountOxygen) {
      oxygen.removeWhere((element) => element.substring(i, i + 1) == '0');
    } else {
      oxygen.removeWhere((element) => element.substring(i, i + 1) == '1');
    }
  }

  for (int i = 0; co2.length > 1; i++) {
    zeroCountCo2 = 0;
    for (final data in co2) {
      if (data.substring(i, i + 1) == '0') {
        zeroCountCo2 += 1;
      }
    }
    if (zeroCountCo2 <= co2.length - zeroCountCo2) {
      co2.removeWhere((element) => element.substring(i, i + 1) == '1');
    } else {
      co2.removeWhere((element) => element.substring(i, i + 1) == '0');
    }
  }

  part1 = int.parse(gamma, radix: 2) * int.parse(epsilon, radix: 2);
  part2 = int.parse(co2[0], radix: 2) * int.parse(oxygen[0], radix: 2);
  print('part 1: $part1');
  print('part 2: $part2');
}
