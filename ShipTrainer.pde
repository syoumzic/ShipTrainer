import java.util.List;
import processing.opengl.*;

List<Drawable> gameObjects = new ArrayList<>();

void setup(){
  size(1920, 1280, OPENGL);
  
  Water water = new Water(this);
  Ship ship = new Ship();
  
  //Point<Integer>center = water.getCenterPosition();
  //Point<Integer>from = new Point<Integer>(center.x, 10000, center.y);
  //camera.setLookAtPosition(from, center);
  
  gameObjects.add(water);
  gameObjects.add(ship);

  background(#568770);

  for(Drawable gameObject : gameObjects){
    gameObject.draw(); 
  }
}

void draw(){

}