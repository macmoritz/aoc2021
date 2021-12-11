class Explore {
  List<List<int>> toExplore = [];
  List<List<int>> explored = [];
  List<List<bool>> basinMap = [];
  int basinSize = 0;

  Explore(x, y, this.basinMap) {
    toExplore.add([x, y]);
  }

  bool containsAsString(List list, element) {
    for (final item in list) {
      if (item.toString() == element.toString()) {
        return true;
      }
    }
    return false;
  }

  void explore() {
    List<List<int>> neighbours = [];
    List<int> current = [];
    while (toExplore.isNotEmpty) {
      current = toExplore[0];
      if (!containsAsString(explored, current)) {
        neighbours = getNeighbours(current[0], current[1]);
        explored += neighbours;
        toExplore += neighbours;
        basinSize += neighbours.length;
      }
      toExplore.remove(current);
    }
  }

  List<List<int>> getNeighbours(int x, int y) {
    List<List<int>> neighbours = [];
    if (x > 0) {
      if (this.basinMap[x - 1][y] && !explored.contains([x - 1, y])) {
        neighbours.add([x - 1, y]);
      }
    }
    if (x + 1 < this.basinMap.length) {
      if (this.basinMap[x + 1][y] && !explored.contains([x + 1, y])) {
        neighbours.add([x + 1, y]);
      }
    }
    if (y > 0) {
      if (this.basinMap[x][y - 1] && !explored.contains([x, y - 1])) {
        neighbours.add([x, y - 1]);
      }
    }
    if (y + 1 < this.basinMap.length) {
      if (this.basinMap[x][y + 1] && !explored.contains([x, y + 1])) {
        neighbours.add([x, y + 1]);
      }
    }

    print('\t$neighbours');
    return neighbours;
  }
}
