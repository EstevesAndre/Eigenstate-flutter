class Coordinate {
  int i;
  int j;

  Coordinate.origin() {
    this.i = 0;
    this.j = 0;
  }

  Coordinate(this.i, this.j);

  void setCoordinates(int i, int j) {
    this.i = i;
    this.j = j;
  }

  int getI() {
    return i;
  }

  int getJ() {
    return j;
  }

  void clean() {
    i = j = 0;
  }
}
