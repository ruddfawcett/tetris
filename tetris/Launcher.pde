Tetris tetris;

void settings() {
  int playfieldWidth = Playfield.PLAYFIELD_BLOCK_WIDTH * Tetris.PLAYFIELD_BLOCK_SCALE;
  int playfieldHeight = Playfield.PLAYFIELD_BLOCK_HEIGHT * Tetris.PLAYFIELD_BLOCK_SCALE;
  int panelWidth = 250;
  size(playfieldWidth + panelWidth, playfieldHeight);
}

void setup() {
  surface.setTitle("Tetris");
  smooth();

  tetris = new Tetris(this);
}

void draw() {
  background(Playfield.PLAYFIELD_BACKGROUND_COLOR);
  tetris.update();
}

void keyReleased() {
  tetris.handleKey(keyCode);
}

void mousePressed() {
  tetris.handleMouse(mouseX, mouseY);
}