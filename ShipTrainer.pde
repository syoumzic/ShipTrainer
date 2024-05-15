public World world;
public Manipulator manipulator;

void setup(){
  fullScreen(P3D);
  manipulator = new Manipulator(this);
  world = new World(manipulator);
}

void draw(){
  if(!manipulator.connected()){
    manipulator.reconnect(this);
  }

  world.update();
  world.draw();
}

void mousePressed(){
  world.mousePressed();
}

@Override
void exit(){
  manipulator.exit();
  super.exit();
}