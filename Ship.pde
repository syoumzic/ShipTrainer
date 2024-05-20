import java.util.Arrays;
import java.lang.Math;

class Ship implements Drawable {
  private final Manipulator manipulator;
  private final Water water;
  private final PShape body, frame;
  private final World world;
  private final float maxSpeed;
  private final float dt;

  private final float mass;

  private final float[][] J, invJ;
  private final PVector[] axes = new PVector[]{new PVector(1, 0, 0), new PVector(0, 1, 0), new PVector(0, 0, 1)};

  private PVector direction, velocity, acceleration, position, buoyantForce, angularVelocityAccumulate, angularVelocity;

  Ship(Water water, World world, Manipulator manipulator){
    this.mass = 0.1; //kg
    this.maxSpeed = 0.1;

    this.position = new PVector();
    this.direction = new PVector(1, 0, 0);
    this.velocity = new PVector();
    this.acceleration = new PVector();
    this.buoyantForce = new PVector();
    this.angularVelocity = new PVector();
    this.angularVelocityAccumulate = new PVector();
    this.dt = 1/240f;

    J = new float[][]{{0.00231187, 0, 0},
                      {0, 0.00043639, 0},
                      {0, 0, 0.02072078}};

    invJ = new float[][]{{432.54984909, 0, 0},
                         {0, 2291.51392886, 0},
                         {0, 0, 48.26072767}};

    this.world = world;
    this.water = water;
    this.manipulator = manipulator;

    this.frame = checkModel(getShape("frame"));
    this.body = getShape("ship");
    translateModel(new PVector(2.03529, 1.86403, 0));

    water.splash(position.x, position.y);
  }

  private PShape checkModel(PShape shape){
    for(PShape face : shape.getChildren()){

      if(face.getVertexCount() != 3){
        throw new UnsupportedOperationException();
      }
    }

    return shape;
  }

  private void translateModel(PVector shift){
    position.add(shift);
    body.translate(shift.x, shift.y, shift.z);

    PVector v = new PVector();
    for (PShape child : frame.getChildren()) {
      for (int vi = 0; vi < child.getVertexCount(); vi++) {
        child.getVertex(vi, v);
        v.add(shift);
        child.setVertex(vi, v.x, v.y, v.z);
      }
    }
  }

  private void rotateModel(PVector angularVelocity){
    rotateVector(direction, angularVelocity);
    
    body.translate(-position.x, -position.y, -position.z);
    body.rotateX(angularVelocity.x);
    body.rotateY(angularVelocity.y);
    body.rotateZ(angularVelocity.z);
    body.translate(position.x, position.y, position.z);

    PVector v = new PVector();
    for (PShape child : frame.getChildren()) {
      for (int vi = 0; vi < child.getVertexCount(); vi++) {
        child.getVertex(vi, v);

        v.sub(position);
        rotateVector(v, angularVelocity);
        v.add(position);

        child.setVertex(vi, v.x, v.y, v.z);
      }
    } 
  }

  private void rotateVector(PVector v, PVector angle) {
    Quaternion q = angleToQuaternion(angle);
    v = q.rotateVector(v);
  }

  private Quaternion angleToQuaternion(PVector angle) {
    float cx = cos(angle.x / 2);
    float cy = cos(angle.y / 2);
    float cz = cos(angle.z / 2);
    float sx = sin(angle.x / 2);
    float sy = sin(angle.y / 2);
    float sz = sin(angle.z / 2);
    
    Quaternion q = new Quaternion(
      sx * cy * cz + cx * sy * sz,
      cx * sy * cz - sx * cy * sz,
      cx * cy * sz + sx * sy * cz,
      cx * cy * cz - sx * sy * sz
    );
    
    return q;
  }

  private float traingaeArea(PVector a, PVector b, PVector c){
      return 0.5 * abs((b.x - a.x)*(c.y - a.y) - (c.x - a.x)*(b.y - a.y));
  }

  private PVector avarage(PVector... vectors){
    PVector avarage = new PVector();
    for(PVector v : vectors){
      avarage.x += v.x;
      avarage.y += v.y;
      avarage.z += v.z;
    }
    return avarage.div(vectors.length);
  }

  private void addWaterForce(PVector u, PVector v, PVector k, PVector normal){
    PVector point = avarage(u, v, k);
    float height = point.z - water.getHeightNear(point.x, point.y);
    
    PVector force = normal.mult(water.density)
                          .mult(world.gravity)
                          .mult(height)
                          .mult(traingaeArea(u, v, k));

    force.z = max(force.z, 0);
    addForce(force, point);
  }

  private void addForce(PVector force, PVector point){
    buoyantForce.add(force);

    PVector M = force.cross(point);
    angularVelocityAccumulate.add(M.sub(angularVelocity.cross(diagonalMult(angularVelocity, J))));
  }

  private PVector diagonalMult(PVector a, float[][] matrix){
    return new PVector(a.x * matrix[0][0], a.y * matrix[1][1], a.z * matrix[2][2]);
  }

  private void drawTriangle(PVector u, PVector v, PVector k){
    pushMatrix();
    noStroke();

    beginShape();
        vertex(u.x, u.y, u.z + water.getHeightNear(u.x, u.y));
        vertex(v.x, v.y, v.z + water.getHeightNear(v.x, v.y));
        vertex(k.x, k.y, k.z + water.getHeightNear(k.x, k.y));
    endShape();
    popMatrix();
  }

  public void draw(){
    fill(#00ff00);

    buoyantForce.set(0, 0, 0);
    angularVelocityAccumulate.set(0, 0, 0);

    for(PShape face : frame.getChildren()){
      PVector[] vertex = new PVector[]{face.getVertex(0), face.getVertex(1), face.getVertex(2)};

      for(PVector v: vertex){
        v.z -= water.getHeightNear(v.x, v.y);
      }

      Arrays.sort(vertex, (PVector a, PVector b) -> (a.z - b.z < 0 ? -1 : 1));

      PVector U = vertex[0];
      PVector V = vertex[1];
      PVector W = vertex[2];

      PVector normal = avarage(face.getNormal(0), face.getNormal(1), face.getNormal(2));

      if(W.z < 0){
        addWaterForce(U, V, W, normal);
        // drawTriangle(L, M, H);
      }

      else if(U.z > 0){
        continue;
      }

      else if(V.z < 0){
        PVector MIm = PVector.lerp(V, W, -V.z / (W.z - V.z));
        PVector LIl = PVector.lerp(U, W, -U.z / (W.z - U.z));

        addWaterForce(U, V, MIm, normal);
        addWaterForce(LIl, MIm, U, normal);

        // drawTriangle(L, M, MIm);
        // drawTriangle(LIl, MIm, L);
      }

      else{
        PVector LJm = PVector.lerp(U, V, -U.z / (V.z - U.z));
        PVector LJl = PVector.lerp(U, W, -U.z / (W.z - U.z)); 

        addWaterForce(U, LJl, LJm, normal);

        // drawTriangle(L, LJl, LJm);
      }
    }


    {
      PVector vectorGravity = new PVector(0, 0, -world.gravity);
      PVector acceleration = buoyantForce.copy()
                                         .div(mass)
                                         .add(vectorGravity)
                                         .mult(dt);

      velocity.add(acceleration);
      
      PVector move = velocity.copy()
                             .mult(dt);

      translateModel(move);
    } 

    {
      PVector angularAcceleration = diagonalMult(angularVelocityAccumulate, invJ).mult(dt);

      angularVelocity.add(angularAcceleration);

      PVector angularMove = angularVelocity.copy()
                                           .mult(dt);
      rotateModel(angularMove);
    }

    println(position, direction);
    shape(body);
  }
}