import java.util.Arrays;

class Board {
  private final int BOARD_WIDTH = 10;
  private final int BOARD_HEIGHT;
  private final int BLOCK_WIDTH;
  
  private PImage[] blockImages;

  private int[][] blocks;

  Board(int w, int h) {
    this.BLOCK_WIDTH = w / BOARD_WIDTH;
    int numRows = h / BLOCK_WIDTH;
    this.blocks = new int[numRows][BOARD_WIDTH];

    this.BOARD_HEIGHT = numRows;
    this.blockImages = new PImage[TetrominoType.values().length+1];
    loadImages();
  }
  
  void loadImages() {
   for (int i = 0; i < this.blockImages.length; i++) {
     blockImages[i] = loadImage("blocks/tetris-block-"+i+".png");
   }
  }

  boolean add(Tetromino piece) {
    int x = piece.getX();
    int y = piece.getY();

    try {
      for (int row = 0; row < piece.getHeight(); row++) {
        for (int col = 0; col < piece.getWidth(); col++) {
          if (piece.getBlock(row, col) != 0) {
            blocks[row + y][col + x] = piece.getBlock(row, col);
          }
        }
      }
    } catch (ArrayIndexOutOfBoundsException e) {
      return false;
    }

    return true;
  }

  void draw(Tetromino piece) {
    int x = piece.getX();
    int y = piece.getY();
    for (int row = 0; row < piece.getHeight(); row++)
      for (int col = 0; col < piece.getWidth(); col++) {
        if (piece.getBlock(col, row) != 0) {
          image(blockImages[piece.getType()],(x + row) * BLOCK_WIDTH, (y + col) * BLOCK_WIDTH, BLOCK_WIDTH, BLOCK_WIDTH);
        }
      }
  }

  void draw() {
    for (int row = 0; row < blocks.length; row++) {
      for (int col = 0; col < blocks[0].length; col++) {
        int x = col * BLOCK_WIDTH;
        int y = row * BLOCK_WIDTH;
        image(blockImages[blocks[row][col]], x, y, BLOCK_WIDTH, BLOCK_WIDTH);
      }
    }
  }

  boolean canMovePiece(Tetromino piece, Direction direction) {
    int x = piece.getX();
    int y = piece.getY();

    if (direction == Direction.RIGHT) {
      x++;
    } else if (direction == Direction.LEFT) {
      x--;
    } else if (direction == Direction.DOWN) {
      y++;
    }

    try {
      for (int row = 0; row < piece.getHeight(); row++) {
        for (int col = 0; col < piece.getWidth(); col++) {
          if (piece.getBlock(row, col) != 0) {
            if (blocks[row + y][col + x] != 0) {
              return false;
            }
          }
        }
      }
    } catch (ArrayIndexOutOfBoundsException e) {
      return false;
    }

    return true;
  }

  int removeRows() {
    int removedRows = 0;

    for (int row = 0; row < BOARD_HEIGHT; row++) {
      boolean removeRow = true;
      for (int col = 0; col < BOARD_WIDTH; col++) {
        if (blocks[row][col] == 0) {
          removeRow = false;
        }
      }

      if (removeRow) {
        removeRow(row);
        removedRows++;
      }
    }

    return removedRows;
  }

  boolean canRotatePiece(Tetromino piece) {
    piece.rotate();
    boolean canMove = canMovePiece(piece, Direction.UP);
    piece.rotateBack();

    return canMove;
  }

  void removeRow(int row) {
    for (int i = row; i > 0; i--) {
      blocks[i] = blocks[i - 1];
    }

    blocks[0] = new int[BOARD_WIDTH]; // adds a new row at the top of the board
  }
}