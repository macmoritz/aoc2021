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

Future<int> getIndexOfPixel(List<Pixel> pixels, int x, int y) async {
  String neighbours = '';
  for (int tempx = x - 1; tempx <= x + 1; tempx++) {
    for (int tempy = y - 1; tempy <= y + 1; tempy++) {
      if (pixels.contains(Pixel(tempx, tempy))) {
        neighbours += '#';
      } else {
        neighbours += '.';
      }
    }
  }
  return await pixelsToDec(neighbours);
}

Future<List<Pixel>> algorithm(
    List<Pixel> pixels, maxX, maxY, enhancement, iterations) async {
  for (var i = 0; i < iterations; i++) {
    List<Pixel> newPixels = [];
    for (int x = 0; x < maxX; x++) {
      for (int y = 0; y < maxY; y++) {
        int enhancementIndex = await getIndexOfPixel(pixels, x, y);
        if (enhancement[enhancementIndex] == '#') {
          newPixels.add(Pixel(x, y));
        }
      }
    }
    pixels.remove(0);
    pixels.removeLast();
    pixels = newPixels;
  }
  pixels.remove(0);
  pixels.removeLast();
  return pixels.toSet().toList();
}

void main(List<String> arguments) async {
  String filename = 'input.txt';
  if (arguments.length == 1) {
    filename = arguments[0];
  }

  int part1 = 0, part1Iterations = 2;
  int part2 = 0, part2Iterations = 50;
  int offset = 45;

  List<String> lines = await getLines(filename);
  String enhancement = lines[0];
  lines.removeAt(0);
  lines.removeAt(0);

  List<Pixel> lightPixels = [];
  for (int x = 0; x < lines.length; x++) {
    for (int y = 0; y < lines[0].length; y++) {
      if (lines[x][y] == '#') {
        lightPixels.add(Pixel(x + offset, y + offset));
      }
    }
  }
  int maxX = lines.length + offset * 2;
  int maxY = lines[0].length + offset * 2;

  List<Pixel> lightPixels1 =
      await algorithm(lightPixels, maxX, maxY, enhancement, part1Iterations);

  List<Pixel> lightPixels2 =
      await algorithm(lightPixels, maxX, maxY, enhancement, part2Iterations);

  lightPixels1.removeWhere((element) => element.x == 0);
  lightPixels2.removeWhere((element) => element.x == 0);

  for (int x = 0; x < maxX; x++) {
    String line = '';
    for (int y = 0; y < maxY; y++) {
      if (lightPixels2.contains(Pixel(x, y))) {
        line += '#';
      } else {
        line += '.';
      }
    }
    print('$x \t $line');
  }

  part1 = lightPixels1.length;
  part2 = lightPixels2.length;

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


// part2 wrong: 17650, 14964, 16541
