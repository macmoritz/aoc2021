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
    List<List<int>> toRemove = [];
    List<List<int>> toAdd = [];

    while (toExplore.length > 0) {
      for (final field in toExplore) {
        toRemove = [];
        toAdd = [];
        if (!containsAsString(explored, field)) {
          print('exploring $field');
          toAdd = getNeighbours(field[0], field[1]);
          basinSize += 1;
          toRemove.add(field);
          explored.add(field);
        }
      }
      toAdd.forEach((element) {
        if (!containsAsString(explored, element)) {
          toExplore.add(element);
        }
      });
      toRemove.forEach((element) {
        print('removing $element');
        toExplore.remove(element);
        if (!containsAsString(explored, element)) {
          explored.add(element);
        }
      });
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
