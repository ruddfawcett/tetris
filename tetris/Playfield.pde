import java.util.Arrays;

class Playfield {
  private static final color PLAYFIELD_BACKGROUND_COLOR = #2A2A2A;//58595B;
    
  private final int PLAYFIELD_WIDTH;
  private final int PLAYFIELD_HEIGHT;

  private static final int PLAYFIELD_BLOCK_WIDTH = 10;
  private static final int PLAYFIELD_BLOCK_HEIGHT = 20;

  private final int BLOCK_WIDTH;
  
  private Tetris tetris;

  private PImage[] blockImages;

  private int[][] matrix;

  Playfield(Tetris tetris, int width, int height) {
    this.tetris = tetris;
    
    this.PLAYFIELD_WIDTH = width;
    this.PLAYFIELD_HEIGHT = height;

    this.BLOCK_WIDTH = width / PLAYFIELD_BLOCK_WIDTH;

    this.matrix = new int[PLAYFIELD_BLOCK_HEIGHT][PLAYFIELD_BLOCK_WIDTH];

    this.blockImages = new PImage[Tetromino.values().length+1];
    loadImages();
  }

  void loadImages() {
   for (int i = 0; i < this.blockImages.length; i++) {
     blockImages[i] = loadImage("blocks/tetris-block-"+i+".png");
   }
  }
  
  int getBlockWidth() {
    return BLOCK_WIDTH;
  }

  PImage[] getBlockImages() {
    return blockImages;
  }

  boolean add(Piece piece) {
    int x = piece.getX();
    int y = piece.getY();

    try {
      for (int row = 0; row < piece.getSize(); row++) {
        for (int col = 0; col < piece.getSize(); col++) {
          if (piece.getBlock(row, col) != 0) {
            matrix[row + y][col + x] = piece.getBlock(row, col);
          }
        }
      }
    } catch (ArrayIndexOutOfBoundsException e) {
      return false;
    }

    return true;
  }

  void draw(Piece piece) {
    int x = piece.getX();
    int y = piece.getY();
    for (int row = 0; row < piece.getSize(); row++)
      for (int col = 0; col < piece.getSize(); col++) {
        if (piece.getBlock(col, row) != 0) {
          int yOffset = y + col;
          if (piece.getHasEmptyFirstRow()) {
            yOffset = y + (col-1);
          }
          
          image(blockImages[piece.getType()],(x + row) * BLOCK_WIDTH, yOffset * BLOCK_WIDTH, BLOCK_WIDTH, BLOCK_WIDTH);
        }
      }
  }

  void draw() {
    for (int row = 0; row < PLAYFIELD_BLOCK_HEIGHT; row++) {
      for (int col = 0; col < PLAYFIELD_BLOCK_WIDTH; col++) {
        int x = col * BLOCK_WIDTH;
        int y = row * BLOCK_WIDTH;
        if (matrix[row][col] == 0) {
          strokeWeight(0.25);
          stroke(color(255));
          fill(PLAYFIELD_BACKGROUND_COLOR);
          rect(x, y, BLOCK_WIDTH, BLOCK_WIDTH);
        }
        else {
          image(blockImages[matrix[row][col]], x, y, BLOCK_WIDTH, BLOCK_WIDTH);
        }
      }
    }
  }

  void drawOverlay() {
    fill(color(0,0,0,200));
    rect(0,0,PLAYFIELD_WIDTH+1,PLAYFIELD_HEIGHT);
    textSize(40);
    fill(color(255));
    textAlign(CENTER, CENTER);
    text(tetris.getGameState().overlayText(), 0, 0, PLAYFIELD_WIDTH, PLAYFIELD_HEIGHT);
  }

  int removeRows() {
    int removedRows = 0;

    for (int row = 0; row < PLAYFIELD_BLOCK_HEIGHT; row++) {
      boolean removeRow = true;
      for (int col = 0; col < PLAYFIELD_BLOCK_WIDTH; col++) {
        if (matrix[row][col] == 0) {
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
  
  void removeRow(int row) {
    for (int i = row; i > 0; i--) {
      matrix[i] = matrix[i - 1];
    }

    matrix[0] = new int[PLAYFIELD_BLOCK_WIDTH]; // adds a new row at the top of the board
  }

  boolean canMove(Piece piece, Direction direction) {
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
      for (int row = 0; row < piece.getSize(); row++) {
        for (int col = 0; col < piece.getSize(); col++) {
          if (piece.getBlock(row, col) != 0) {
            if (matrix[row + y][col + x] != 0) {
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

  boolean canRotate(Piece piece) {
    piece.rotate();
    boolean canMove = canMove(piece, Direction.UP);
    piece.rotateBack();

    return canMove;
  }
}