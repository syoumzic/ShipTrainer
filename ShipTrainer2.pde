import peasy.*;
import java.util.List;

List<Drawable> gameObjects = new ArrayList<>();
CustomServer server;

void setup(){
  size(600, 600, P3D);
  
  Sky sky = new Sky();
  Water water = new Water();
  Ship ship = new Ship();
  
  server = new CustomServer(this, water);
  
  //Point<Integer>center = water.getCenterPosition();
  //Point<Integer>from = new Point<Integer>(center.x, 10000, center.y);
  //camera.setLookAtPosition(from, center);
  
  gameObjects.add(sky);
  gameObjects.add(water);
  gameObjects.add(ship);
}

void draw(){
  server.update();
  
  for(Drawable gameObject : gameObjects){
    gameObject.draw(); 
  }
}
