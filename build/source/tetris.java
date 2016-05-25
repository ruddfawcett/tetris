import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Map; 
import java.util.HashMap; 
import java.util.Arrays; 
import java.util.Arrays; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class tetris extends PApplet {

Tetris tetris;

public void settings() {
  size(300, 600);
}

public void setup() {
  surface.setTitle("Tetris");
  smooth();

  tetris = new Tetris();
  tetris.newGame();
}

public void draw() {
  background(tetris.BACKGROUND_COLOR);
  tetris.update();
}

public void keyReleased() {
  tetris.handleKey(keyCode);
}
class Panel {
  Panel() {

    
  }

 public void update() {


 }
}




class Piece {
  private int x;
  private int y;
  private int type;

  private PieceOrientation pieceOrientation;

  // overridden in each subclass thingy
  private Map < PieceOrientation, int[][] > configurations;
  private Map < PieceOrientation, int[][] > startCoordinates;

  public Piece() {
    //this.pieceOrientation = PieceOrientation.values()[(int)random(PieceOrientation.values().length)];
    this.pieceOrientation = PieceOrientation.UP;

    Tetromino[] tetrominoes = Tetromino.values();
    Tetromino randomTetromino = Tetromino.values()[(int) random(Tetromino.values().length)];

    this.x = randomTetromino.getStartCoordinates()[0];
    this.y = randomTetromino.getStartCoordinates()[1];

    this.configurations = randomTetromino.getConfigurations();
    this.type = randomTetromino.getValue();
  }

  public int getX() {
    return x;
  }

  public int getY() {
    return y;
  }

  public int getType() {
    return type;
  }

  public int getWidth() {
    return configurations.get(this.pieceOrientation)[0].length;
  }

  public int getHeight() {
    return configurations.get(this.pieceOrientation).length;
  }

  public PieceOrientation getPieceOrientation() {
    return pieceOrientation;
  }

  public String toString() {
    return Arrays.deepToString(configurations.get(this.pieceOrientation));
  }

  public int getBlock(int x, int y) {
    try {
      return configurations.get(this.pieceOrientation)[x][y];
    } catch (ArrayIndexOutOfBoundsException e) {
      return 0;
    }
  }

  public void rotate() {
    this.pieceOrientation = this.pieceOrientation.next();
  }

  public void rotateBack() {
    this.pieceOrientation = this.pieceOrientation.previous();
  }

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


class Playfield {
  private final int PLAYFIELD_WIDTH;
  private final int PLAYFIELD_HEIGHT;

  private static final int PLAYFIELD_BLOCK_WIDTH = 10;
  private static final int PLAYFIELD_BLOCK_HEIGHT = 22;

  private final int BLOCK_WIDTH;

  private PImage[] blockImages;

  private int[][] matrix;

  Playfield(int width, int height) {
    this.PLAYFIELD_WIDTH = width;
    this.PLAYFIELD_HEIGHT = height;

    this.BLOCK_WIDTH = width / PLAYFIELD_BLOCK_WIDTH;

    this.matrix = new int[PLAYFIELD_BLOCK_HEIGHT][PLAYFIELD_BLOCK_WIDTH];

    this.blockImages = new PImage[Tetromino.values().length+1];
    loadImages();
  }

  public void loadImages() {
   for (int i = 0; i < this.blockImages.length; i++) {
     blockImages[i] = loadImage("blocks/tetris-block-"+i+".png");
   }
  }

  public boolean add(Piece piece) {
    int x = piece.getX();
    int y = piece.getY();

    try {
      for (int row = 0; row < piece.getHeight(); row++) {
        for (int col = 0; col < piece.getWidth(); col++) {
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

  public void draw(Piece piece) {
    int x = piece.getX();
    int y = piece.getY();
    for (int row = 0; row < piece.getHeight(); row++)
      for (int col = 0; col < piece.getWidth(); col++) {
        if (piece.getBlock(col, row) != 0) {
          image(blockImages[piece.getType()],(x + row) * BLOCK_WIDTH, (y + col) * BLOCK_WIDTH, BLOCK_WIDTH, BLOCK_WIDTH);
        }
      }
  }

  public void draw() {
    for (int row = 0; row < matrix.length; row++) {
      for (int col = 0; col < matrix[0].length; col++) {
        int x = col * BLOCK_WIDTH;
        int y = row * BLOCK_WIDTH;
        image(blockImages[matrix[row][col]], x, y, BLOCK_WIDTH, BLOCK_WIDTH);
      }
    }
  }

  public int removeRows() {
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


  public void removeRow(int row) {
    for (int i = row; i > 0; i--) {
      matrix[i] = matrix[i - 1];
    }

    matrix[0] = new int[PLAYFIELD_BLOCK_WIDTH]; // adds a new row at the top of the board
  }

  public boolean canMovePiece(Piece piece, Direction direction) {
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

  public boolean canRotatePiece(Piece piece) {
    piece.rotate();
    boolean canMove = canMovePiece(piece, Direction.UP);
    piece.rotateBack();

    return canMove;
  }
}
class Tetris {

  private static final int BACKGROUND_COLOR = 0xff58595B;
  private static final int PLAYFIELD_BLOCK_SCALE = 30;

  private int timer;
  private int removedLines = 0;
  private int score = 0;
  private int level = 0;

  private GameState state;

  private Piece currentPiece;
  private Piece nextPiece;

  private Playfield playfield;
  private Panel panel;

  Tetris() {
    int playfieldWidth = Playfield.PLAYFIELD_BLOCK_WIDTH * PLAYFIELD_BLOCK_SCALE;
    int playfieldHeight = Playfield.PLAYFIELD_BLOCK_HEIGHT * PLAYFIELD_BLOCK_SCALE;

    this.playfield = new Playfield(playfieldWidth, playfieldHeight);
    this.currentPiece = new Piece();
    this.nextPiece = new Piece();
  }

  public void newGame() {
    this.playfield = new Playfield(300, height);
    this.currentPiece = new Piece();
    this.nextPiece = new Piece();
    loop();
  }

  public void endGame() {
    noLoop();
  }

  public void pauseGame() {
    noLoop();
  }

  public void drawPlayfield() {

  }

  public void handleKey(int keyCode) {
    if (key == ' ') { // space
      while (playfield.canMovePiece(currentPiece, Direction.DOWN)) {
        currentPiece.move(Direction.DOWN);
        // update score?
      }
    }

    switch (keyCode) {
      case UP:
        if (playfield.canRotatePiece(currentPiece)) {
          currentPiece.rotate();
        }
        break;
      case DOWN:
        if (playfield.canMovePiece(currentPiece, Direction.DOWN)) {
          currentPiece.move(Direction.DOWN);
        } else {
          update();
        }
        break;
      case LEFT:
        if (playfield.canMovePiece(currentPiece, Direction.LEFT)) {
          currentPiece.move(Direction.LEFT);
        }
        break;
      case RIGHT:
        if (playfield.canMovePiece(currentPiece, Direction.RIGHT)) {
          currentPiece.move(Direction.RIGHT);
        }
        break;
      default:
        return;
    }
  }

  public int getRemovedLines() {
    return removedLines;
  }

  public void update() {
    playfield.draw();
    panel.update();

    if (playfield.canMovePiece(currentPiece, Direction.DOWN)) {
      playfield.draw(currentPiece);

      if (millis() - timer >= 1000) {
        currentPiece.move(Direction.DOWN);
        timer = millis();
      }
    } else {
      playfield.add(currentPiece);
      currentPiece = nextPiece;
      nextPiece = new Piece();
      playfield.removeRows();

      int num = playfield.removeRows();
      removedLines += num;

      if (!playfield.canMovePiece(currentPiece, Direction.DOWN)) {
        playfield.add(currentPiece);
        playfield.draw();
        endGame();
      }
    }
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "tetris" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
