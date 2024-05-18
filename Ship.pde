import java.util.Arrays;

class Ship implements Drawable {
  private final Manipulator manipulator;
  private final Water water;
  private final PShape body, frame;
  private final World world;

  private PVector direction, velocity;

  Ship(Water water, World world, Manipulator manipulator){
    this.direction = new PVector(1, 0, 0);
    this.world = world;

    PVector position = new PVector(2.03529, 1.86403, 0);
    
    this.frame = getShape("frame");
    checkModel(frame);
    translate(frame, position);
    
    this.body = getShape("ship");
    translate(body, position);
    
    this.manipulator = manipulator;
    this.water = water;
    water.splash(position.x, position.y);
  }

  private void checkModel(PShape shape){
    for(PShape face : shape.getChildren()){

      if(face.getVertexCount() != 3){
        throw new UnsupportedOperationException();
      }
    }
  }

  private void translate(PShape shape, PVector shift){
    PVector v = new PVector();
    
    for (PShape child : shape.getChildren()) {
      for (int vi = 0; vi < child.getVertexCount(); vi++) {
        child.getVertex(vi, v);
        v.add(shift);
        child.setVertex(vi, v.x, v.y, v.z);
      }
    }
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

    for(PShape face : frame.getChildren()){
      PVector[] vertex = new PVector[]{face.getVertex(0), face.getVertex(1), face.getVertex(2)};

      for(PVector v: vertex){
        v.z -= water.getHeightNear(v.x, v.y);
      }

      Arrays.sort(vertex, (PVector a, PVector b) -> (a.z - b.z < 0 ? -1 : 1));

      PVector L = vertex[0];
      PVector M = vertex[1];
      PVector H = vertex[2];

      float S;
      if(H.z < 0){
        S = traingaeArea(L, M, H);

        drawTriangle(L, M, H);
      }

      else if(L.z > 0){
        S = 0;
      }

      else if(M.z < 0){
        PVector MIm = PVector.lerp(M, H, -M.z / (H.z - M.z));
        PVector LIl = PVector.lerp(L, H, -L.z / (H.z - L.z));

        S = traingaeArea(L, M, MIm) + traingaeArea(LIl, MIm, L);

        drawTriangle(L, M, MIm);
        drawTriangle(LIl, MIm, L);
      }

      else{
        PVector LJm = PVector.lerp(L, M, -L.z / (M.z - L.z));
        PVector LJl = PVector.lerp(L, H, -L.z / (H.z - L.z)); 

        S = traingaeArea(L, LJl, LJm);

        drawTriangle(L, LJl, LJm);
      }

      PVector triangleCenter = avarage(L, M, H);
      float height = water.getHeightNear(triangleCenter.x, triangleCenter.y);

      float force = water.density * world.gravity;
    }
    // shape(body);
  }

  private PVector avarage(PVector... vectors){
    PVector avarage = new PVector();
    for(PVector v: vectors){
      avarage.add(v);
    }

    return avarage.div(vectors.length);
  }
}