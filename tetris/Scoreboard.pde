/**
 * Citations:
 * https://processing.org/reference/noStroke_.html
 * https://processing.org/reference/textLeading_.html
 *
 */

/**
 * The Scoreboard pane is the right pane next to the Playfield.
 * The pane holds information such as the next piece to be played,
 * start/stop/pause buttons, and also the user's current score,
 * level and number of removedLines.
 *
 * @author Rudd Fawcett
 */
class Scoreboard {
  /**
   * The width of the pane.
   */
  private static final int SCOREBOARD_WIDTH = 250;
  /**
   * The height of the pane.
   */
  private final int SCOREBOARD_HEIGHT;
  /**
   * The height of the buttons on the pane.
   */
  private final int SCOREBOARD_BUTTON_HEIGHT = 40;
  /**
   * The background color of the pane.
   */
  private static final color SCOREBOARD_BACKGROUND_COLOR = #2A2A2A;

  /**
   * The current Tetris game.
   */
  private Tetris tetris;
  /**
   * The Tetris logo.
   */
  private PImage tetrisLogo;

  /**
   * The x offset for the entire pane -- adds 1 to account for the stroke
   * of the playfield rects.
   */
  private final int SCOREBOARD_X_BUFFER = Playfield.PLAYFIELD_WIDTH + 1;

  /**
   * Constructs a new scoreboard.
   * @param Tetris the current tetris game, to get all of the information from.
   */
  Scoreboard(Tetris tetris) {
    this.tetris = tetris;
    this.SCOREBOARD_HEIGHT = Playfield.PLAYFIELD_HEIGHT;
    this.tetrisLogo = loadImage("graphics/tetris-logo.png");
  }

  /**
   * Draws the Scoreboard. Updates the user's score, the next piece,
   * and also draws all of the buttons in the pane.
   */
  public void draw() {
    // Creates the background rectangle for the entire pane
    noStroke(); // Removes the stroke from this rect (it's on for the Playfield) https://processing.org/reference/noStroke_.html
    fill(SCOREBOARD_BACKGROUND_COLOR);
    rect(SCOREBOARD_X_BUFFER, 0, SCOREBOARD_WIDTH, SCOREBOARD_HEIGHT);

    // Draws the Tetris logo at the top of the pane
    float imageWidth = 154.5;
    float imageX = SCOREBOARD_X_BUFFER + (SCOREBOARD_WIDTH - imageWidth) / 2;
    image(tetrisLogo, imageX, 30, imageWidth, 106.5);

    // Adds the label which says "Next Piece"
    fill(color(255));
    textAlign(CENTER);
    textSize(25);
    text("Next Piece:", SCOREBOARD_X_BUFFER, 180, SCOREBOARD_WIDTH, 40);

    // Adds the score label, which has the levels, scores, etc.
    textSize(25);
    fill(color(255)); // white color
    textLeading(35); // Sets the line height to 35, https://processing.org/reference/textLeading_.html
    textAlign(LEFT);
    text(scoreString(), SCOREBOARD_X_BUFFER + 20, SCOREBOARD_HEIGHT - 280, SCOREBOARD_WIDTH - 20, 150);

    // Draws the button backgrounds (the white rectangles)
    int buttonPadding = 20; // the buffer around each button
    int buttonWidth = SCOREBOARD_WIDTH - (2 * buttonPadding);

    rect(SCOREBOARD_X_BUFFER + buttonPadding, SCOREBOARD_HEIGHT - 2 * ((SCOREBOARD_BUTTON_HEIGHT + buttonPadding)), buttonWidth, SCOREBOARD_BUTTON_HEIGHT);
    rect(SCOREBOARD_X_BUFFER + buttonPadding, SCOREBOARD_HEIGHT - (SCOREBOARD_BUTTON_HEIGHT + buttonPadding), buttonWidth, SCOREBOARD_BUTTON_HEIGHT);

    // Sets up the text to write over the button rectangles.
    textAlign(CENTER, CENTER);
    textSize(20);
    fill(color(0)); // black color
    // If the game is over, don't let the user pause.
    if (tetris.getGameState() == GameState.OVER) {
      fill(#949494);
    }

    // Draw the text over the buttons.
    text(tetris.getGameState().opposite(), SCOREBOARD_X_BUFFER+buttonPadding, SCOREBOARD_HEIGHT - 2*((SCOREBOARD_BUTTON_HEIGHT + buttonPadding)), buttonWidth, SCOREBOARD_BUTTON_HEIGHT);
    fill(color(0)); // black color
    text("Restart", SCOREBOARD_X_BUFFER+buttonPadding, SCOREBOARD_HEIGHT - (SCOREBOARD_BUTTON_HEIGHT + buttonPadding), buttonWidth, SCOREBOARD_BUTTON_HEIGHT);
 }

  /**
  * Draws the nextPiece from the current Tetris game, and centers
  * it horizontally within the pane.
  * @param Piece piece The piece to draw.
  */
  public void drawNextPiece(Piece piece) {
    // The block image to draw the next piece.
    PImage blockImage = tetris.getPlayfield().getBlockImages()[piece.getType()];

    // Loop through the piece's blocks
    for (int row = 0; row < piece.getSize(); row++) {
      for (int col = 0; col < piece.getSize(); col++) {
        if (piece.getBlock(col, row) != 0) {
          // Draw the piece centered horizontally, and below the "Next Piece:" label
          int xOffset = SCOREBOARD_X_BUFFER + (SCOREBOARD_WIDTH - (piece.getSize() * Tetris.PLAYFIELD_BLOCK_SCALE))/2;
          int xBlockOffset = row * Playfield.BLOCK_WIDTH;
          int yOffset = (col * Playfield.BLOCK_WIDTH) + 230;
          image(blockImage, xBlockOffset + xOffset, yOffset, Playfield.BLOCK_WIDTH, Playfield.BLOCK_WIDTH);
        }
      }
    }
  }

  /**
   * Handles a mouse click, to see if the mouse has clicked over
   * any buttons.
   * @param  int mouseX The x coordinate of the mouse click.
   * @param  int mouseY The y coordinate of the mouse click.
   */
  public void handleMouse(int mouseX, int mouseY) {
    // The padding aroudn the buttons.
    int padding = 20;

    // If the mouse click is within the button's left and right bounds.
    if (mouseX > SCOREBOARD_X_BUFFER + padding && mouseX < SCOREBOARD_X_BUFFER + padding + SCOREBOARD_WIDTH) {
      // If the user clicks the top button, toggle the game state.
      if (mouseY > SCOREBOARD_HEIGHT - 2 * ((SCOREBOARD_BUTTON_HEIGHT + padding)) && mouseY < SCOREBOARD_HEIGHT - 2 * ((SCOREBOARD_BUTTON_HEIGHT + padding)) + SCOREBOARD_BUTTON_HEIGHT) {
        if (tetris.getGameState() == GameState.OVER) {
          return;
        }

        // Toggle the current game state
        if (tetris.getGameState() == GameState.PLAYING) {
          tetris.pause();
        } else {
          tetris.play();
        }
      }

      // If the user clicks the bototm butotn, restart the game.
      if (mouseY > SCOREBOARD_HEIGHT - (SCOREBOARD_BUTTON_HEIGHT + padding) && mouseY < SCOREBOARD_HEIGHT - (SCOREBOARD_BUTTON_HEIGHT + padding) + SCOREBOARD_BUTTON_HEIGHT) {
        tetris.restart();
      }
    }
  }

  /**
   * A string with the user's current level, score, and number of removedLines.
   * @return String The score string.
   */
  public String scoreString() {
    return "Level: " + tetris.getLevel() + "\n" + "High Score: " + tetris.getHighScore() + "\nScore: " + tetris.getScore() + "\n" + "Lines: " + tetris.getRemovedLines();
  }
}