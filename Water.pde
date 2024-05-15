import processing.opengl.*;

class Point {
  public float position[] = new float[3];
  public float normal[] = new float[3];

  Point(float x, float y){
    position[0] = x;
    position[1] = y;
    position[2] = 0;

    normal[0] = 0;
    normal[1] = 0;
    normal[2] = 1;
  }
};

class Water implements Drawable{
  private final int vertexAccuracy;
  private final float speed;
  private final float smooth;

  private final color waterColor = #2389DA;
  private final float scl;

  private int vertexWidth;
  private int vertexHeight;

  private float vis = 0.01f;
  
  Point[][] points;
  float[][] waterHeights;
  float[][] waterHeightsBuffered;
  
  Water(World world){
    vertexAccuracy = 100;
    speed = 0.01f;
    smooth = 0.08f;

    vertexWidth = vertexAccuracy;
    scl = (float)world.landscapeWidth / (vertexWidth-1);
    vertexHeight = ceil(world.landscapeHeihgt / scl);

    points = new Point[vertexWidth][vertexHeight];
    waterHeights = new float[vertexWidth][vertexHeight];
    waterHeightsBuffered = new float[vertexWidth][vertexHeight];

    for(int i = 0; i < vertexWidth; i++){
      for(int j = 0; j < vertexHeight; j++){
        points[i][j] = new Point(i * scl, j * scl);
      }
    }
  }

  public void splash(float x, float y){
    int floorX = (int)(x / scl);
    int floorY = (int)(y / scl);

    for(int i = -3; i < 4; i++){
      for(int j = -3; j < 4; j++){
        float v=10.0f-i*i-j*j;
        if(v<0.0f) v=0.0f;
        waterHeights[i+floorX+3][j+floorY+3]-=v*0.004f;
      }
    }
  }
  
  public void draw(){
    for(int i=1;i<vertexWidth-1;i++){
      for(int j=1;j<vertexHeight-1;j++){

        Point v = points[i][j];

        v.position[2]=waterHeights[i][j];
        v.normal[0]=waterHeights[i-1][j]-waterHeights[i+1][j];
        v.normal[1]=waterHeights[i][j-1]-waterHeights[i][j+1];

        float laplas=(waterHeights[i-1][j] + waterHeights[i+1][j] + waterHeights[i][j+1] + waterHeights[i][j-1])*0.25 - waterHeights[i][j];
        waterHeightsBuffered[i][j]=((2.0f-vis)*waterHeights[i][j]-waterHeightsBuffered[i][j]*(1.0f-vis)+laplas);
      }
    }
    stroke(#000000);
    fill(waterColor);
    for(int i = 1;i < vertexWidth-1; i++){
      beginShape(TRIANGLE_STRIP);
      for(int j = 1;j < vertexHeight; j++){
        normal(points[i][j].normal[0], points[i][j].normal[1], points[i][j].normal[2]);
        vertex(points[i][j].position[0], points[i][j].position[1], points[i][j].position[2]);
        normal(points[i + 1][j].normal[0], points[i + 1][j].normal[1], points[i + 1][j].normal[2]);
        vertex(points[i + 1][j].position[0], points[i + 1][j].position[1], points[i + 1][j].position[2]);
      }
      endShape();
    }

    float[][] tempHeight = waterHeights;
    waterHeights = waterHeightsBuffered;
    waterHeightsBuffered = tempHeight;
  }
}