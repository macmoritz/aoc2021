import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'dart:math';

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
  String filename = 'input.txt';
  if (arguments.length == 1) {
    filename = arguments[0];
  }

  int part1 = 0;
  int part2 = 0;

  List<String> lines = await getLines(filename);
  List<int> coords = lines[0]
      .substring(15)
      .replaceAll(', y=', '..')
      .split('..')
      .map(int.parse)
      .toList();
  Target target = new Target(coords[0], coords[1], coords[3], coords[2]);

  // Shot shot = new Shot(7, 2, target);
  // Shot shot = new Shot(0, -1000, target);
  // if (shot.hit) {
  //   yPos.add(shot.highesty);
  //   print('HITTT!!!');
  // } else {
  //   print('no hit :(');
  // }

  int range = 1000;
  for (int x = 0; x < range; x++) {
    for (int y = -range; y < range; y++) {
      Shot shot = new Shot(x, y, target);
      if (shot.hit) {
        if (shot.highesty > part1) {
          part1 = shot.highesty;
        }
        part2++;
      }
    }
  }

  print('part 1: $part1');
  print('part 2: $part2');
}

class Target {
  int minx = 0, x = 0, miny = 0, y = 0;

  Target(int minx, int x, int miny, int y) {
    this.minx = minx;
    this.x = x;
    this.miny = miny;
    this.y = y;
  }

  bool hit(Shot shot) {
    return shot.x >= this.minx &&
        shot.x <= this.x &&
        shot.y <= this.miny &&
        shot.y >= this.y;
  }

  bool canHit(Shot shot) {
    return !(shot.x > this.x || shot.y < this.y);
  }
}

class Shot {
  int x = 0, y = 0, highesty = -9999;
  int velx = 0, vely = 0;
  bool hit = false;
  var target;

  Shot(int velx, int vely, Target target) {
    this.velx = velx;
    this.vely = vely;
    this.target = target;

    this.shoot();
  }

  void shoot() {
    while (!target.hit(this) && target.canHit(this)) {
      if (this.y > highesty) {
        highesty = this.y;
      }

      this.x += this.velx;
      this.y += this.vely;

      if (this.velx > 0) {
        this.velx -= 1;
      } else if (this.velx < 0) {
        this.velx += 1;
      }
      this.vely -= 1;
    }

    this.hit = target.hit(this);
  }
}
