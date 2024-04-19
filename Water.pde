class Water implements Drawable{
  final int pointWidth = 100;
  final int pointHeight = 100;
  final color waterColor = #6ba0cc;
  
  final int scale = 100;
  
  Point<Float>rotations = new Point<>(0f, 0f, 0f);
  Point<Float>translations = new Point<>(0f, 0f, 0f);
  
  void update(){
    
  }
  
  void vertexC(int x, int y, int z){
    vertex(x * scale, y * scale, z * scale); 
  }
  
  void draw(){
    translate(translations.x, translations.y, translations.z);
    rotateX(rotations.x);
    rotateY(rotations.y);
    rotateZ(rotations.z);
    
    //noStroke();
    noFill();
    //fill(waterColor);
    
    for(int i = 0; i < pointWidth - 1; i++){
      beginShape(TRIANGLE_STRIP);
      for(int j = 0; j < pointHeight; j++){
        vertexC(i, 0, j);
        vertexC(i+1, 0, j);
      }
      endShape();
    }
    
    
  }
}
