class Tetris {

  private static final color BACKGROUND_COLOR = #58595B;
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

  void newGame() {
    this.playfield = new Playfield(300, height);
    this.currentPiece = new Piece();
    this.nextPiece = new Piece();
    loop();
  }

  void endGame() {
    noLoop();
  }

  void pauseGame() {
    noLoop();
  }

  void drawPlayfield() {

  }

  void handleKey(int keyCode) {
    if (key == ' ') { // space
      while (playfield.canMove(currentPiece, Direction.DOWN)) {
        currentPiece.move(Direction.DOWN);
        // update score?
      }
    }

    switch (keyCode) {
      case UP:
        if (playfield.canRotate(currentPiece)) {
          currentPiece.rotate();
        }
        break;
      case DOWN:
        if (playfield.canMove(currentPiece, Direction.DOWN)) {
          currentPiece.move(Direction.DOWN);
        } else {
          update();
        }
        break;
      case LEFT:
        if (playfield.canMove(currentPiece, Direction.LEFT)) {
          currentPiece.move(Direction.LEFT);
        }
        break;
      case RIGHT:
        if (playfield.canMove(currentPiece, Direction.RIGHT)) {
          currentPiece.move(Direction.RIGHT);
        }
        break;
      default:
        return;
    }
  }

  int getRemovedLines() {
    return removedLines;
  }

  void update() {
    playfield.draw();
    //panel.update();

    if (playfield.canMove(currentPiece, Direction.DOWN)) {
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

      if (!playfield.canMove(currentPiece, Direction.DOWN)) {
        playfield.add(currentPiece);
        playfield.draw();
        endGame();
      }
    }
  }
}