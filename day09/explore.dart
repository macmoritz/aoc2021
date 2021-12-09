class Explore {
  List<List<int>> toExplore = [];
  List<List<bool>> basinMap = [];
  int basinSize = 0;

  Explore(x, y, this.basinMap) {
    toExplore.add([x, y]);
  }

  void exploreNext() {
    int x, y;
    List<List<int>> toRemove = [];
    List<List<int>> neighbours = [];

    for (final field in toExplore) {
      x = field[0];
      y = field[1];
      toRemove.add([x, y]);
      neighbours = getNeighbours(x, y);
      basinSize += neighbours.length;
      neighbours.forEach((neighbour) {
        toExplore.add(neighbour);
      });
    }

    toRemove.forEach((field) {
      toExplore.remove(field);
    });
  }

  List<List<int>> getNeighbours(int x, int y) {
    List<List<int>> neighbours = [];
    if (x > 0) {
      if (!this.basinMap[x - 1][y]) {
        neighbours.add([x - 1, y]);
      }
    }
    if (x + 1 < this.basinMap.length) {
      if (!this.basinMap[x + 1][y]) {
        neighbours.add([x + 1, y]);
      }
    }
    if (y > 0) {
      if (!this.basinMap[x][y - 1]) {
        neighbours.add([x, y - 1]);
      }
    }
    if (y + 1 < this.basinMap.length) {
      if (!this.basinMap[x][y + 1]) {
        neighbours.add([x, y + 1]);
      }
    }
    return neighbours;
  }
}
