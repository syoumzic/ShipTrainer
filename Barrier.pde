class Barrier extends Model {
  private final PVector position;
  PShape body;

  Barrier(PShape body, Water water, PVector position){
    super(body);

    this.position = position;
    water.splash(position.x, position.y);
  }

  void transformations(){
    translate(position.x, position.y, position.z);
  }
}