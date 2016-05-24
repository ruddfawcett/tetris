class Tetris {
  public int timer;
  public int removedLines = 0;
  public int score = 0;

  public static final color BACKGROUND_COLOR = #505050;

  public Tetromino currentPiece;
  public Tetromino nextPiece;

  public Board board;

  Tetris() {
    this.board = new Board(300, height);
    this.currentPiece = new Tetromino();
    this.nextPiece = new Tetromino();
  }

  void newGame() {
    this.board = new Board(300, height);
    this.currentPiece = new Tetromino();
    this.nextPiece = new Tetromino();
    loop();
  }
  
  void endGame() {
    noLoop(); 
  }

  void pauseGame() {
    noLoop();
  }

  void drawBoard() {

  }

  void handleKey(int keyCode) {
    if (key == ' ') { // space
      while (board.canMovePiece(currentPiece, Direction.DOWN)) {
        currentPiece.move(Direction.DOWN);
        // update score?
      }
    }

    switch (keyCode) {
      case UP:
        if (board.canRotatePiece(currentPiece)) {
          currentPiece.rotate();
        }
        break;
      case DOWN:
        if (board.canMovePiece(currentPiece, Direction.DOWN)) {
          currentPiece.move(Direction.DOWN);
        } else {
          update();
        }
        break;
      case LEFT:
        if (board.canMovePiece(currentPiece, Direction.LEFT)) {
          currentPiece.move(Direction.LEFT);
        }
        break;
      case RIGHT:
        if (board.canMovePiece(currentPiece, Direction.RIGHT)) {
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
    board.draw();
    
    if (board.canMovePiece(currentPiece, Direction.DOWN)) {
      board.draw(currentPiece);

      if (millis() - timer >= 1000) {
        currentPiece.move(Direction.DOWN);
        timer = millis();
      }
    } else {
      board.add(currentPiece);
      currentPiece = nextPiece;
      nextPiece = new Tetromino();
      board.removeRows();

      int num = board.removeRows();
      removedLines += num;

      if (!board.canMovePiece(tetris.currentPiece, Direction.DOWN)) {
        board.add(tetris.currentPiece);
        board.draw();
        tetris.endGame();
      }
    }
  }
}