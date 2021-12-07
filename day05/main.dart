import 'dart:async';
import 'dart:io';
import 'dart:convert';


Future<void> processFile(filename, map1, map2) async {
  int x1, x2, y1, y2;
  String secondPart;

  return new File(filename)
    .openRead()
    .map(utf8.decode)
    .transform(new LineSplitter())
    .forEach((line) {
      x1 = int.parse(line.substring(0, line.indexOf(',')));
      y1 = int.parse(line.substring(line.indexOf(',') + 1, line.indexOf('-') - 1));
      secondPart = line.substring(line.indexOf('>') + 2, line.length);
      x2 = int.parse(secondPart.substring(0, secondPart.indexOf(',')));
      y2 = int.parse(secondPart.substring(secondPart.indexOf(',') + 1, secondPart.length));

      if(x1 == x2) {
        if(y1 < y2) {
          for (; y1 <= y2; y1++) {
            map1[y1][x1] = map1[y1][x1] + 1;
            map2[y1][x1] = map2[y1][x1] + 1;
          }
        } else {
          for (; y1 >= y2; y1--) {
            map1[y1][x1] = map1[y1][x1] + 1;
            map2[y1][x1] = map2[y1][x1] + 1;
          }
        }
      } else if(y1 == y2) {
        if (x1 < x2) {
          for (; x1 <= x2; x1++) {
            map1[y1][x1] = map1[y1][x1] + 1;
            map2[y1][x1] = map2[y1][x1] + 1;
          }
        } else {
          for (; x1 >= x2; x1--) {
            map1[y1][x1] = map1[y1][x1] + 1;
            map2[y1][x1] = map2[y1][x1] + 1;
          }
        }
      } else {
        map2[y1][x1] = map2[y1][x1] + 1;
        while(x1 != x2 && y1 != y2){
          if(x1 > x2) {
            x1 -= 1;
          } else if(x1 < x2) {
            x1 += 1;
          }
          if(y1 > y2) {
            y1 -= 1;
          } else if(y1 < y2) {
            y1 += 1;
          }
          map2[y1][x1] = map2[y1][x1] + 1;
        }
      }
    });
}

void main(List<String> arguments) async {
  String filename = 'input.txt';
  int mapSize = 1000;
  if (arguments.length == 1) {
    filename = arguments[0];
    mapSize = 10;
  }

  var map1 = List.generate(mapSize, (i) => List.generate(mapSize, (j) => 0));
  var map2 = List.generate(mapSize, (i) => List.generate(mapSize, (j) => 0));
  int part1 = 0;
  int part2 = 0;

  await processFile(filename, map1, map2);

  for(final col in map1) {
    for(final field in col) {
      if(filename == 'example.txt') {
        if(field == 0) {
          stdout.write('.');
        } else {
          stdout.write(field);
        }
      }

      if(field > 1) {
        part1++;
      }
    }
    if(filename == 'example.txt') {
      stdout.write('\n');
    }
  }

  stdout.write('\n');
  stdout.write('\n');

  for(final col in map2) {
    for(final field in col) {
      if(filename == 'example.txt') {
        if(field == 0) {
          stdout.write('.');
        } else {
          stdout.write(field);
        }
      }

      if(field > 1) {
        part2++;
      }
    }
    if(filename == 'example.txt') {
      stdout.write('\n');
    }
  }

  print('\npart 1: $part1');
  print('\npart 2: $part2');
}
