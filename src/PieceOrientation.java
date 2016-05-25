public enum PieceOrientation {
  UP(0),
  RIGHT(1),
  DOWN(2),
  LEFT(3);

  private final int value;

  PieceOrientation(int value) {
    this.value = value;
  }

  PieceOrientation next() { // or rename nextRotation
    PieceOrientation[] PieceOrientations = this.values();
    int current = value;
    int nextIndex = (current + 1) % PieceOrientations.length;
    return PieceOrientations[nextIndex];
  }

  PieceOrientation previous() { // or rename nextRotation
    PieceOrientation[] PieceOrientations = this.values();
    int current = value;
    int previousIndex = (current + PieceOrientations.length - 1) % PieceOrientations.length;
    return PieceOrientations[previousIndex];
  }

  int getValue() {
    return value;
  }
}