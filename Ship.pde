import java.util.Arrays;
import java.lang.Math;
import java.beans.*;

class Ship implements Drawable, PropertyChangeListener{
  private final Water water;
  private final PShape body;
  private final Model frame;
  private final World world;
  private final float dt;
  private final float thrustForceValue;
  private final float velocityAttenuation, angularAttenuation;

  private final float mass;

  private final float[][] J, invJ;

  private PVector angle, enginePosition, position, velocity, angularVelocity, accumulateForce, accumulateAngularVelocity;
  Force thrust;
  Ship(World world, Water water){
    this.mass = 0.1; //kg
    this.thrustForceValue = 1; //N

    this.angle = new PVector(0, 0, 0);
    this.position = new PVector(0, 0, 0);
    this.velocity = new PVector(0, 0, 0);
    this.angularVelocity = new PVector(0, 0, 0);
    this.enginePosition = new PVector(-0.4, 0, 0);
    this.thrust = new Force();

    this.accumulateForce = new PVector();
    this.accumulateAngularVelocity = new PVector();

    this.dt = 1/60f;
    this.velocityAttenuation = 0.4f;
    this.angularAttenuation = 0.4f;

    J = new float[][]{{0.00207997, 0, 0},
                      {0, 0.00020449, 0},
                      {0, 0, 0.00223293}};

    invJ = new float[][]{{480.77564892, 0, 0},
                         {0, 4890.1503999, 0},
                         {0, 0, 447.84175606}};

    this.world = world;
    this.water = water;

    this.frame = new Model(getShape("frame"));
    this.body = getShape("ship");
    translateShip(new PVector(2.03529, 1.86403, -0.1));

    water.splash(position.x, position.y, 5);
  }

  public void propertyChange(PropertyChangeEvent evt) {
    Manipulator manipulator = (Manipulator) evt.getSource();
    PVector manipulatorInput = manipulator.getInput();

    PVector acrossForce = new PVector(map(manipulatorInput.y, 0, 255, -thrustForceValue, thrustForceValue), 0, 0);
    rotateVector(acrossForce, angle);
    rotateVector(acrossForce, new PVector(0, 0, map(manipulatorInput.x-20, 0, 255, -0.1, 0.1)));
    
    this.thrust = new Force(enginePosition, acrossForce);
  }

  private void translateShip(PVector positionShift){
    position.add(positionShift);
    enginePosition.add(positionShift);
    frame.translate(positionShift);
  }

  private void rotateShip(PVector angularShift){
    angle.add(angularShift);

    frame.translate(new PVector(-position.x, -position.y, -position.z));
    frame.rotate(angularShift);
    frame.translate(new PVector(position.x, position.y, position.z));

    enginePosition.sub(position);
    rotateVector(enginePosition, angularShift);
    enginePosition.add(position);
  }

  private float triangleArea(PVector a, PVector b, PVector c){
      return 0.5 * abs((b.x - a.x)*(c.y - a.y) - (c.x - a.x)*(b.y - a.y));
  }

  private void addFlowedFace(Face face){
    // stroke(0);
    // noFill();
    // face.draw();

    PVector center = average(face.vertexes[0], face.vertexes[1], face.vertexes[2]);
    float height = center.z - water.getHeightNear(center.x, center.y);
    
    PVector force = face.normal.mult(water.density)
                               .mult(world.gravity)
                               .mult(height)
                               .mult(triangleArea(face.vertexes[0], face.vertexes[1], face.vertexes[2]));

    force.z = max(force.z, 0);
    force.x = 0;
    force.y = 0;

    addForce(center, force);
  }

  //force задана в ск1 point тоже
  private void addForce(PVector point, PVector force){
    PVector a = point.copy();
    PVector b = point.copy().add(force);
    line(a.x, a.y, a.z, b.x, b.y, b.z);
    pushMatrix();
    translate(b.x, b.y, b.z);
    box(0.001);
    popMatrix();

    accumulateForce.add(force);

    point.sub(position);
    rotateVector(point, new PVector(-angle.x, -angle.y, -angle.z));
    rotateVector(force, new PVector(-angle.x, -angle.y, -angle.z));

    PVector M = point.cross(force);
    PVector W = M.copy()
                 .sub(angularVelocity.cross(diagonalMult(J, angularVelocity)));
    
    accumulateAngularVelocity.add(W);
  }

  private PVector diagonalMult(float[][] matrix, PVector a){
    return new PVector(matrix[0][0] * a.x, matrix[1][1] * a.y, matrix[2][2] * a.z);
  }

  private void drawTriangle(PVector u, PVector v, PVector k){
    noStroke();
    beginShape();
        vertex(u.x, u.y, u.z);
        vertex(v.x, v.y, v.z);
        vertex(k.x, k.y, k.z);
    endShape();
  }

  public void draw(){
    accumulateForce.set(0, 0, 0);
    accumulateAngularVelocity.set(0, 0, 0);

    for(Face face : frame){
      PVector[] vertexes = face.copy().vertexes;

      for(PVector v: vertexes){
        v.z -= water.getHeightNear(v.x, v.y);
      }

      Integer[] indexes = new Integer[]{0, 1, 2};
      Arrays.sort(indexes, (Integer ia, Integer ib) -> (vertexes[ia].z < vertexes[ib].z? -1 : 1));

      PVector U = vertexes[indexes[0]];
      PVector V = vertexes[indexes[1]];
      PVector W = vertexes[indexes[2]];

      face.vertexes = new PVector[]{face.vertexes[indexes[0]], face.vertexes[indexes[1]], face.vertexes[indexes[2]]};

      if(W.z < 0){
        addFlowedFace(face);
      }

      else if(U.z > 0){
        continue;
      }

      else if(V.z < 0){
        PVector VW = PVector.lerp(face.vertexes[1], face.vertexes[2], -V.z / (W.z - V.z));
        PVector UW = PVector.lerp(face.vertexes[0], face.vertexes[2], -U.z / (W.z - U.z));

        addFlowedFace(new Face(face.vertexes[0], face.vertexes[1], VW, face.normal));
        addFlowedFace(new Face(UW, VW, face.vertexes[0], face.normal));
      }

      else{
        PVector UV = PVector.lerp(face.vertexes[0], face.vertexes[1], -U.z / (V.z - U.z));
        PVector UW = PVector.lerp(face.vertexes[0], face.vertexes[2], -U.z / (W.z - U.z)); 

        addFlowedFace(new Face(face.vertexes[0], UV, UW, face.normal));
      }
    }

    addForce(this.thrust.point, this.thrust.force);
    println(this.thrust.point, this.thrust.force);
    
    {
      PVector vectorGravity = new PVector(0, 0, -world.gravity);
      PVector acceleration = accumulateForce.copy()
                                            .div(mass)
                                            .add(vectorGravity)
                                            .mult(dt);

      velocity.add(acceleration)
              .mult(1 - velocityAttenuation);

      PVector positionShift = velocity.copy()
                                      .mult(dt);

      translateShip(positionShift);
    } 

    {
      PVector angularAcceleration = diagonalMult(invJ, accumulateAngularVelocity).mult(dt)
                                                                                 .mult(0.1);

      angularVelocity.add(angularAcceleration)
                     .mult(1 - angularAttenuation);

      PVector angularShift = angularVelocity.copy()
                                            .mult(dt);

      rotateVector(angularShift, angle);
      rotateShip(angularShift);
    }

    frame.draw();
  }
}
