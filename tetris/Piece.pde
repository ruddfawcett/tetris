import java.util.Map;
import java.util.HashMap;
import java.util.Arrays;

/**
 * A piece in the game. This class handles piece
 * rotation, movement, and also has other helper methods.
 *
 * @author Rudd Fawcett
 */
class Piece {
  /**
   * The x block postion of the piece
   */
  private int x;
  /**
   * The y block postion of the piece
   */
  private int y;
  /**
   * The int type of the piece, based on the Tetromino
   * Enum's value.
   */
  private int type;

  /**
   * The current orientation of the piece.
   * Set to UP by default.
   */
  private PieceOrientation orientation = PieceOrientation.UP;;

  /**
   * The possible configurations of the blocks for the piece,
   * based on the piece's orientation.
   */
  private Map < PieceOrientation, int[][] > configurations;
  /**
   * The start coordinates for the piece.
   */
  private Map < PieceOrientation, int[][] > startCoordinates;

  /**
   * Constructs a new piece, with default orientation UP
   */
  public Piece() {
    // Get a random Tetromino, and use it to set the type of the piece.
    Tetromino[] tetrominoes = Tetromino.values();
    Tetromino randomTetromino = Tetromino.values()[(int) random(Tetromino.values().length)];

    // Set the start coordinates
    this.x = randomTetromino.getStartCoordinates()[0];
    this.y = randomTetromino.getStartCoordinates()[1];

    // Set the configurations based on the random Tetromino
    this.configurations = randomTetromino.getConfigurations();
    this.type = randomTetromino.getValue();
  }

  /**
   * @return int The x position of the piece in the Playfield grid.
   */
  public int getX() {
    return x;
  }

  /**
   * @return int The y position of the piece in the Playfield grid.
   */
  public int getY() {
    return y;
  }

  /**
   * @return int The width/height of a piece (all are square representations).
   */
  public int getSize() {
    return configurations.get(orientation).length;
  }

  /**
   * @return int The Tetromino value of the piece.
   */
  public int getType() {
   return type;
  }

  /**
   * @return PieceOrientation The current orientation of the piece.
   */
  public PieceOrientation getOrientation() {
    return orientation;
  }

  /**
   * Returns the block at a position in the piece's configurations.
   * @param  int x The x (column) of the block in the configuration.
   * @param  int y The y (row) of the block in the configuration.
   * @return int The int representation of a block type at that point in the grid.
   */
  public int getBlock(int x, int y) {
    try {
      return configurations.get(orientation)[x][y];
    } catch (ArrayIndexOutOfBoundsException e) {
      return 0;
    }
  }

  /**
   * Rotates the piece clockwise, updating the current orientation.
   */
  public void rotate() {
    orientation = orientation.next();
  }

  /**
   * Rotates the piece counterclockwise, updating the current orientation.
   */
  public void rotateBack() {
    orientation = orientation.previous();
  }

  /**
   * Moves the piece in a Direction direction, on the Playfield grid.
   * Updates the piece's x and y positions accordingly.
   */
  public void move(Direction direction) {
    switch (direction) {
      case RIGHT:
        x++;
        break;
      case DOWN:
        y++;
        break;
      case LEFT:
        x--;
        break;
      default:
        return;
    }
  }
}
