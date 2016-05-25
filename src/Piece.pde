import java.util.Map;
import java.util.HashMap;
import java.util.Arrays;

class Piece {
  private int x;
  private int y;
  private int type;

  private PieceOrientation pieceOrientation;

  // overridden in each subclass thingy
  private Map < PieceOrientation, int[][] > configurations;
  private Map < PieceOrientation, int[][] > startCoordinates;

  public Piece() {
    this.pieceOrientation = PieceOrientation.UP;

    Tetromino[] tetrominoes = Tetromino.values();
    Tetromino randomTetromino = Tetromino.values()[(int) random(Tetromino.values().length)];

    this.x = randomTetromino.getStartCoordinates()[0];
    this.y = randomTetromino.getStartCoordinates()[1];

    this.configurations = randomTetromino.getConfigurations();
    this.type = randomTetromino.getValue();
  }

  int getX() {
    return x;
  }

  int getY() {
    return y;
  }

  color getType() {
    return type;
  }

  int getSize() {
    return configurations.get(this.pieceOrientation).length;
  }

  PieceOrientation getPieceOrientation() {
    return pieceOrientation;
  }

  String toString() {
    return Arrays.deepToString(configurations.get(this.pieceOrientation));
  }

  int getBlock(int x, int y) {
    try {
      return configurations.get(this.pieceOrientation)[x][y];
    } catch (ArrayIndexOutOfBoundsException e) {
      return 0;
    }
  }

  void rotate() {
    this.pieceOrientation = this.pieceOrientation.next();
  }

  void rotateBack() {
    this.pieceOrientation = this.pieceOrientation.previous();
  }

  void move(Direction direction) {
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