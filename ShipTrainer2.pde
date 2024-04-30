import java.util.List;
import processing.opengl.*;

List<Drawable> gameObjects = new ArrayList<>();
CustomServer server;

void setup(){
  size(1920, 1280, OPENGL);
  
  Sky sky = new Sky();
  Water water = new Water(this);
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
