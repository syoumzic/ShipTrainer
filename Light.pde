class Light implements Drawable{
    private final PVector position;
    final int sunHeight = 1000;

    private final int red = 255;
    private final int green = 255;
    private final int blue = 255;

    Light(World world){
        position = new PVector(world.landscapeWidth/2, world.landscapeHeihgt/2, sunHeight);
    }

    void draw(){
        pointLight(red, green, blue, position.x, position.y, position.z);
    }
}