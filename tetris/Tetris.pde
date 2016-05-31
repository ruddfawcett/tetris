import processing.sound.*;

/**
 * Citations:
 * https://processing.org/reference/noLoop_.html
 * https://processing.org/reference/loop_.html
 * http://tetris.wikia.com/wiki/Hard_Drop
 * http://tetris.wikia.com/wiki/Soft_Drop
 * http://tetris.wikia.com/wiki/Scoring
 * http://stackoverflow.com/a/12421641
 */

/**
 * A Tetris game. Sets up the Tetris Playfield, and
 * the Scoreboard. Has helper functions to play and
 * pause the game.
 *
 * @author Rudd Fawcett
 */
class Tetris {
  /**
   * The scale for the game, a multiplier used to scale
   * the pieces and window size.
   */
  private static final int PLAYFIELD_BLOCK_SCALE = 30;
  /**
   * The number of points awarded for each soft drop movement.
   */
  private static final int SOFT_DROP_BLOCK_SCORE = 10;

  /**
   * A timer which is reset after every second.
   */
  private int timer;
  /**
   * The number of lines removed by the user.
   */
  private int removedLines = 0;
  /**
   * The current score of the user.
   */
  private int score = 0;
  /**
   * The user's high score.
   */
  private int highScore = 0;
  /**
   * The user's current level.
   */
  private int level = 1;

  /**
   * The current game state, either PAUSED, PLAYING, or OVER.
   */
  private GameState gameState = GameState.PLAYING;

  /**
   * The current piece in play (the one that is "falling").
   */
  private Piece currentPiece;
  /**
   * The next piece to be played, drawn in the Scorebaord pane.
   */
  private Piece nextPiece;

  /**
   * The Playfield where the blocks show up. Tetris terminology.
   */
  private Playfield playfield;
  /**
   * The Scoreboard pane.
   */
  private Scoreboard scoreboard;
  /**
   * The Processing applet.
   */
  private PApplet applet;

  /**
   * The blip sound effect.
   */
  private SoundFile blip;
  /**
   * The swoosh sound effect.
   */
  private SoundFile swoosh;

  /**
   * Constructs a new Tetris game.
   * @param PApplet applet The Processing applet, used to play sounds, etc.
   */
  Tetris(PApplet applet) {
    this.playfield = new Playfield(this);
    this.scoreboard = new Scoreboard(this);
    this.currentPiece = new Piece();
    this.nextPiece = new Piece();

    // Draws the Playfield from the get go
    update();

    // Creates the sounds
    this.blip = new SoundFile(applet, "sounds/blip.mp3");
    this.swoosh = new SoundFile(applet, "sounds/swoosh.mp3");
  }

  /**
   * Restarts the Tetris game by resetting all values to default.
   */
  public void restart() {
    this.gameState = GameState.PLAYING;
    this.playfield = new Playfield(this);
    this.currentPiece = new Piece();
    this.nextPiece = new Piece();
    this.score = 0;
    this.removedLines = 0;
    this.level = 1;

    // Stops the draw() function in Launcher from looping
    // https://processing.org/reference/noLoop_.html
    loop();
  }

  /**
   * Ends the Tetris game, by setting the game state.
   */
  public void end() {
    gameState = GameState.OVER;
    scoreboard.draw();
    if (score > highScore) {
      highScore = score;
    }
    
    playfield.drawOverlay("You Lost!");

    // Stops the draw() function in Launcher from looping
    // https://processing.org/reference/noLoop_.html
    noLoop();
  }

  /**
   * Sets the game state to PLAYING.
   */
  public void play() {
    gameState = GameState.PLAYING;
    scoreboard.draw();
    playfield.drawOverlay("");

    // Restarts the draw() function in Launcher.
    // https://processing.org/reference/loop_.html
    loop();
  }

  /**
   * Pauses the game by setting the game state to paused.
   */
  public void pause() {
    gameState = GameState.PAUSED;
    scoreboard.draw();
    scoreboard.drawNextPiece(nextPiece);
    playfield.drawOverlay("Game is Paused");

    // Stops the draw() function in Launcher from looping
    // https://processing.org/reference/noLoop_.html
    noLoop();
  }

  /**
   * The user's current score.
   */
  public int getScore() {
    return score;
  }

  /**
   * The user's high score.
   */
  public int getHighScore() {
    return highScore;
  }
  
  /**
   * The user's current level.
   */
  public int getLevel() {
    return level;
  }

  /**
   * The number of removed lines by the user.
   */
  public int getRemovedLines() {
    return removedLines;
  }

  /**
   * The game's current state.
   */
  public GameState getGameState() {
   return gameState;
  }

  /**
   * The Tetris Playfield.
   */
  public Playfield getPlayfield() {
    return playfield;
  }

  /**
   * Handler for when a key is pressed. Uses if and switch
   * statements to handle the course of action.
   * @param  int keyCode The key code of the key pressed (Processing type).
   */
  public void handleKey(int keyCode) {
    // Performs a hard drop if the space bar is pressed
    // http://tetris.wikia.com/wiki/Hard_Drop
    if (key == ' ') {
      while (playfield.canMove(currentPiece, Direction.DOWN)) {
        currentPiece.move(Direction.DOWN);
        score += SOFT_DROP_BLOCK_SCORE * 2;
      }
    }

    // Toggles the game state if the "P" key is pressed
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
        // If the piece can rotate, rotate it.
        if (playfield.canRotate(currentPiece)) {
          currentPiece.rotate();
        }
        break;
      case DOWN:
        // If the piece can move down, perform a soft drop.
        // http://tetris.wikia.com/wiki/Soft_Drop
        if (playfield.canMove(currentPiece, Direction.DOWN)) {
          score += SOFT_DROP_BLOCK_SCORE; // Increase the score.
          currentPiece.move(Direction.DOWN);
        } else {
          update();
        }
        break;
      case LEFT:
        // If the piece can move left, move it left.
        if (playfield.canMove(currentPiece, Direction.LEFT)) {
          currentPiece.move(Direction.LEFT);
        }
        break;
      case RIGHT:
        // If the piece can move right, move it right.
        if (playfield.canMove(currentPiece, Direction.RIGHT)) {
          currentPiece.move(Direction.RIGHT);
        }
        break;
      default:
        return;
    }
  }

  /**
   * Calculates the score increment, based on the number of lines cleared.
   * Uses the  algorithm x * (n+1), where x is a constant based on the
   * number of lines cleared, and n is the current level. Because the largest
   * a Tetromino can be is 4 blocks, the x has to be less than 4.
   * http://tetris.wikia.com/wiki/Scoring - used for algorithm
   * @param  int lines The number of lines cleared.
   * @return int The calculated score based on the lines.
   */
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

  /**
   * Passes on the mouse click event to the Scoreboard in order
   * to detect if a button was clicked.
   * @param  int mouseX the x coordinate of the mouse click.
   * @param  int mouseY the y coordinate of the mouse click.
   */
  public void handleMouse(int mouseX, int mouseY) {
     scoreboard.handleMouse(mouseX, mouseY);
  }

  /**
   * Updates the Playfield and Scoreboard. Called from the Launcher.
   */
  public void update() {
    playfield.draw();
    scoreboard.draw();
    scoreboard.drawNextPiece(nextPiece);

    // If the piece can move down, then keep drawing it.
    if (playfield.canMove(currentPiece, Direction.DOWN)) {
      playfield.draw(currentPiece);

      // If a second has passed, move the piece down one block
      // Modified from: http://stackoverflow.com/a/12421641
      if (millis() - timer >= 1000) {
        currentPiece.move(Direction.DOWN);
        timer = millis();
      }
    } else {
      // Otherwise add the piece to the block matrix.
      playfield.add(currentPiece);
      blip.play();
      currentPiece = nextPiece;
      nextPiece = new Piece();

      // Count the number of rows removed if the piece can no longer move down.
      int numLinesRemoved = playfield.removeRows();
      // Play swoosh sound if a row was removed
      if (numLinesRemoved > 0) {
       swoosh.play();
      }

      // Increment the scoreb based on the calculcated value
      score += calculateScore(numLinesRemoved);
      if (score > highScore) {
        highScore = score;
      }
      removedLines += numLinesRemoved;
      // Update the level so it is the score / 10000
      level = (int)(score/10000) + 1; // Add 1 so never 0

      // If no new piece can be added the Playfield/block matrix, end the game
      // The user will have hit the top of the Playfield
      if (!playfield.canMove(currentPiece, Direction.DOWN)) {
        playfield.add(currentPiece);
        blip.play();
        playfield.draw();
        end();

      }
    }
  }
}