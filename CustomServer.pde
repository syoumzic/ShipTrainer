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
        
        switch(args[0]){
          case "translate":
            water.translations = new Point<Float>(float(args[1]), float(args[2]), float(args[3]));
            water.rotations = new Point<Float>(float(args[4]), float(args[5]), float(args[6]));
          break; 
        }
      }
  }
}
