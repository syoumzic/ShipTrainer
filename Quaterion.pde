public class Quaterion {
  float w, x, y, z;

  public Quaterion(float angle, PVector axes){
    this.w = cos(angle/2);

    float s = sin(angle/2);
    this.x = s*axes.x;
    this.y = s*axes.y;
    this.z = s*axes.z;
  }

  public Quaterion(PVector vector){
    this.w = 0;
    this.x = vector.x;
    this.y = vector.y;
    this.z = vector.z;
  }

  private Quaterion(float w, float x, float y, float z) {
    this.w = w;
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  public Quaterion H(Quaterion q){
    return new Quaterion(w*q.w - x*q.x - y*q.y - z*q.z,
                         w*q.x + x*q.w + y*q.z - z*q.y,
                         w*q.y - x*q.z + y*q.w + z*q.x,
                         w*q.z + x*q.y - y*q.x + z*q.w
                        ); 
  }

  public PVector toVector(){
    return new PVector(x, y, z);
  }

  private Quaterion conjugate(){
    return new Quaterion(w, -x, -y, -z);
  }

  public String toString(){
    return "(%f %f %f %f)".formatted(w, x, y, z);
  }
}