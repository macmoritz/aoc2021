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

List<int> getRange(String range) {
  int min = int.parse(range.split('..')[0]);
  int max = int.parse(range.split('..')[1]);
  List<int> result = [];
  for (; min <= max; min++) {
    if (min >= -50 && min <= 50) {
      result.add(min);
    }
  }
  return result;
}

Future<List<Reactor>> switchReactors(
    String mode, String area, List<Reactor> poweredReactors) async {
  List<List<int>> values =
      area.split(',').map((e) => getRange(e.split('=')[1])).toList();

  if (values[0].isEmpty && values[1].isEmpty && values[2].isEmpty) {
    return poweredReactors;
  }

  for (int x = values[0][0]; x <= values[0].last; x++) {
    for (int y = values[1][0]; y <= values[1].last; y++) {
      for (int z = values[2][0]; z <= values[2].last; z++) {
        if (mode == 'on' && !poweredReactors.contains(Reactor(x, y, z))) {
          poweredReactors.add(Reactor(x, y, z));
        } else if (mode == 'off') {
          poweredReactors.remove(Reactor(x, y, z));
        }
      }
    }
  }

  return poweredReactors;
}

void main(List<String> arguments) async {
  String filename = 'input.txt';
  if (arguments.length == 1) {
    filename = arguments[0];
  }

  int part1 = 0;
  int part2 = 0;

  List<Reactor> poweredReactors = [];
  List<String> lines = await getLines(filename);

  for (final task in lines) {
    poweredReactors = await switchReactors(
        task.substring(0, 3).trim(), task.split(' ')[1], poweredReactors);
  }

  part1 = poweredReactors.where((reactor) => reactor.status == 'on').length;

  print('part 1: $part1');
  print('part 2: $part2');
}

class Reactor {
  int x, y, z;
  bool status = 'on';
  Reactor(this.x, this.y, this.z);

  @override
  String toString() {
    return 'Reactor(${this.x} ${this.y} ${this.z})';
  }

  @override
  bool operator ==(Object other) =>
      other is Reactor &&
      other.x == this.x &&
      other.y == this.y &&
      other.z == this.z;
}
