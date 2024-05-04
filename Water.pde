import peasy.*;

class Water implements Drawable{
  private final int vertexAccuracy = 100;
  private final float speed = 0.01f;
  private final float smooth = 0.08f;

  private final float scl;

  private int vertexWidth;
  private int vertexHeight;
  
  Water(World world){
    vertexWidth = vertexAccuracy;
    scl = (float)world.landscapeWidth / vertexWidth;
    vertexHeight = ceil(world.landscapeHeihgt / scl);
  }
  
  private void scaledVertex(int x, int y){
    vertex(x * scl , y * scl, 0);
  }
  
  // private float scaledNoise(float x, float y){
  //   return noise(x * smooth, y * smooth, frameCount * speed); 
  // }
  
  void draw(){
    stroke(0);
    fill(255);
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
