public class Vector{
  final float x, y, z;
  public Vector(float x, float y, float z){
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  public Vector(PVector vector){
    this.x = vector.x;
    this.y = vector.y;
    this.z = vector.z;
  }
  
  public Vector(int x, int y, int z){
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  public Vector(){
    this.x = 0;
    this.y = 0;
    this.z = 0;
  }
  
  //TODO реализовать
  public Vector add(Vector vector){
     return new Vector(x + vector.x, y + vector.y, z + vector.z); 
  }
  
  public Vector sub(Vector vector){
     return new Vector(x - vector.x, y - vector.y, z - vector.z); 
  }
  
  public Vector mult(float value){
    return new Vector(value * x, value * y, value *  z); 
  }
  
  public Vector div(float value){
     return new Vector(x / value, y / value, z / value); 
  }
  
  public Vector scale(float scaleX, float scaleY, float scaleZ){
    return new Vector(x * scaleX, y * scaleY, z * scaleZ); 
  }

  private float relu(float value){
    return value > 0? value : 0; 
  }

  public Vector relu(){
    return new Vector(relu(x), relu(y), relu(z));
  }

  public Vector reluZ(){
    return new Vector(x, y, relu(z));
  }

  public Vector reluY(){
    return new Vector(x, relu(y), z);
  }

  public Vector reluX(){
    return new Vector(relu(x), y, z);
  }
  
  public Vector negative(){
    return this.mult(-1);
  }
  
  public Vector cross(Vector vector){
    return new Vector(y * vector.z - vector.y * z, - x * vector.z + vector.x * z, x * vector.y - vector.y * x);
  }
  
  public Vector rotateX(float angle){
    Quaternion quaternionX = new Quaternion(angle, VectorX(1));
    Quaternion point = new Quaternion(this);
    return quaternionX.H(point).H(quaternionX.conjugate()).toVector();
  }
  
  public Vector rotateY(float angle){
    Quaternion quaternionY = new Quaternion(angle, VectorY(1));
    Quaternion point = new Quaternion(this);
    return quaternionY.H(point).H(quaternionY.conjugate()).toVector();
  }
  
  public Vector rotateZ(float angle){
    Quaternion quaternionZ = new Quaternion(angle, VectorZ(1));
    Quaternion point = new Quaternion(this);
    return quaternionZ.H(point).H(quaternionZ.conjugate()).toVector();
  }
  
  public Vector rotate(Vector angle){
    return this.rotateX(angle.x).rotateY(angle.y).rotateZ(angle.z);
  }

  public float mag(){
    return sqrt(sq(this.x) + sq(this.y) + sq(this.z));
  }

  public String toString(){
    return "(%f %f %f)".formatted(x, y, z);
  }
}

public Vector VectorX(float x){
  return new Vector(x, 0, 0); 
}

public Vector VectorY(float y){
  return new Vector(0, y, 0); 
}

public Vector VectorZ(float z){
  return new Vector(0, 0, z); 
}

public Vector VectorAverage(Vector ...vectors){
  Vector average = new Vector();
  for(int i = 0; i < vectors.length; i++){
    average = average.add(vectors[i]);
  }
  return average.div(vectors.length);
}

public Vector diagonalMult(float[][] matrix, Vector a){
  return new Vector(matrix[0][0] * a.x, matrix[1][1] * a.y, matrix[2][2] * a.z);
}

public Vector VectorLerp(Vector a, Vector b, float value){
  return new Vector(lerp(a.x, b.x, value), lerp(a.y, b.y, value), lerp(a.z, b.z, value)); 
}
