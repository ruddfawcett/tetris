/**
 * 
 */
class Scoreboard {
  private static final int SCOREBOARD_WIDTH = 250;
  private final int SCOREBOARD_HEIGHT;

  private final int SCOREBOARD_BUTTON_HEIGHT = 40;
  private final color SCOREBOARD_BACKGROUND_COLOR = #2A2A2A;

  private Tetris tetris;
  private PImage tetrisLogo;

  private final int SCOREBOARD_X_BUFFER = Playfield.PLAYFIELD_WIDTH + 1;

  Scoreboard(Tetris tetris) {
    this.tetris = tetris;
    this.SCOREBOARD_HEIGHT = Playfield.PLAYFIELD_HEIGHT;

    this.tetrisLogo = loadImage("graphics/tetris-logo.png");
  }

  void draw() {
      // General pane -- all black rectangle
      noStroke();
      fill(SCOREBOARD_BACKGROUND_COLOR);
      rect(SCOREBOARD_X_BUFFER, 0, SCOREBOARD_WIDTH, SCOREBOARD_HEIGHT);

      // Drawing the Tetris logo at the top of the pane
      float imageWidth = 154.5;
      float imageX = SCOREBOARD_X_BUFFER + (SCOREBOARD_WIDTH - imageWidth) / 2;
      image(tetrisLogo, imageX, 30, imageWidth, 106.5);

      // The next piece to be played

      fill(color(255));
      textAlign(CENTER);
      textSize(25);
      text("Next Piece:", SCOREBOARD_X_BUFFER, 180, SCOREBOARD_WIDTH, 40);

      // Adding the actual scoring label
      textSize(25);
      fill(color(255));
      textLeading(35);
      textAlign(LEFT);
      text(scoreString(), SCOREBOARD_X_BUFFER + 20, SCOREBOARD_HEIGHT - 250, SCOREBOARD_WIDTH - 20, 150);

      // Buttons!

      int buttonPadding = 20;
      int buttonWidth = SCOREBOARD_WIDTH - (2 * buttonPadding);

      rect(SCOREBOARD_X_BUFFER + buttonPadding, SCOREBOARD_HEIGHT - 2 * ((SCOREBOARD_BUTTON_HEIGHT + buttonPadding)), buttonWidth, SCOREBOARD_BUTTON_HEIGHT);
      rect(SCOREBOARD_X_BUFFER + buttonPadding, SCOREBOARD_HEIGHT - (SCOREBOARD_BUTTON_HEIGHT + buttonPadding), buttonWidth, SCOREBOARD_BUTTON_HEIGHT);

      textAlign(CENTER, CENTER);
      textSize(20);
      fill(color(0));
      if (tetris.getGameState() == GameState.OVER) {
        fill(#949494);
   }
   text(tetris.getGameState().buttonText(), SCOREBOARD_X_BUFFER+buttonPadding, SCOREBOARD_HEIGHT - 2*((SCOREBOARD_BUTTON_HEIGHT + buttonPadding)), buttonWidth, SCOREBOARD_BUTTON_HEIGHT);
   fill(color(0));
   text("Restart", SCOREBOARD_X_BUFFER+buttonPadding, SCOREBOARD_HEIGHT - (SCOREBOARD_BUTTON_HEIGHT + buttonPadding), buttonWidth, SCOREBOARD_BUTTON_HEIGHT);
 }

 void drawNextPiece(Piece piece) {
   Playfield playfield = tetris.getPlayfield(); PImage blockImage = playfield.getBlockImages()[piece.getType()];

  int blockWidth = playfield.getBlockWidth(); int padding = 20;

  int x = piece.getX(); int y = piece.getY();

  for (int row = 0; row < piece.getSize(); row++)
    for (int col = 0; col < piece.getSize(); col++) {
      if (piece.getBlock(col, row) != 0) {
        int xOffset = (x + row) * blockWidth;
        int yOffset = (y + col) * blockWidth;
        image(blockImage, xOffset + (SCOREBOARD_X_BUFFER - 45) + padding, yOffset + 230, blockWidth, blockWidth);
      }
    }
  }

  void handleMouse(int mouseX, int mouseY) {
    int padding = 20;

    // if within button width
    if (mouseX > SCOREBOARD_X_BUFFER + padding && mouseX < SCOREBOARD_X_BUFFER + padding + SCOREBOARD_WIDTH) {
      // Top button
      if (mouseY > SCOREBOARD_HEIGHT - 2 * ((SCOREBOARD_BUTTON_HEIGHT + padding)) && mouseY < SCOREBOARD_HEIGHT - 2 * ((SCOREBOARD_BUTTON_HEIGHT + padding)) + SCOREBOARD_BUTTON_HEIGHT) {
        if (tetris.getGameState() == GameState.OVER) {
          return;
        }

        if (tetris.getGameState() == GameState.PLAYING) {
          tetris.pause();
        } else {
          tetris.play();
        }
      }

      if (mouseY > SCOREBOARD_HEIGHT - (SCOREBOARD_BUTTON_HEIGHT + padding) && mouseY < SCOREBOARD_HEIGHT - (SCOREBOARD_BUTTON_HEIGHT + padding) + SCOREBOARD_BUTTON_HEIGHT) {
        tetris.restart();
      }
    }
  }

  String scoreString() {
    return "Level: " + tetris.getLevel() + "\n" + "Score: " + tetris.getScore() + "\n" + "Lines: " + tetris.getRemovedLines();
  }
}