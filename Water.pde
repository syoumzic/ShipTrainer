import peasy.*;

class Water implements Drawable{
  PeasyCam cam;
  

  // color waterColor = #21BBFF;
  // color secondWaterColor = #0F61A7;
  // color waterColor = #000000;
  // color secondWaterColor = #ffffff;
  
  final int vertexAccuracy = 100;

  int landscapeWidth = (int)(width * 4.1849);
  int landscapeHeihgt = (int)(width * 10.0422);

  private final float scl = landscapeWidth / vertexAccuracy;

  int vertexWidth = ceil(landscapeWidth / scl);
  int vertexHeight = ceil(landscapeHeihgt / scl);
  
  float speed = 0.01f;
  float smooth = 0.08f;
  float waterHeight = 200f;
  
  Water(PApplet papplet){
    cam = new PeasyCam(papplet, 400);
  }
  
  void update(){
    
  }
  
  private void scaledVertex(int x, int y){
    // float value = sin(pow(1 - dist(x, y, vertexWidth/2f, vertexHeight/2f) / dist(0, 0, vertexWidth/2f, vertexHeight/2f), 3) * HALF_PI);
    // fill(lerpColor(waterColor, secondWaterColor, value));
    vertex(x * scl , y * scl, 0);
  }
  
  private float scaledNoise(float x, float y){
    return noise(x * smooth, y * smooth, frameCount * speed); 
  }

  // void camera(float a, float b, float c, float d, float e, float f, int aa, int bb, int cc){
  //   println(HALF_PI - atan2(sqrt(sq(a - d) + sq(b - e) + sq(c - f)) / width, 0.5));
  // }
  
  void draw(){
    camera(2.0815 * width, 4.1498 * width, 1.3398 * width, 2.0815 * width, 3.311 * width, 0.7858 * width, 0, 1, 0);
    perspective(0.46156168, float(width)/float(height), 0.5, 10000);
    
    // translate(width/2 - landscapeWidth/2, 3.244 * width, -1.893 * width);
    // rotateX(0.695);
    
    // pointLight(125, 125, 125, w/2, 0, -100);
    //ambientLight(255, 255, 255);
    
    // noStroke();
    // fill(waterColor);
    // fill(#fa046c);
    // rect(0, 0, width * 4.1849, width * 3.0422);

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
