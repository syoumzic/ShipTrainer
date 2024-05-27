import java.util.Iterator;
import java.lang.Iterable;

public class Model implements Iterable<Face>{
    private List<Face> faces;
    private float S;
    
    public Model(PShape shapes){
        this.faces = new ArrayList<Face>(shapes.getChildCount());
        this.S = 0.0f;
        for(PShape shape : shapes.getChildren()){
            Face face = new Face(shape);
            S += face.area();
            this.faces.add(face);
        }
    }

    @Override
    public Iterator<Face>iterator(){
        return faces.iterator();
    }

    public void translate(Vector positionShift){
        for(Face face: faces){
            face.translate(positionShift);
        }
    }

    public void rotate(Vector angularShift){
        for(Face face: faces){
            face.rotate(angularShift);
        }
    }

    public void draw(){
        for(Face face: faces){
            face.draw();
        }
    }
}
