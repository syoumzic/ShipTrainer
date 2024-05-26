public class Face{
    private Vector[] vertexes;
    private Vector normal;

    public Face(Vector a, Vector b, Vector c, Vector normal){
        this.vertexes = new Vector[]{a, b, c};
        this.normal = normal;
    }
    
    public Face(PShape shape){
      if(shape.getVertexCount() != 3)
          throw new IllegalArgumentException("Invalid frame model");
                
      this.vertexes = new Vector[]{new Vector(shape.getVertex(0)), new Vector(shape.getVertex(1)), new Vector(shape.getVertex(2))};
      this.normal = VectorAverage(new Vector(shape.getNormal(0)), new Vector(shape.getNormal(1)), new Vector(shape.getNormal(2)));
    }

    public void translate(Vector positionShift){
        vertexes = new Vector[]{vertexes[0].add(positionShift), vertexes[1].add(positionShift), vertexes[2].add(positionShift)};
    }

    public void rotate(Vector angularShift){
        vertexes = new Vector[]{vertexes[0].rotate(angularShift), vertexes[1].rotate(angularShift), vertexes[2].rotate(angularShift)};
        normal = normal.rotate(angularShift);
    }

    public void draw(){
        stroke(#000000, 100);
        beginShape();
        {
            vertex(vertexes[0].x, vertexes[0].y, vertexes[0].z);
            vertex(vertexes[1].x, vertexes[1].y, vertexes[1].z);
            vertex(vertexes[2].x, vertexes[2].y, vertexes[2].z);
        }
        endShape();

        // Vector center = VectorAverage(vertexes);
        // Vector end = center.add(normal.mult(0.01));
        // line(center.x, center.y, center.z, end.x, end.y, end.z);
    }
    
    public Vector[] getVertex(){
       return vertexes; 
    }
    
    public float area(){
        return 0.5 * abs((vertexes[1].x - vertexes[0].x)*(vertexes[2].y - vertexes[0].y) - (vertexes[2].x - vertexes[0].x)*(vertexes[1].y - vertexes[0].y));
    }

    public String toString(){
        return "{%s %s %s %s}".formatted(vertexes[0].toString(), vertexes[1].toString(), vertexes[2].toString(), normal.toString());
    }
}
