/**
 * Citations:
 * http://tetris.wikia.com/wiki/Playfield
 * http://design.tutsplus.com/articles/create-a-block-game-interface-in-illustrator--vector-5269
 * https://docs.oracle.com/javase/tutorial/essential/exceptions/catch.html
 *
 */

/**
 * A Tetris playfield (or board). Holds a matrix of block
 * values based on the Tetromino type.
 *
 * @author Rudd Fawcett
 */
class Playfield {
  /**
   * The standard Playfield block width.
   * http://tetris.wikia.com/wiki/Playfield
   */
  private static final int PLAYFIELD_BLOCK_WIDTH = 10;
  /**
   * The standard Playfield block width.
   * http://tetris.wikia.com/wiki/Playfield
   */
  private static final int PLAYFIELD_BLOCK_HEIGHT = 20;

  /**
   * The width for each block.
   */
  private static final int BLOCK_WIDTH = 35;

  /**
   * The width of the Playfield.
   */
  static final int PLAYFIELD_WIDTH = PLAYFIELD_BLOCK_WIDTH * BLOCK_WIDTH;
  /**
   * The height of the Playfield.
   */
  static final int PLAYFIELD_HEIGHT = PLAYFIELD_BLOCK_HEIGHT * BLOCK_WIDTH;

  /**
   * The current Tetris game.
   */
  private Tetris tetris;

  /**
   * The block images.
   */
  private PImage[] blockImages;

  /**
   * The block matrix. An array of arrays, all holding ints.
   * Integers from 0-7 represent different types of blocks.
   */
  private int[][] matrix;

  /**
   * Creates a new Tetris Playfield.
   * @param Tetris tetris The current Tetris game.
   */
  Playfield(Tetris tetris) {
    this.tetris = tetris;
    this.matrix = new int[PLAYFIELD_BLOCK_HEIGHT][PLAYFIELD_BLOCK_WIDTH];

    this.blockImages = new PImage[Tetromino.values().length + 1];
    loadImages();
  }

  /**
   * Loads all of the images for the block types into an array.
   * The images were modified slightly form resources found at:
   * http://design.tutsplus.com/articles/create-a-block-game-interface-in-illustrator--vector-5269
   */
  public void loadImages() {
   for (int i = 0; i < this.blockImages.length; i++) {
     blockImages[i] = loadImage("blocks/tetris-block-"+i+".png");
   }
  }

  /**
   * The block images.
   */
  public PImage[] getBlockImages() {
    return blockImages;
  }

  /**
   * Adds a new piece to the block matrix.
   * @param Piece piece The piece to add.
   */
  public boolean add(Piece piece) {
    int x = piece.getX();
    int y = piece.getY();

    // Catch for out of bounds erros, and ignores them.
    // https://docs.oracle.com/javase/tutorial/essential/exceptions/catch.html
    try {
      for (int row = 0; row < piece.getSize(); row++) {
        for (int col = 0; col < piece.getSize(); col++) {
          // If the block is not empty, change the value at that point in the matrix.
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

  /**
   * Draws a piece over the actual grid matrix. Gives the illusion the piece is moving,
   * when in actuality it is drawn over the board.
   * @param Piece piece The piece to draw.
   */
  public void draw(Piece piece) {
    int x = piece.getX();
    int y = piece.getY();
    // Goes through each piece in the block.
    for (int row = 0; row < piece.getSize(); row++)
      for (int col = 0; col < piece.getSize(); col++) {
        if (piece.getBlock(col, row) != 0) {
          // Draw the blocks of the piece.
          image(blockImages[piece.getType()],(x + row) * BLOCK_WIDTH, (y + col) * BLOCK_WIDTH, BLOCK_WIDTH, BLOCK_WIDTH);
        }
      }
  }

  /**
   * Draws the entire Playfield, with all of the blocks in the matrix.
   */
  public void draw() {
    // Goes through the entire Playfield.
    for (int row = 0; row < PLAYFIELD_BLOCK_HEIGHT; row++) {
      for (int col = 0; col < PLAYFIELD_BLOCK_WIDTH; col++) {
        int x = col * BLOCK_WIDTH;
        int y = row * BLOCK_WIDTH;
        // Draws the image associated with the point in the block matrix.
        image(blockImages[matrix[row][col]], x, y, BLOCK_WIDTH, BLOCK_WIDTH);
      }
    }
  }

  /**
   * Draws an overlay over the Playfield, and shows a message.
   * @param  String text The string to display.
   */
  public void drawOverlay(String text) {
    fill(color(0, 0, 0, 200)); // Slightly opaque black
    rect(0,0,PLAYFIELD_WIDTH+1, PLAYFIELD_HEIGHT);
    textSize(40);
    fill(color(255)); // white color
    textAlign(CENTER, CENTER);
    text(text, 0, 0, PLAYFIELD_WIDTH, PLAYFIELD_HEIGHT);
  }

  /**
   * Removes any empty rows from the matrix.
   */
  public int removeRows() {
    int removedRows = 0;

    for (int row = 0; row < PLAYFIELD_BLOCK_HEIGHT; row++) {
      boolean removeRow = true;
      for (int col = 0; col < PLAYFIELD_BLOCK_WIDTH; col++) {
        if (matrix[row][col] == 0) {
          // If there is an emptry row, quit early.
          removeRow = false;
        }
      }

      // If the row is empty, remove it.
      if (removeRow) {
        removeRow(row);
        // Increment the number of rows removed.
        removedRows++;
      }
    }

    return removedRows;
  }

  /**
   * Remove a row in the matrix.
   * @param  int row The index of the row to remove.
   */
  public void removeRow(int row) {
    // Loops through the matrix bottom to top.
    for (int i = row; i > 0; i--) {
      matrix[i] = matrix[i - 1];
    }

    matrix[0] = new int[PLAYFIELD_BLOCK_WIDTH]; // Adds a new row at the top of the board
  }

  /**
   * If the piece can move to a new position based on the block matrix.
   * @param  Piece     piece The piece that the user wants to move.
   * @param  Direction direction The direction the user wants to move the piece.
   * @return boolean Whether or not the piece can move.
   */
  public boolean canMove(Piece piece, Direction direction) {
    int x = piece.getX();
    int y = piece.getY();

    // Set the potential x/y value based on the direction.
    if (direction == Direction.RIGHT) {
      x++;
    } else if (direction == Direction.LEFT) {
      x--;
    } else if (direction == Direction.DOWN) {
      y++;
    }

    // Catch for out of bounds erros, and ignores them.
    // Needed to catch unkown bug.
    // https://docs.oracle.com/javase/tutorial/essential/exceptions/catch.html
    try {
      for (int row = 0; row < piece.getSize(); row++) {
        for (int col = 0; col < piece.getSize(); col++) {
          if (piece.getBlock(row, col) != 0) {
            // If the piece will overlap a non empty block, it can't move there.
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

  /**
   * Rotates the piece, and then sees if the rotation will fit in
   * the matrix using the canMove() method.
   * @param  Piece piece The piece the user wants to rotate.
   * @return boolean Whether or not a piece can rotate.
   */
  public boolean canRotate(Piece piece) {
    // Rotate the piece forward once.
    piece.rotate();
    // Store if the piece can move to a new position.
    boolean canMove = canMove(piece, Direction.UP);
    // Rotate the piece back.
    piece.rotateBack();

    return canMove;
  }
}
