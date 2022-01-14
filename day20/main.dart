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

Future<int> pixelsToDec(String pixels) async {
  String bin = '';
  for (final pixel in pixels.split('')) {
    pixel == '.' ? bin += '0' : bin += '1';
  }
  return int.parse(bin, radix: 2);
}

Future<int> processPixel(int x, int y, List<Pixel> lightPixels) async {
  String neighbours = '';
  for (int tempx = x - 1; tempx <= x + 1; tempx++) {
    for (int tempy = y - 1; tempy <= y + 1; tempy++) {
      if (lightPixels.contains(Pixel(tempx, tempy))) {
        neighbours += '#';
      } else {
        neighbours += '.';
      }
    }
  }
  return await pixelsToDec(neighbours);
}

Future<List<Pixel>> algorithm(List<Pixel> lightPixels, int maxX, int maxY,
    String enhancement, int iterations) async {
  for (int iteration = 0; iteration < iterations; iteration++) {
    List<Pixel> newPixels = [];
    for (int x = 0; x < maxX; x++) {
      for (int y = 0; y < maxY; y++) {
        int ei = await processPixel(x, y, lightPixels);
        if (enhancement[ei] == '#') {
          if (!newPixels.contains(Pixel(x, y))) {
            newPixels.add(Pixel(x, y));
          }
        } else if (newPixels.contains(Pixel(x, y))) {
          newPixels.remove(Pixel(x, y));
        }
      }
    }
    lightPixels = newPixels;
  }

  return lightPixels;
}

void main(List<String> arguments) async {
  String filename = 'input.txt';
  if (arguments.length == 1) {
    filename = arguments[0];
  }

  int part1 = 0;
  int part2 = 0;

  List<String> lines = await getLines(filename);
  String enhancement = lines[0];
  List<Pixel> lightPixels = [];
  int maxX = 0, maxY = 0;

  int iterations = 2, offset = iterations * 3;

  int x, y;
  for (int index = 2; index < lines.length; index++) {
    x = index - 2;
    var row = lines[index].split('');
    for (y = 0; y < row.length; y++) {
      if (row[y] == '#') {
        int offx = x + offset, offy = y + offset;
        lightPixels.add(Pixel(offx, offy));

        if (offx > maxX) {
          maxX = offx;
        }
        if (offy > maxY) {
          maxY = offy;
        }
      }
    }
  }
  maxX += offset;
  maxY += offset;

  List<Pixel> lightPixels1 =
      await algorithm(lightPixels, maxX, maxY, enhancement, iterations);

  // List<Pixel> lightPixels2 =
  //     await algorithm(lightPixels, maxX, maxY, enhancement, part2Iterations);

  for (int x = 0; x < maxX; x++) {
    String line = '';
    for (int y = 0; y < maxY; y++) {
      lightPixels1.contains(Pixel(x, y)) ? line += '#' : line += '.';
    }
    print('$line');
  }

  part1 = lightPixels1.length;

  // part2 = lightPixels2.length;

  print('part 1: $part1');
  print('part 2: $part2');
}

class Pixel {
  int x, y;
  Pixel(this.x, this.y);

  @override
  String toString() {
    return 'Pixel(${this.x} ${this.y})';
  }

  @override
  bool operator ==(Object other) =>
      other is Pixel && other.x == this.x && other.y == this.y;
}
