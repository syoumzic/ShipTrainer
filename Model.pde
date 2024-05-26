import java.util.Iterator;
import java.lang.Iterable;

public class Model implements Iterable<Face>{
    private List<Face> faces;
    
    public Model(PShape shapes){
        this.faces = new ArrayList<Face>(shapes.getChildCount());

        for(PShape shape : shapes.getChildren()){
            this.faces.add(new Face(shape));
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
