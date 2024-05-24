import processing.serial.*;
import java.lang.Thread;
import java.beans.PropertyChangeSupport;
import java.lang.ThreadDeath;

class Manipulator extends Thread{
    private boolean stop = false;
    private Serial serial = null;
    private final PropertyChangeSupport changeSupport;
    PApplet pApplet;
    PVector input;

    final int maxTimeConnected = 100;

    Manipulator(PApplet pApplet){
        this.pApplet = pApplet;
        this.input = new PVector();
        changeSupport = new PropertyChangeSupport(this);
    }

    public void addPropertyChangeListener(PropertyChangeListener listener){
        changeSupport.addPropertyChangeListener(listener);
    }

    public PVector getInput(){
        return input;
    }

    public boolean connected(){
        return serial != null;
    }

    public void reconnect(PApplet pApplet){
        String[] ports = Serial.list();
        
        if(ports.length > 0){
            try{
                serial = new Serial(pApplet, ports[ports.length - 1], 115200);
                println("successfully connected");
            }catch(RuntimeException e){
                println("port busy");
            }
        }
    }

    public void run(){
        while(!stop){
            if(!connected()){
                reconnect(pApplet);
            }
            else{
                serial.write((byte)0);
                
                int nx = serial.read();
                int ny = serial.read();

                if(ny == -1) continue;
                
                input.set(nx, ny);
                changeSupport.firePropertyChange("getInput", null, null);
            }
        }
    }

    public void exit(){
        if(serial != null){
            serial.stop();
        }

        stop = true;
    }
}