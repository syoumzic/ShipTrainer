import peasy.*;

class Water implements Drawable{
  PeasyCam cam;
  
  int vertexWidth = 100;
  int vertexHeight = 50;
  color waterColor = #6ba0cc;
  color secondWaterColor = #1F77C1;
  color strokeColor = #0D6CB7;
  
  int w = 5000;
  int h = 5000;
  
  float angle = -2.6;
  
  Point3D<Integer>translations = new Point3D<Integer>(-1510, 1380, -100);
  
  private final float scl = max((float)w / vertexWidth, (float)h / vertexHeight);
  float speed = 0.01f;
  float smooth = 0.08f;
  float waterHeight = 700f;
  
  Water(PApplet papplet){
    cam = new PeasyCam(papplet, 400);
  }
  
  void update(){
    
  }
  
  private void scaledVertex(int x, int y){
    float value = scaledNoise(x, y);
    fill(lerpColor(#21BBFF, #0F61A7, value));
    vertex(x * scl , y * scl, -value * waterHeight);
  }
  
  private float scaledNoise(float x, float y){
    return noise(x * smooth, y * smooth, frameCount * speed); 
  }
  
  void draw(){
    translate(-translations.x, translations.y, translations.z);
    rotateX(angle);
    rotateY(PI);
    
    //pointLight(125, 125, 125, w/2, 0, -100);
    //ambientLight(255, 255, 255);
    
    noStroke();
    fill(waterColor);
    
    beginShape(TRIANGLES);
    for (int y = 0; y <= vertexHeight; y++) {  
      for (int x = 0; x <= vertexWidth; x++) {
        scaledVertex(x, y);
        scaledVertex(x, y+1);
        scaledVertex(x+1, y);
        
        scaledVertex(x, y+1);
        scaledVertex(x+1, y);
        scaledVertex(x+1, y+1);
      }`
    }
    endShape();   
  }
}
