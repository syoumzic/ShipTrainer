class Barrier extends Model {
  private final PVector position;
  PShape body;

  Barrier(PShape body, float x, float y, float z){
    super(body);
    position = new PVector(x, y, z);
  }

  void transformations(){
    translate(position.x, position.y, position.z);
  }
}