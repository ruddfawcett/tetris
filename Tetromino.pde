import java.util.Map;
import java.util.HashMap;
import java.util.Arrays;

class Tetromino {
  private int x;
  private int y;
  private int type;

  private Orientation orientation;

  // overridden in each subclass thingy
  private Map < Orientation, int[][] > configurations;
  private Map < Orientation, int[][] > startCoordinates;

  public Tetromino() {
    //this.orientation = Orientation.values()[(int)random(Orientation.values().length)];
    this.orientation = Orientation.UP;

    TetrominoType[] types = TetrominoType.values();
    TetrominoType randomType = TetrominoType.values()[(int) random(TetrominoType.values().length)];

    this.x = randomType.getStartCoordinates()[0];
    this.y = randomType.getStartCoordinates()[1];

    this.configurations = randomType.getConfigurations();
    this.type = randomType.getValue();
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

  int getWidth() {
    return configurations.get(this.orientation)[0].length;
  }

  int getHeight() {
    return configurations.get(this.orientation).length;
  }

  Orientation getOrientation() {
    return orientation;
  }

  String toString() {
    return Arrays.deepToString(configurations.get(this.orientation));
  }

  int getBlock(int x, int y) {
    try {
      return configurations.get(this.orientation)[x][y];
    } catch (ArrayIndexOutOfBoundsException e) {
      println("error here rip: " + this.orientation + " x: " + x + " y: " + y);
      return 1;
    }
  }

  void rotate() {
    this.orientation = this.orientation.next();
  }

  void rotateBack() {
    this.orientation = this.orientation.previous();
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

color getColorFromType(int type) {
    color fill = color(0);
    switch (type) {
      case 1: // case I
        fill = #27E0FD;
       break;
     case 2: // case J
       fill = #1BA6DE;
       break;
     case 3: // case L
        fill = #F59331;
        break;
      case 4: // case O
        fill = #F6EA4B;
       break;
     case 5: // case S
       fill = #5AD426;
       break;
     case 6: // case T
        fill = #C878FC;
       break;
     case 7: // case Z
        fill = #FC293E;
        break;
      default:
        fill = #505050;
       break;
   };

   return fill;
 }