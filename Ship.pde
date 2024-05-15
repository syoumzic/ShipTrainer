class Ship extends Model {
  final float speed;
  final float velocitySpeed;
  private final Manipulator manipulator;

  private float angle;
  private PVector velocity;
  private PVector position;
  private float angleSpeed;

  Ship(PShape body, Water water, Manipulator manipulator){
    super(body);

    this.manipulator = manipulator;

    speed = 0.01;
    velocitySpeed = 0.01;
    angle = 0;

    position = new PVector(2.03529, 1.86403, 0);
    water.splash(position.x, position.y);
    velocity = PVector.fromAngle(angle).mult(speed);
  }

  void transformations(){
    translate(position.x, position.y, position.z);
    rotateZ(velocity.heading());
  }

  void update(){
    PVector acceleration = manipulator.getAccelerations();
    angleSpeed = acceleration.y / 255;
  }
}