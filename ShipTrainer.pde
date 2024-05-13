public World world;

void setup(){
  fullScreen(P3D);
  world = new World();
}

void draw(){
  world.update();
  world.draw();
}

void keyPressed(){
  Keyboard.keyPressed(keyCode);
}

void keyReleased(){
  Keyboard.keyReleased(keyCode);
}