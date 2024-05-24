public World world;
public Manipulator manipulator;

public void setup(){
  size(1280, 720, P3D);
  manipulator = new Manipulator(this);
  manipulator.start();
  world = new World(manipulator);
}

public void draw(){
   if(!manipulator.connected()){
     manipulator.reconnect(this);
   }
  world.draw();
}

public void mousePressed(){
  world.mousePressed();
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

public void rotateVector(PVector vector, PVector angle) {
    Quaternion quaternionX = new Quaternion(angle.x, new PVector(1, 0, 0));
    Quaternion quaternionY = new Quaternion(angle.y, new PVector(0, 1, 0));
    Quaternion quaternionZ = new Quaternion(angle.z, new PVector(0, 0, 1));

    Quaternion point = new Quaternion(vector);
    
    point = quaternionX.H(point).H(quaternionX.conjugate());
    point = quaternionY.H(point).H(quaternionY.conjugate());
    point = quaternionZ.H(point).H(quaternionZ.conjugate());

    PVector modified = point.toVector();
    vector.set(modified.x, modified.y, modified.z);
}

public PVector average(PVector... vectors){
    PVector average = new PVector();
    for(PVector v : vectors){
      average.x += v.x;
      average.y += v.y;
      average.z += v.z;
    }
    return average.div(vectors.length);
}