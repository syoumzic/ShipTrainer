import peasy.*;

class Water implements Drawable{
  PeasyCam cam;
  
  int vertexWidth = 1000;
  int vertexHeight = 1000;
  color waterColor = #6ba0cc;
  color strokeColor = #0D6CB7;
  
  int w = 5000;
  int h = 5000;
  
  float angle = -2.6;
  
  Point3D<Integer>translations = new Point3D<Integer>(-1510, 1380, -100);
  
  private final int sclW = 100;
  private final int sclH = 100;
  float speed = 0.00f;
  float smooth = 0.001f;
  float waterHeight = 700f;
  
  Water(PApplet papplet){
    cam = new PeasyCam(papplet, 400);
  }
  
  void update(){
    
  }
  
  private void scaledVertex(int x, int y){
    vertex(x * sclW, y * sclH, (int)(-scaledNoise(x, y) * waterHeight));
  }
  
  private float scaledNoise(float x, float y){
    return noise(x * sclW * smooth + frameCount * speed, y * sclH * smooth); 
  }
  
  void draw(){
    //translate(translations.x, translations.y, translations.z);
    //rotateX(angle);
    float[] position = cam.getPosition();
    pointLight(125, 125, 125, position[0], position[1], position[2]);
    ambientLight(255, 255, 255);
    
    noStroke();
    fill(waterColor);
    
    beginShape(TRIANGLE_STRIP);
    for (int y = 0; y < vertexHeight; y++) {  
      for (int x = 0; x <= vertexWidth; x++) {
        scaledVertex(x, y);
        scaledVertex(x, y+1);
      }
      
      scaledVertex(vertexWidth, y+1);
      
      for (int x = vertexWidth; x >= 0; x--) {
        scaledVertex(x, y+1);
        scaledVertex(x, y+2);
      }
      
      scaledVertex(0, y+2);
    }
    endShape();   
  }
}
