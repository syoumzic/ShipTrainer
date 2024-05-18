public World world;
public Manipulator manipulator;

void setup(){
  fullScreen(P3D);
  manipulator = new Manipulator(this);
  world = new World(this, manipulator);
}

void draw(){
  if(!manipulator.connected()){
    manipulator.reconnect(this);
  }

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

float traingaeArea(PVector a, PVector b, PVector c){
    return 0.5 * abs((b.x - a.x)*(c.y - a.y) - (c.x - a.x)*(b.y - a.y));
}

PShape getShape(String name){
  return loadShape("assets/%s/%s.obj".formatted(name, name));
}