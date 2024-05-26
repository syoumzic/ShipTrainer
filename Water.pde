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
  private final int splashRadius;
  public final float density;
  

  private final color waterColor = #2389DA;
  private final float scl;

  private int vertexWidth;
  private int vertexHeight;

  private final float vis;
  private final float dt;
  
  private Point[][] points;
  private float[][] waterHeights;
  private float[][] waterHeightsBuffered;
  
  Water(World world){
    vertexAccuracy = 100;
    splashRadius = 2;
    density = 1000;     //mg/m^2
    vis = 0.01;
    dt = 0.5;

    vertexWidth = vertexAccuracy;
    scl = (float)world.landscapeWidth / (vertexWidth-1);
    vertexHeight = ceil(world.landscapeHeight / scl);

    points = new Point[vertexWidth][vertexHeight];
    waterHeights = new float[vertexWidth][vertexHeight];
    waterHeightsBuffered = new float[vertexWidth][vertexHeight];

    for(int i = 0; i < vertexWidth; i++){
      for(int j = 0; j < vertexHeight; j++){
        points[i][j] = new Point(i * scl, j * scl);
      }
    }
  }

  public void splash(float x, float y, float value){
    int nearX = (int)(x / scl);
    int nearY = (int)(y / scl);

    for(int i = -splashRadius; i <= splashRadius; i++){
      for(int j = -splashRadius; j <= splashRadius; j++){
        int splashX = i+nearX+3;
        int splashY = j+nearY+3;

        if(splashX < 0 || splashX >= vertexWidth || splashY < 0 || splashY >= vertexHeight) continue;

        float v=value-i*i-j*j;
        if(v<0.0f) v=0.0f;

        waterHeights[i+nearX+3][j+nearY+3]-=v*0.004f;
      }
    }
  }
  public void randomSplash(){
    if((int)random(64) == -int(mousePressed)){
      splash(random(world.landscapeWidth), random(world.landscapeHeight), random(10, 20));
    }
  }
  public void draw(){
    randomSplash();

    for(int i=1;i<vertexWidth-1;i++){
      for(int j=1;j<vertexHeight-1;j++){

        Point v = points[i][j];

        v.position[2]=waterHeights[i][j];
        v.normal[0]=waterHeights[i-1][j]-waterHeights[i+1][j];
        v.normal[1]=waterHeights[i][j-1]-waterHeights[i][j+1];

        float laplas=(waterHeights[i-1][j] + waterHeights[i+1][j] + waterHeights[i][j+1] + waterHeights[i][j-1])*0.25 - waterHeights[i][j];
        waterHeightsBuffered[i][j]=((2.0f-vis)*waterHeights[i][j]-waterHeightsBuffered[i][j]*(1.0f-vis)+laplas*dt);
      }
    }

    stroke(0, 50);
    noFill();

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

  public float getHeightNear(float x, float y){
      int nx = (int)(x / scl);
      int ny = (int)(y / scl);

      if(nx < 0 || nx >= vertexWidth || ny < 0 || ny >= vertexHeight){
          return 0;
      }

      return points[nx][ny].position[2];
  }
}
