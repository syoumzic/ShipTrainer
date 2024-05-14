abstract class Model implements Drawable{
    private final PShape body;

    Model(PShape body){
        this.body = body;
    }

    public abstract void transformations();

    public void draw(){
        pushMatrix();

        transformations();
        shape(body);

        popMatrix();
    }
}