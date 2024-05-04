class Ship implements Drawable{
  PShape body;
  PVector position;

  Ship(World world){
    body = loadShape("asserts/ship/ship.obj");
    position = new PVector(world.landscapeWidth/2, world.landscapeHeihgt/2, 0);
  }

  void update(){
    
  }
  
  void draw(){
    pushMatrix();
    
    translate(position.x, position.y, position.z);
    shape(body);

    popMatrix();
  }
}
