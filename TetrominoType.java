import java.util.Map;
import java.util.HashMap;

public enum TetrominoType {
  I(1),  // cyan
  J(2),  // blue
  L(3),  // orange
  O(4),  // yellow
  S(5),  // lime
  T(6),  // purple
  Z(7);  // red

  private final int value;

  TetrominoType(int value) {
    this.value = value;
  }

  public int getValue() {
    return value;
  }

  public Map<Orientation, int[][]> getConfigurations() {
    Map<Orientation, int[][]> configurations = new HashMap<Orientation, int[][]>();
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

    configurations.put(Orientation.UP, up);
    configurations.put(Orientation.RIGHT, right);
    configurations.put(Orientation.DOWN, down);
    configurations.put(Orientation.LEFT, left);

    return configurations;
  }

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
