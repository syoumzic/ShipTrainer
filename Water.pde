import peasy.*;

class Water implements Drawable{
  private final int vertexAccuracy;
  private final float speed;
  private final float smooth;
  private final float waterHeight;

  private final color waterColor = #2389DA;

  private final float scl;

  private int vertexWidth;
  private int vertexHeight;
  
  Water(World world){
    vertexAccuracy = 100;
    speed = 0.01f;
    smooth = 0.08f;
    waterHeight = 0.03;

    vertexWidth = vertexAccuracy;
    scl = (float)world.landscapeWidth / (vertexWidth-1);
    vertexHeight = ceil(world.landscapeHeihgt / scl);
  }
  
  private void scaledVertex(int x, int y){
    vertex(x * scl, y * scl, 0);
  }

  // private void scaledVertex(int x, int y){
  //   vertex(x * scl, y * scl, scaledNoise(x, y));
  // }
  
  // private float scaledNoise(float x, float y){
  //   return noise(x * smooth, y * smooth, frameCount * speed) * waterHeight; 
  // }
  
  void draw(){
    stroke(0);
    fill(waterColor);
    beginShape(TRIANGLES);
    for (int y = 0; y < vertexHeight-1; y++) {  
      for (int x = 0; x < vertexWidth-1; x++) {
        scaledVertex(x, y);
        scaledVertex(x, y+1);
        scaledVertex(x+1, y);
        
        scaledVertex(x, y+1);
        scaledVertex(x+1, y);
        scaledVertex(x+1, y+1);
      }
    }
    endShape();   
  }
}