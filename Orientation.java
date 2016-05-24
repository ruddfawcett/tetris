public enum Orientation {
  UP(0),
  RIGHT(1),
  DOWN(2),
  LEFT(3);

  private final int value;

  Orientation(int value) {
    this.value = value;
  }

  Orientation next() { // or rename nextRotation
    Orientation[] orientations = this.values();
    int current = value;
    int nextIndex = (current + 1) % orientations.length;
    return orientations[nextIndex];
  }

  Orientation previous() { // or rename nextRotation
    Orientation[] orientations = this.values();
    int current = value;
    int previousIndex = (current + orientations.length - 1) % orientations.length;
    return orientations[previousIndex];
  }

  int getValue() {
    return value;
  }
}
