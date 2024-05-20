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

void mouseWheel(MouseEvent event){
  world.mouseWheel(event);
}

@Override
void exit(){
  manipulator.exit();
  super.exit();
}

public <Type> void swap(Type a, Type b){
  Type temp = b;
  b = a;
  a = temp;
}

PShape getShape(String name){
  return loadShape("assets/%s/%s.obj".formatted(name, name));
}