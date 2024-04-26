import processing.net.*;

class CustomServer{
  Server server;
  Water water;
  
  CustomServer(PApplet mainPApplet, Water water){
    server = new Server(mainPApplet, 12345);
    this.water = water;
  }
  
  void update(){
      Client client = server.available(); //<>//
      
      if(client != null){
        String input =  client.readString();
        String[] args = split(input, ' ');
        
        try{
          switch(args[0]){
            case "translate":
              water.translations = new Point3D<Integer>(int(args[1]), int(args[2]), int(args[3]));
            break; 
            
            case "angle":
              water.angle = float(args[1]);
            break;
            
            case "size":
              water.w = int(args[1]);
              water.h = int(args[2]);
            break;
            
            case "speed":
              water.speed = float(args[1]);
            break;
            
            case "smooth":
              water.smooth = float(args[1]);
            break;
            
            case "waterHeight":
              water.waterHeight = int(args[1]);
            break;
          }
      }catch(Exception e){
       println(e); 
      }
    }
  }
}
