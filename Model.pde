import java.util.Iterator;
import java.lang.Iterable;

public class Model implements Iterable<Face>{
    private Face[] faces;
    
    public Model(PShape shape){
        this.faces = new Face[shape.getChildCount()];

        for(int i = 0; i < shape.getChildCount(); i++){
            PShape vertexes = shape.getChild(i);

            if(vertexes.getVertexCount() != 3)
                throw new IllegalArgumentException("Invalid frame model");

            this.faces[i] = new Face(vertexes.getVertex(0), vertexes.getVertex(1), vertexes.getVertex(2),
                                     avarage(vertexes.getNormal(0), vertexes.getNormal(1), vertexes.getNormal(2)));
        }
    }

    @Override
    public Iterator<Face>iterator(){
        return new PVectorIterator();
    }

    public void translate(PVector positionShift){
        for(Face face: faces){
            face.translate(positionShift);
        }
    }

    public void rotate(PVector angularShift){
        for(Face face: faces){
            face.rotate(angularShift);
        }
    }

    public void draw(){
        for(Face face: faces){
            face.draw();
        }
    }

    class PVectorIterator implements Iterator<Face>{
        private int index = 0;

        @Override
        boolean hasNext(){
            return index < faces.length;
        }

        @Override
        Face next(){
            return Model.this.faces[index++].copy();
        }
    }
}