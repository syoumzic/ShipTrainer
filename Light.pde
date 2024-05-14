class Light implements Drawable{
    private PVector[] positions;
    private final int sunHeight = 1000;

    private final int red = 255;
    private final int green = 255;
    private final int blue = 255;

    Light(World world){
        positions = new PVector[]{new PVector(3.99, 0.02, 2.09), new PVector(0.12, 0.02, 2.09), new PVector(2.01, 5.45, 2.09)};
    }

    void draw(){
        lightFalloff(2, 0.001, 0.001);
        for(PVector position : positions){
            pointLight(red, green, blue, position.x, position.y, position.z);
        }
    }
}