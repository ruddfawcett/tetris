Tetris tetris;

void settings() {
  size(300, 600);
}

void setup() {
  surface.setTitle("Tetris");
  frameRate(120);
  background(0);
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