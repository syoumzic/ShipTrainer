import java.util.List;

class World{
    private final PVector eyePosition, lookAtPosition;
    private final List<Drawable> gameObjects = new ArrayList<>();
    private final Ship ship;

    public final float landscapeWidth;
    public final float landscapeHeihgt;
    private final float fov;
    private final float aspect;
    private float zNear;
    private float zFar;

    World(Manipulator manipulator){
        eyePosition = new PVector(2.0815, 4.1498, 1.3398);
        lookAtPosition = new PVector(2.0815, 3.311, 0.7858);

        landscapeWidth = 4.1849;
        landscapeHeihgt = 3.0422;

        fov = 0.46156168;
        aspect = (float)width / height;
        zNear = 0.01;
        zFar = 10;

        Light light = new Light(this);
        gameObjects.add(light);

        Water water = new Water(this);
        gameObjects.add(water);

        PShape barrierModel = loadShape("assets/barrier/barrier.obj");
        gameObjects.add(new Barrier(barrierModel, water, new PVector(1.7, 1.92)));
        gameObjects.add(new Barrier(barrierModel, water, new PVector(2.36, 1.92)));

        PShape shipModel = loadShape("assets/ship/ship.obj");
        gameObjects.add(ship = new Ship(shipModel, water, manipulator));
    }

    void update(){
        ship.update();
    }

    void draw(){
        camera(eyePosition.x, eyePosition.y, eyePosition.z, lookAtPosition.x, lookAtPosition.y, lookAtPosition.z, 0, 1, 0);
        perspective(fov, aspect, zNear, zFar);

        background(0);

        for(Drawable gameObject : gameObjects){
            gameObject.draw(); 
        }
    }
}