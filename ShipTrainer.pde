public World world;
public Manipulator manipulator;

public void setup(){
  fullScreen(P3D);
  manipulator = new Manipulator(this);
  world = new World(this, manipulator);
}

public void draw(){
  // if(!manipulator.connected()){
  //   manipulator.reconnect(this);
  // }

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
    Quaterion queatrionX = new Quaterion(angle.x, new PVector(1, 0, 0));
    Quaterion queatrionY = new Quaterion(angle.y, new PVector(0, 1, 0));
    Quaterion queatrionZ = new Quaterion(angle.z, new PVector(0, 0, 1));

    Quaterion point = new Quaterion(vector);
    
    point = queatrionX.H(point).H(queatrionX.conjugate());
    point = queatrionY.H(point).H(queatrionY.conjugate());
    point = queatrionZ.H(point).H(queatrionZ.conjugate());

    PVector modyfied = point.toVector();
    vector.set(modyfied.x, modyfied.y, modyfied.z);
}

public PVector avarage(PVector... vectors){
    PVector avarage = new PVector();
    for(PVector v : vectors){
      avarage.x += v.x;
      avarage.y += v.y;
      avarage.z += v.z;
    }
    return avarage.div(vectors.length);
}