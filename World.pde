import java.util.List;
import peasy.*;

class World{
    private final PeasyCam cam;
    private final PVector eyePosition, lookAtPosition;
    private final List<Drawable> gameObjects = new ArrayList<>();
    private final Ship ship;
    private final Water water;

    public final float gravity;

    public final float landscapeWidth;
    public final float landscapeHeight;
    private final float aspect;
    private float zNear;
    private float zFar;

    private float fov;

    World(PApplet pApplet, Manipulator manipulator){
        cam = new PeasyCam(pApplet, 0.001);
        cam.setMinimumDistance(0);
        cam.setMinimumDistance(10);
        eyePosition = new PVector(2.09245, 4.1498, 1.3398);
        lookAtPosition = new PVector(2.09245, 3.311, 0.7858);

        landscapeWidth = 4.1849;
        landscapeHeight = 3.0422;

        gravity = 9.8;          //m/c^2

        fov = 0.46156168;
        // fov = 0.01;
        aspect = (float)width / height;
        zNear = 0.01;
        zFar = 10;

        gameObjects.add(new Light());
        gameObjects.add(water = new Water(this));

        // gameObjects.add(new Barrier());
        // gameObjects.add(new Barrier());
        gameObjects.add(ship = new Ship(this, water));
        
        manipulator.addPropertyChangeListener(ship);
    }

    public void draw(){
        background(#acacac);
        // translate(-world.landscapeWidth/2, -world.landscapeHeight/2, 0);
        // scale(100);
        // strokeWeight(0.01);
        camera(eyePosition.x, eyePosition.y, eyePosition.z, lookAtPosition.x, lookAtPosition.y, lookAtPosition.z, 0, 1, 0);
        perspective(fov, aspect, zNear, zFar);
        // perspective(PI/3.0,(float)width/height,0.1,100000);

        for(Drawable gameObject : gameObjects){
            gameObject.draw(); 
        }
    }

    public void mouseWheel(MouseEvent event) {
        fov += event.getCount() / 20f;
    }
}
