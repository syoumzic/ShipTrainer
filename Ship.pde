class Ship extends Model {
  final float speed;
  final float velocitySpeed;

  private float angle;
  private PVector velocity;
  private PVector position;

  Ship(PShape body){
    super(body);

    speed = 0.01;
    velocitySpeed = 0.01;
    angle = 0;

    position = new PVector(2.03529, 1.86403, 0);
    velocity = PVector.fromAngle(angle).mult(speed);
  }

  void transformations(){
    translate(position.x, position.y, position.z);
    rotateZ(velocity.heading());
  }

  void update() {
    if(Keyboard.up()){
      position.add(velocity);
    }

    else if(Keyboard.down()){
      position.sub(velocity);
    }

    if (Keyboard.left()){
      velocity.rotate(-velocitySpeed);
    }

    else if(Keyboard.right()) {
      velocity.rotate(velocitySpeed);
    }
  }
}