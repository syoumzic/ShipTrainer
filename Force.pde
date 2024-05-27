public class Force{
    public final Vector point, force;
    public Force(Vector point, Vector force){
        this.point = point;
        this.force = force;
    }

    public Force(){
        this.point = new Vector(0,0,0);
        this.force = new Vector(0,0,0);
    }
    
    public void draw(){
      Vector a = point;
      Vector b = point.add(force.mult(0.1));
      line(a.x, a.y, a.z, b.x, b.y, b.z);
      pushMatrix();
      translate(b.x, b.y, b.z);
      box(0.001);
      popMatrix(); 
    }
}
