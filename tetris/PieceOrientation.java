/**
 * Citations:
 * https://stackoverflow.com/questions/6826826/how-could-i-have-the-index-of-an-array-roll-over-when-incrementing
 */

/**
 * An abstract representatio of the possible orientations
 * for a piece to be rotated.
 *
 * @author Rudd Fawcett
 */
public enum PieceOrientation {
  /**
   * The upright (default) orientation.
   */
  UP(0),
  /**
   * A single rotation clockwise, right.
   */
  RIGHT(1),
  /**
   * Two rotations clockwise, down.
   */
  DOWN(2),
  /**
   * Three rotations clocwise, left.
   */
  LEFT(3);

  /**
   * The numerical value of the enum.
   */
  private final int value;

  /**
   * Constructs an Enum PieceOrientation with a given value
   * which is then stored, and used to calculate previous()
   * and next() values.
   */
  PieceOrientation(int value) {
    this.value = value;
  }

  /**
   * Uses the index of the current orientation to calculate
   * the previous orientation cyclically -- UP's previous
   * rotation is LEFT, even though UP is the first orientation,
   * and LEFT is the last).
   * https://stackoverflow.com/questions/6826826/how-could-i-have-the-index-of-an-array-roll-over-when-incrementing
   * @return PieceOrientation the previous orientation.
   */
  public PieceOrientation previous() {
    PieceOrientation[] PieceOrientations = this.values();
    int current = value;
    int previousIndex = (current + PieceOrientations.length - 1) % PieceOrientations.length;
    return PieceOrientations[previousIndex];
  }
  /**
   * Uses the index of the current orientation to calculate
   * the next orientation cyclically -- LEFTS's next
   * rotation is UP, even though UP is the first orientation,
   * and LEFT is the last).
   * https://stackoverflow.com/questions/6826826/how-could-i-have-the-index-of-an-array-roll-over-when-incrementing
   * @return PieceOrientation the next orientation.
   */
  public PieceOrientation next() {
    PieceOrientation[] PieceOrientations = this.values();
    int current = value;
    int nextIndex = (current + 1) % PieceOrientations.length;
    return PieceOrientations[nextIndex];
  }
}
