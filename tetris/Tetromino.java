import java.util.Map;
import java.util.HashMap;

/**
 * Citations:
 * http://stackoverflow.com/a/14149844
 */

/**
 * A Tetromino enum.
 *
 * @author Rudd Fawcett
 */
public enum Tetromino {
  I(1), // cyan
  J(2), // blue
  L(3), // orange
  O(4), // yellow
  S(5), // lime
  T(6), // purple
  Z(7); // red

  /**
   * The int representation of a Tetromino.
   */
  private final int value;

  /**
   * Constructs an Enum Tetromino and assigns
   * the Enum a value.
   */
  Tetromino(int value) {
    this.value = value;
  }

  /**
   * An int representation of a Tetromino.
   */
  public int getValue() {
    return value;
  }

  /**
   * A HashMap of the possible configurations for a
   * Tetromino for each possible PieceOrientation.
   * @return Map<PieceOrientation, int[][]> The configurations.
   */
  public Map<PieceOrientation, int[][]> getConfigurations() {
    Map<PieceOrientation, int[][]> configurations = new HashMap<PieceOrientation, int[][]>();
    int[][] up = new int[][]{};
    int[][] right = new int[][]{};
    int[][] down = new int[][]{};
    int[][] left = new int[][]{};

    switch(this) {
      case I:
       up = new int[][] {
         {0,0,0,0},
         {1,1,1,1},
         {0,0,0,0},
         {0,0,0,0}
       };
       right = new int[][] {
         {0,0,1,0},
         {0,0,1,0},
         {0,0,1,0},
         {0,0,1,0}
       };
       down = new int[][] {
         {0,0,0,0},
         {0,0,0,0},
         {1,1,1,1},
         {0,0,0,0}
       };
       left = new int[][] {
         {0,1,0,0},
         {0,1,0,0},
         {0,1,0,0},
         {0,1,0,0}
       };
        break;
      case J:
        up = new int[][] {
          {0,0,0},
          {2,2,2},
          {0,0,2}
        };
        right = new int[][] {
          {0,2,0},
          {0,2,0},
          {2,2,0}
        };
        down = new int[][] {
          {2,0,0},
          {2,2,2},
          {0,0,0}
        };
        left = new int[][] {
          {0,2,2},
          {0,2,0},
          {0,2,0}
        };
        break;
      case L:
        up = new int[][] {
          {0,0,3},
          {3,3,3},
          {0,0,0}
        };
        right = new int[][] {
          {0,3,0},
          {0,3,0},
          {0,3,3}
        };
        down = new int[][] {
          {0,0,0},
          {3,3,3},
          {3,0,0}
        };
        left = new int[][] {
          {3,3,0},
          {0,3,0},
          {0,3,0}
        };
        break;
      case O:
        up = new int[][] {
          {4,4},
          {4,4}
        };
        // Clone taken from http://stackoverflow.com/a/14149844
        right = up.clone();
        down = up.clone();
        left = up.clone();
        break;
      case S:
        up = new int[][] {
          {0,5,5},
          {5,5,0},
          {0,0,0}
        };
        right = new int[][] {
          {0,5,0},
          {0,5,5},
          {0,0,5}
        };
        down = new int[][] {
          {0,0,0},
          {0,5,5},
          {5,5,0}
        };
        left = new int[][] {
          {5,0,0},
          {5,5,0},
          {0,5,0}
        };
        break;
      case T:
        up = new int[][] {
          {0,6,0},
          {6,6,6},
          {0,0,0}
        };
        right = new int[][] {
          {0,6,0},
          {0,6,6},
          {0,6,0}
        };
        down = new int[][] {
          {0,0,0},
          {6,6,6},
          {0,6,0}
        };
        left = new int[][] {
          {0,6,0},
          {6,6,0},
          {0,6,0}
        };
        break;
      case Z:
        up = new int[][] {
          {7,7,0},
          {0,7,7},
          {0,0,0}
        };
        right = new int[][] {
          {0,0,7},
          {0,7,7},
          {0,7,0}
        };
        down = new int[][] {
          {0,0,0},
          {7,7,0},
          {0,7,7}
        };
        left = new int[][] {
          {0,7,0},
          {7,7,0},
          {7,0,0}
        };
        break;
        default:
          break;
    }

    configurations.put(PieceOrientation.UP, up);
    configurations.put(PieceOrientation.RIGHT, right);
    configurations.put(PieceOrientation.DOWN, down);
    configurations.put(PieceOrientation.LEFT, left);

    return configurations;
  }

  /**
   * The starting coordinates for the type of Tetromino,
   * as some pieces are four columns wide, while others are three.
   * @return int[] the start coordinates (x, y) for a Tetromino.
   */
  public int[] getStartCoordinates() {
    int[] startCoordinates = new int[]{};

    switch(this) {
      case O:
       startCoordinates = new int[] {4,0};
        break;
      default:
        startCoordinates = new int[] {3,0};
        break;
    }

    return startCoordinates;
  }
}
