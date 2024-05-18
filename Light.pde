class Light implements Drawable{
    private PVector[] positions;

    Light(World world){
        positions = new PVector[]{new PVector(3.99, 0.02, 2.09), new PVector(0.12, 0.02, 2.09), new PVector(2.09, 5.88, 4.02)};
    }

    public void draw(){
        lightFalloff(0.81, 0, 0.085);

        for(PVector position: positions){
            pointLight(255, 255, 255, position.x, position.y, position.z);
        }
    }
}