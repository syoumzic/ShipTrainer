import processing.opengl.*;

public World world;
public Manipulator manipulator;

public void setup(){
  size(1280, 720, OPENGL);
  manipulator = new Manipulator(this);
  manipulator.start();
  world = new World(this, manipulator);
}

public void draw(){
   if(!manipulator.connected()){
     manipulator.reconnect(this);
   }
  world.draw();
}

public void mouseWheel(MouseEvent event){
  world.mouseWheel(event);
}

@Override
public void exit(){
  manipulator.exit();
  super.exit();
}

public PShape getShape(String name){
  return loadShape("assets/%s/%s.obj".formatted(name, name));
}

public float relu(float value){
  return value > 0? value : 0; 
}