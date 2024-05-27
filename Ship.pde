import java.util.Arrays;
import java.lang.Math;
import java.beans.*;

class Ship implements Drawable, PropertyChangeListener{
  private final float mass;
  private final float dt;
  private final float thrustForceValue;
  private final float velocityAttenuation, angularAttenuation;

  private final Water water;
  private final PShape body;
  private final Model frame;
  private final World world;
  
  private final float[][] J, invJ;

  private Vector angle, enginePosition, position, velocity, angularVelocity, accumulateForce, accumulateRotations;
  private Force thrustForce;
  private float thrustRotate;

  private float accumulateFloatArea;
  private float shipArea;

  Ship(World world, Water water){
    this.mass = 0.1; //kg
    this.thrustForceValue = 0.5; //N
    this.dt = 1/60f;
    this.velocityAttenuation = 0.4f;
    this.angularAttenuation = 0.4f;

    this.angle = new Vector(0, 0, 0);
    this.position = new Vector(0, 0, 0);
    this.velocity = new Vector(0, 0, 0);
    this.angularVelocity = new Vector(0, 0, 0);
    this.enginePosition = new Vector(-0.2, 0, 0);
    
    this.thrustForce = new Force();
    this.thrustRotate = 0;

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
    translateShip(new Vector(2.03529, 1.86403, -0.05));
  }

  private void engineUpdate(){
    addForce(thrustForce.point, thrustForce.force);
    accumulateRotations = accumulateRotations.add(VectorZ(thrustRotate));
  }
  
  private void applyThrustForce(float nx, float ny){
    float acrossLength = relu(map(ny, 160, 255, 0, thrustForceValue));
    Vector acrossForce = VectorX(acrossLength).rotateZ(angle.z);
    this.thrustForce = new Force(new Vector(enginePosition.x, enginePosition.y, position.z), acrossForce);
    this.thrustRotate = map(nx, 155, 255, 0, 1) * this.thrustForce.force.mag();
  }
  
  public void propertyChange(PropertyChangeEvent evt) {
    Manipulator manipulator = (Manipulator) evt.getSource();
    applyThrustForce(manipulator.getNx(), manipulator.getNy());
  }

  private void translateShip(Vector positionShift){
    position = position.add(positionShift);
    enginePosition = enginePosition.add(positionShift);
    frame.translate(positionShift);
  }

  private void rotateShip(Vector angularShift){
    angle = angle.add(angularShift);

    frame.translate(new Vector(-position.x, -position.y, -position.z));
    frame.rotate(angularShift);
    frame.translate(new Vector(position.x, position.y, position.z));

    enginePosition = enginePosition.sub(position)
                                   .rotate(angularShift)
                                   .add(position);
  }

  private void accumulateReset(){  
    accumulateForce = new Vector();
    accumulateRotations = new Vector();
  }

  //force задана в ск1 point тоже
  private void addForce(Vector point, Vector force){
    // new Force(point, force).draw();

    accumulateForce = accumulateForce.add(force);

    point = point.sub(position).rotate(angle.negative());
    force = force.rotate(angle.negative());

    Vector M = point.cross(force);
    Vector R = M.sub(angularVelocity.cross(diagonalMult(J, angularVelocity)));
    accumulateRotations = accumulateRotations.add(R);
  }

  private void addFlowedFace(Face face){
    // face.draw();
    accumulateFloatArea += face.area();

    Vector center = VectorAverage(face.vertexes[0], face.vertexes[1], face.vertexes[2]);
    float height = water.getHeightNear(center.x, center.y) - center.z;
    
    Vector force = face.normal.negative()
                              .mult(water.density)
                              .mult(world.gravity)
                              .mult(relu(height))
                              .mult(face.area())
                              .reluZ();

    addForce(center, force);
  }
  
  private void waterlation(){
    for(Face face : frame){
      final Vector[] vertexes = face.vertexes;
      
      float[] z = new float[3];
      for(int i = 0; i < 3; i++){
        z[i] = vertexes[i].z - water.getHeightNear(vertexes[i].x, vertexes[i].y);
      }
      Integer[] indexes = new Integer[]{0, 1, 2};
      Arrays.sort(indexes, (Integer ia, Integer ib) -> (z[ia] < z[ib]? -1 : 1));
      
      Vector L = vertexes[indexes[0]];
      Vector M = vertexes[indexes[1]];
      Vector H = vertexes[indexes[2]];

      float hl = z[indexes[0]];
      float hm = z[indexes[1]];
      float hh = z[indexes[2]];

      if(hh < 0){
        addFlowedFace(face);
      }

      else if(hl > 0){
        continue;
      }

      else if(hm < 0){
        Vector MI = VectorLerp(M, H, -hm / (hh - hm));
        Vector LI = VectorLerp(L, H, -hl / (hh - hl));

        addFlowedFace(new Face(L, M, MI, face.normal));
        addFlowedFace(new Face(MI, LI, L, face.normal));
      }

      else{
        Vector MJ = VectorLerp(L, M, -hl / (hm - hl)); 
        Vector HJ = VectorLerp(L, H, -hl / (hh - hl));

        addFlowedFace(new Face(L, MJ, HJ, face.normal));
      }
    }

    addForce(position.add(VectorZ(1)), VectorZ(-world.gravity * mass));
  }
  
  private void summarizeForce(){
      Vector acceleration = accumulateForce.div(mass)
                                           .mult(dt);

      velocity = velocity.add(acceleration)
                         .mult(1 - velocityAttenuation);

      Vector dumpForce = velocity.negative();

      Vector positionShift = velocity.mult(dt);

      translateShip(positionShift);
  }
  
  private void summarizeRotation(){
    Vector angularAcceleration = diagonalMult(invJ, accumulateRotations).mult(dt).mult(0.1);

    angularVelocity = angularVelocity.add(angularAcceleration)
                                     .mult(1 - angularAttenuation);

    angularVelocity = VectorLerp(angularVelocity, angle.negative(), 0.1);
    
    
    Vector angularShift = angularVelocity.mult(dt)
                                         .rotate(angle.negative());

    rotateShip(angularShift);
  }

  public void draw(){
    accumulateReset();
    waterlation();
    engineUpdate();
    summarizeForce();
    // summarizeRotation();
    frame.draw();
  }
}
