import processing.serial.*;
import java.lang.Thread;
import java.beans.PropertyChangeSupport;

class Manipulator extends Thread{
    private Serial serial = null;
    private final PropertyChangeSupport changeSupport;
    PVector input;

    Manipulator(PApplet papplet){
        changeSupport = new PropertyChangeSupport(this);
        input = new PVector(127, 127);
        reconnect(papplet);
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

    public void reconnect(PApplet papplet){
        String[] ports = Serial.list();
        
        if(ports.length > 0){
            serial = new Serial(papplet, ports[ports.length - 1], 115200);
        }
        println("---------");
        println(ports);
        println("---------");
    }

    public void run(){
        while(true){
            if(serial != null){
                serial.write((byte)0);
                while(serial.available() < 2);

                int nx = serial.read();
                int ny = serial.read();

                if(ny == -1) continue;
                
                input.set(nx, ny);
                changeSupport.firePropertyChange("getInput", null, null);
            }
        }
    }

    public PVector getAccelerations(){
        if(serial != null){
            while(serial.available() < 2){
                serial.write((byte)0);
            }
            return new PVector(serial.read(), serial.read());
        }
        else {
            return new PVector(0, 0);
        }
    }

    public void exit(){
        if(serial != null){
            serial.stop();
        }
    }
}