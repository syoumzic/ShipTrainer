public class Face{
    public PVector[] vertexes;
    public PVector normal;

    public Face(PVector a, PVector b, PVector c, PVector normal){
        this.vertexes = new PVector[]{a, b, c};
        this.normal = normal;
    }

    public void translate(PVector positionShift){
        for(PVector vertex: vertexes)
            vertex.add(positionShift);
    }

    public void rotate(PVector angularShift){
        for(PVector vertex: vertexes)
            rotateVector(vertex, angularShift);
        rotateVector(normal, angularShift);
    }

    public Face copy(){
        return new Face(vertexes[0].copy(), vertexes[1].copy(), vertexes[2].copy(), normal.copy());
    }

    public void draw(){
        fill(#ffffff);
        stroke(#000000);
        beginShape();
        {
            vertex(vertexes[0].x, vertexes[0].y, vertexes[0].z);
            vertex(vertexes[1].x, vertexes[1].y, vertexes[1].z);
            vertex(vertexes[2].x, vertexes[2].y, vertexes[2].z);
        }
        endShape();
    }

    public String toString(){
        return "{[%s] [%s] [%s] [%s]}".formatted(vertexes[0].toString(), vertexes[1].toString(), vertexes[2].toString(), normal.toString());
    }
}