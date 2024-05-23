import java.util.List;

class World{
    private final PVector eyePosition, lookAtPosition;
    private final List<Drawable> gameObjects = new ArrayList<>();
    private final Ship ship;
    private final Water water;

    public final float gravity;

    public final float landscapeWidth;
    public final float landscapeHeihgt;
    private final float aspect;
    private float zNear;
    private float zFar;

    private float fov;

    World(PApplet papplet, Manipulator manipulator){
        eyePosition = new PVector(2.09245, 4.1498, 1.3398);
        lookAtPosition = new PVector(2.09245, 3.311, 0.7858);

        landscapeWidth = 4.1849;
        landscapeHeihgt = 3.0422;

        gravity = 9.8;          //m/c^2

        fov = 0.46156168;
        // fov = 2;
        aspect = (float)width / height;
        zNear = 0.01;
        zFar = 10;

        gameObjects.add(new Light(this));
        gameObjects.add(water = new Water(this));
        
        gameObjects.add(new Barrier(water));
        gameObjects.add(new Barrier(water));
        gameObjects.add(ship = new Ship(this, water));
    }

    public void draw(){
        background(#acacac);

        camera(eyePosition.x, eyePosition.y, eyePosition.z, lookAtPosition.x, lookAtPosition.y, lookAtPosition.z, 0, 1, 0);
        perspective(fov, aspect, zNear, zFar);

        for(Drawable gameObject : gameObjects){
            gameObject.draw(); 
        }
    }

    public void mousePressed(){
        water.splash(landscapeWidth/2, landscapeHeihgt/2);
    }

    public void mouseWheel(MouseEvent event) {
        fov += event.getCount()/20f;
    }
}
