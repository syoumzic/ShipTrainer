class Barrier implements Drawable {
  private PVector[] positions;
  private final PShape body;

  Barrier(Water water){
    this.body = getShape("barrier");
    this.positions = new PVector[]{new PVector(1.7, 1.92, -0.2), new PVector(2.36, 1.92, -0.2)};
  }

  public void draw(){
    for(PVector position: positions){
      pushMatrix();
      
      translate(position.x, position.y, position.z);
      shape(body);

      popMatrix();
    }
  }
}