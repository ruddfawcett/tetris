class Tetris {
  private static final int PLAYFIELD_BLOCK_SCALE = 30;
  private static final int SOFT_DROP_BLOCK_SCORE = 10;

  private int timer;
  private int removedLines = 0;
  private int score = 0;
  private int level = 1;

  private GameState gameState = GameState.PLAYING;

  private Piece currentPiece;
  private Piece nextPiece;

  private Playfield playfield;
  private Scoreboard scoreboard;

  Tetris() {
    int playfieldWidth = Playfield.PLAYFIELD_BLOCK_WIDTH * PLAYFIELD_BLOCK_SCALE;
    int playfieldHeight = Playfield.PLAYFIELD_BLOCK_HEIGHT * PLAYFIELD_BLOCK_SCALE;

    this.playfield = new Playfield(this, playfieldWidth, playfieldHeight);
    this.scoreboard = new Scoreboard(this, 250, playfieldHeight);
    this.currentPiece = new Piece();
    this.nextPiece = new Piece();
    
    this.scoreboard.drawNextPiece(nextPiece);
  }

  void restart() {
    this.gameState = GameState.PLAYING;
    this.playfield = new Playfield(this, 300, height);
    this.currentPiece = new Piece();
    this.nextPiece = new Piece();
    this.score = 0;
    this.removedLines = 0;
    this.level = 1;
    loop();
  }

  void end() {
    gameState = GameState.OVER;
    scoreboard.draw();
    playfield.drawOverlay();
    noLoop();
  }
  
  void play() {
    gameState = GameState.PLAYING;
    scoreboard.draw();
    playfield.drawOverlay();
    loop();
  }

  void pause() {
    gameState = GameState.PAUSED;
    scoreboard.draw();
    scoreboard.drawNextPiece(nextPiece);
    playfield.drawOverlay();
    noLoop();
  }
  
  int getScore() {
    return score;
  }
  
  int getLevel() {
    return level;
  }
  
  int getRemovedLines() {
    return removedLines;
  }

  GameState getGameState() {
   return gameState; 
  }
  
  Playfield getPlayfield() {
    return playfield;
  }

  void handleKey(int keyCode) {
    if (key == ' ') {
      while (playfield.canMove(currentPiece, Direction.DOWN)) {
        currentPiece.move(Direction.DOWN);
        score += SOFT_DROP_BLOCK_SCORE * 2;
      }
    }

    if (key == 'p') {
      if (gameState == GameState.PAUSED) {
        play();
      }
      else {
        pause();
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
          score += SOFT_DROP_BLOCK_SCORE;
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
  
  // http://tetris.wikia.com/wiki/Scoring
  int calculateScore(int lines) {
   if (lines == 1) {
     return 40 * (level + 1);
   } else if (lines == 2) {
     return 100 * (level + 1);
   } else if (lines == 3) {
     return 300 * (level + 1); 
   }
   else if (lines == 4) {
     return 1200 * (level + 1);
   }
   
   return 0;
  }
  
  void handleMouse(int mouseX, int mouseY) {
     scoreboard.handleMouse(mouseX, mouseY);
  }

  void update() {
    playfield.draw();
    scoreboard.draw();
    scoreboard.drawNextPiece(nextPiece);

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

      int numLinesRemoved = playfield.removeRows();
      score += calculateScore(numLinesRemoved);
      removedLines += numLinesRemoved;
      level = (int)(score/10000) + 1;

      if (!playfield.canMove(currentPiece, Direction.DOWN)) {
        playfield.add(currentPiece);
        playfield.draw();
        end();
        
      }
    }
  }
}