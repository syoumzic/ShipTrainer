class Model implements Drawable{
    protected PVector position;
    private PShape body;
    
    Model(String path, float x, float y, float z){
        body = loadShape(path);
        position = new PVector(x, y, z);
    }

    void draw(){
        pushMatrix();

        translate(position.x, position.y, position.z);
        shape(body);

        popMatrix();
    }
}