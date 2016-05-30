/**
 * The state of the Tetris game.
 *
 * @author Rudd Fawcett
 */
public enum GameState {
  PAUSED,
  PLAYING,
  OVER;

  /**
   * The opposite state of the game.
   * Used to show the button text.
   */
  public String opposite() {
   if (this == PAUSED) {
     return "Play";
   }

   return "Pause";
  }
}
