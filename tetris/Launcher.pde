/**
 * Citations: https://forum.processing.org/one/topic/how-to-display-text-in-the-title-of-the-display-window.html
 */

/**
 * Creates a new instance of the Tetris game, and
 * also houses all of the required Processing functions.
 *
 * @author Rudd Fawcett
 */

/**
 * The Tetris game instance.
 */
Tetris tetris;

void settings() {
  size(Playfield.PLAYFIELD_WIDTH + Scoreboard.SCOREBOARD_WIDTH, Playfield.PLAYFIELD_HEIGHT);
}

/**
 * Run once at the beginning of a program session's
 * life-span. Sets up the window bounds, and constructs
 * a new Tetris game.
 */
void setup() {
  // Set the title of the window
  // https://forum.processing.org/one/topic/how-to-display-text-in-the-title-of-the-display-window.html
  surface.setTitle("Tetris");
  smooth();

  tetris = new Tetris(this);
}

/**
 * The draw method is called directly after setup(), and
 * is called continuously until told to stop. It handles
 * the updates of the GUI.
 */
void draw() {
  background(Scoreboard.SCOREBOARD_BACKGROUND_COLOR);
  // Update all of the Tetris game components.
  tetris.update();
}

/**
 * A Processing listener which is called whenever a key
 * is released. Passes the keyCode to the Tetris instance
 * in order to handle GUI updates, AKA piece movement.
 */
void keyReleased() {
  tetris.handleKey(keyCode);
}

/**
 * A Processing listener which is called whenever the mouse
 * is clicked. Passes the x and y coordinates of the mouse
 * click to the Tetris instance in order to detect button
 * clicks.
 */
void mousePressed() {
  tetris.handleMouse(mouseX, mouseY);
}
