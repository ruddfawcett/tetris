import processing.sound.*;

/**
 *
 */
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
  private PApplet applet;

  private SoundFile blip;
  private SoundFile swoosh;

  Tetris(PApplet applet) {
    this.playfield = new Playfield(this);
    this.scoreboard = new Scoreboard(this);
    this.currentPiece = new Piece();
    this.nextPiece = new Piece();

    update();

    this.blip = new SoundFile(applet, "sounds/blip.mp3");
    this.swoosh = new SoundFile(applet, "sounds/swoosh.mp3");
  }

  public void restart() {
    this.gameState = GameState.PLAYING;
    this.playfield = new Playfield(this);
    this.currentPiece = new Piece();
    this.nextPiece = new Piece();
    this.score = 0;
    this.removedLines = 0;
    this.level = 1;

    loop();
  }

  public void end() {
    gameState = GameState.OVER;
    scoreboard.draw();
    playfield.drawOverlay();

    noLoop();
  }

  public void play() {
    gameState = GameState.PLAYING;
    scoreboard.draw();
    playfield.drawOverlay();

    loop();
  }

  public void pause() {
    gameState = GameState.PAUSED;
    scoreboard.draw();
    scoreboard.drawNextPiece(nextPiece);
    playfield.drawOverlay();

    noLoop();
  }

  public int getScore() {
    return score;
  }

  public int getLevel() {
    return level;
  }

  public int getRemovedLines() {
    return removedLines;
  }

  public GameState getGameState() {
   return gameState;
  }

  public Playfield getPlayfield() {
    return playfield;
  }

  public void handleKey(int keyCode) {
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
  public int calculateScore(int lines) {
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

  public void handleMouse(int mouseX, int mouseY) {
     scoreboard.handleMouse(mouseX, mouseY);
  }

  public void update() {
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
      blip.play();
      currentPiece = nextPiece;
      nextPiece = new Piece();

      int numLinesRemoved = playfield.removeRows();
      if (numLinesRemoved > 0) {
       swoosh.play();
      }

      score += calculateScore(numLinesRemoved);
      removedLines += numLinesRemoved;
      level = (int)(score/10000) + 1;

      if (!playfield.canMove(currentPiece, Direction.DOWN)) {
        playfield.add(currentPiece);
        blip.play();
        playfield.draw();
        end();

      }
    }
  }
}