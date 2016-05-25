Tetris tetris;

void settings() {
  int playfieldWidth = Playfield.PLAYFIELD_BLOCK_WIDTH * Tetris.PLAYFIELD_BLOCK_SCALE;
  int playfieldHeight = Playfield.PLAYFIELD_BLOCK_HEIGHT * Tetris.PLAYFIELD_BLOCK_SCALE;
  size(playfieldWidth, playfieldHeight);
}

void setup() {
  surface.setTitle("Tetris");
  smooth();

  tetris = new Tetris();
  tetris.newGame();
}

void draw() {
  background(tetris.BACKGROUND_COLOR);
  tetris.update();
}

void keyReleased() {
  tetris.handleKey(keyCode);
}