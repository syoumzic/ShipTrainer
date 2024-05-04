public World world;

void setup(){
  fullScreen(P3D);
  world = new World();
}

void draw(){
  world.draw();
}